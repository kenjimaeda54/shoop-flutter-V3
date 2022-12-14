import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

import '../utils/ConstantBaseUrl.dart';

class ProductModel with ChangeNotifier {
  final _url = "${ConstantBaseUrl.baseUrl}/favoritePerUses";
  late final String id;
  late final String title;
  late final String description;
  late final double price;
  late final String imageUrl;
  late bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toogleIsFavorite(String token, String uid) async {
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      //ao fazer put com id do usaruio ele ira criar um documento
      //com id do usuario

      //com flutter firebase trabalha em chave e valor
      //estou pegando o id do produto e fazendo que ele se torne a chave
      //por isso e so passado isFavorite e metodo e put
      //put não posso inserir a chave sera o parametro passado na url
      await http
          .put(Uri.parse("$_url/$uid/$id.json?auth=$token"),
              body: jsonEncode(isFavorite))
          .catchError((error) => print(error));
    } catch (error) {
      print(error);
    }
  }
}
