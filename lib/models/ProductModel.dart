import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

import '../utils/ConstantBaseUrl.dart';

class ProductModel with ChangeNotifier {
  final _url = "${ConstantBaseUrl.baseUrl}/shoop";
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

  Future<void> toogleIsFavorite() async {
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      await http
          .patch(Uri.parse("$_url/$id.json"),
          body: jsonEncode({"isFavorite": isFavorite}))
          .catchError((error) => print(error));
    } catch (error) {
      print(error);
    }
  }
}
