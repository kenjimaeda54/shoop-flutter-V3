import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
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

  void toogleIsFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
