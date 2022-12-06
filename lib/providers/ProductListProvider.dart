import 'dart:convert';

import 'package:flutter/material.dart';
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
  final _url = "${ConstantBaseUrl.baseUrl}/blablabal.json";

  //se eu chamar apaenas products ao inves [...products]
  //esterei criando uma inferencia e minha lista original não ira atualizar
  //dessa maneria de fato sera a lista verdadeira
  List<ProductModel> getItens() => [..._products];

  int get shouldReturnTotalOfProducts {
    return _products.length;
  }

  List<ProductModel> getItensFilter() =>
      mockShop.where((it) => it.isFavorite).toList();

  void loadProdcutsOnFirebase(Function(bool status) completion) async {
    try {
      //toda vez que carregar a lista preciso garantir que esteja vazia
      _products.clear();
      final responseFirebase = await http.get(Uri.parse(_url));
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
        completion(true);
      }
    } catch (e) {
      print(e.toString());
      completion(false);
    }

    // _products.add(jsonDecode(productsFirebase.body));
  }

  void addProdct(ProductModel product, Function(bool status) completion) {
    http
        .post(
      //estou usando real time
      //a partir do / e considerado uma coleção
      //.json essencial
      Uri.parse(_url),
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

  void updateProduct(ProductModel productModel) {
    //se não achar retornara -1
    final hasIndex = _products.indexWhere((it) => it.id == productModel.id);
    if (hasIndex >= 0) {
      _products[hasIndex] = productModel;
    }
    notifyListeners();
  }

  void removeProduct(ProductModel productModel) {
    //se não achar retornara -1
    final hasIndex = _products.indexWhere((it) => it.id == productModel.id);
    if (hasIndex >= 0) {
      _products.removeWhere((it) => it.id == productModel.id);
    }
    notifyListeners();
  }
}
