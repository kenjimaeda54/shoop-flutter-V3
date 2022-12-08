import 'dart:convert';
import 'dart:math';
import "package:flutter/material.dart";
import 'package:shopp/models/ProductModel.dart';
import 'package:shopp/providers/CartProductProvider.dart';
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

import '../models/OrderModel.dart';
import '../utils/ConstantBaseUrl.dart';

class OrderProvider with ChangeNotifier {
  final _url = "${ConstantBaseUrl.baseUrl}/order.json";
  final date = DateTime.now();
  final List<OrderModel> _order = [];

  List<OrderModel> getAllOrder() => [..._order];

  int get orderLenght {
    return _order.length;
  }

  Future<void> addOder(CartProductProvider cart) async {
    final response = await http.post(Uri.parse(_url),
        body: jsonEncode({
          "total": cart.shouldReturnTotalPrice,
          //values e os valores da chave do dicionario ou seja o proprio Cart
          "products": cart
              .getAllProcut()
              .values
              //retornar um novo dicionario
              .map((it) => {
                    "id": it.id,
                    "name": it.name,
                    "price": it.price,
                    "quantity": it.quantity,
                    "productId": it.productId,
                  })
              .toList(),
          "date": date.toIso8601String(),
        }));

    //assim sempre ficara ordernado
    final id = jsonDecode(response.body)["name"] as String;
    _order.insert(
      0,
      OrderModel(
          id: id,
          total: cart.shouldReturnTotalPrice,
          //values e os valores da chave do dicionario ou seja o proprio Cart
          products: cart.getAllProcut().values.toList(),
          date: DateTime.now()),
    );
    notifyListeners();
  }
}
