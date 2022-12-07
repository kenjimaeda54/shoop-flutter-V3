import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopp/httpException/CustomHttpException.dart';
import 'package:shopp/utils/ConstantBaseUrl.dart';
import '../data/products.dart';
import '../models/ProductModel.dart';
import "package:http/http.dart" as http;

//ChangeNotifier e um mixin
//mixin e como se eu copiasse as funcionalidades do arquivo que creiei
//e colase em um arquivo que esta usando ele
// ou seja ProductList
//mixin usa palavra with

//Em Dart não aceita multiplas heranças, mas com
//mixin eu consigo varios minxin
//https://www.treinaweb.com.br/blog/o-que-sao-mixins-e-qual-sua-importancia-no-dart
//resumindo estou pegando as funicionalidades do ChangeNotificer e disponibilizando para nos
class ProductListProvider with ChangeNotifier {
  final List<ProductModel> _products = [];
  final _url = "${ConstantBaseUrl.baseUrl}/shoop";

  //se eu chamar apaenas products ao inves [...products]
  //esterei criando uma inferencia e minha lista original não ira atualizar
  //dessa maneria de fato sera a lista verdadeira
  List<ProductModel> getItens() => [..._products];

  int get shouldReturnTotalOfProducts {
    return _products.length;
  }

  List<ProductModel> getItensFilter() =>
      mockShop.where((it) => it.isFavorite).toList();

  Future<void> loadProdcutsOnFirebase() async {
    try {
      //toda vez que carregar a lista preciso garantir que esteja vazia
      _products.clear();
      final responseFirebase = await http.get(Uri.parse("$_url.json"));
      final productsFirebase = jsonDecode(responseFirebase.body);
      if (productsFirebase != 'Null') {
        //no map o foreach retorna dois valores primeiro
        //e a primeiro valor da chave  o segundo sao os values
        // Map<String, dynamic>
        productsFirebase.forEach((productId, value) {
          _products.add(ProductModel(
            id: productId,
            title: value["name"],
            description: value["description"],
            price: value["price"],
            imageUrl: value["imageUrl"],
            isFavorite: value["isFavorite"],
          ));
        });
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }

    // _products.add(jsonDecode(productsFirebase.body));
  }

  void addProdct(ProductModel product, Function(bool status) completion) {
    http
        .post(
      //estou usando real time
      //a partir do / e considerado uma coleção
      //.json essencial
      Uri.parse("$_url.json"),
      body: jsonEncode({
        "name": product.title,
        "imageUrl": product.imageUrl,
        "description": product.description,
        "price": product.price,
        "isFavorite": product.isFavorite,
      }),
    )
        .then((response) {
      final id = jsonDecode(response.body)["name"];
      var singleProduct = ProductModel(
          id: id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _products.add(singleProduct);
      completion(true);
      //esse metodo e do mixin
      //toda vez que algo ocorrer neste arquivo preciso notificar
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      completion(false);
      return error;
    });
  }

  bool hasProduct(Map<String, Object> productModel) {
    return _products
            .indexWhere((element) => element.id == productModel["id"]) >=
        0;
  }

  Future<void> updateProduct(ProductModel productModel) async {
    //se não achar retornara -1
    final hasIndex = _products.indexWhere((it) => it.id == productModel.id);
    if (hasIndex >= 0) {
      await http.patch(
        Uri.parse("$_url/${productModel.id}.json"),
        body: jsonEncode({
          "name": productModel.title,
          "imageUrl": productModel.imageUrl,
          "description": productModel.description,
          "price": productModel.price,
        }),
      );

      _products[hasIndex] = productModel;
    }
    notifyListeners();
  }

  Future<void> removeProduct(ProductModel productModel) async {
    //se não achar retornara -1
    final hasIndex = _products.indexWhere((it) => it.id == productModel.id);
    if (hasIndex >= 0) {
      final product = _products[hasIndex];
      _products.remove(product);
      notifyListeners();

      final response =
          await http.delete(Uri.parse("$_url/${productModel.id}.json"));

      //erros 400 lado do cliente
      //erros 500 lado do servidor
      if (response.statusCode > 400) {
        _products.insert(hasIndex, product);
        notifyListeners();
        //lancando meu proprio erro a partir da interface Exception
        throw CustomHttpException(
            message: "Não foi possivel deletar produto",
            statusCode: response.statusCode);
      }
    }
  }
}
