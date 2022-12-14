import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import "package:flutter/material.dart";
import 'package:shopp/models/CartProductModel.dart';
import 'package:shopp/models/ProductModel.dart';
import 'package:shopp/providers/CartProductProvider.dart';
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

import '../models/OrderModel.dart';
import '../utils/ConstantBaseUrl.dart';

class OrderProvider with ChangeNotifier {
  final _url = "${ConstantBaseUrl.baseUrl}/order";
  late final String? userId;
  late final String token;
  final date = DateTime.now();
  List<OrderModel> order = [];

  OrderProvider({required this.token, required this.order, this.userId});

  List<OrderModel> getAllOrder() => [...order];

  int get orderLenght {
    return order.length;
  }

  Future<void> loadOrderOnFirebase() async {
    try {
      //toda vez que carregar a lista preciso garantir que esteja vazia
      final List<OrderModel> orderRersed = [];
      final responseFirebase =
          await http.get(Uri.parse("$_url/$userId.json?auth=$token"));
      final productsFirebase =
          jsonDecode(responseFirebase.body) as Map<String, dynamic>;
      print("$productsFirebase products");
      if (productsFirebase != 'Null') {
        //no map o foreach retorna dois valores primeiro
        //e a primeiro valor da chave  o segundo sao os values
        // Map<String, dynamic>
        productsFirebase.forEach((productId, value) {
          orderRersed.add(OrderModel(
            id: productId,
            date: DateTime.parse(value["date"]),
            total: value["total"],
            products: (value["products"] as List<dynamic>)
                .map(
                  (it) => CartProductModel(
                      id: it["id"] as String,
                      name: it["name"] as String,
                      price: it["price"] as double,
                      productId: it["productId"] as String,
                      quantity: it["quantity"] as int),
                )
                .toList(),
          ));
        });
        order = orderRersed.reversed.toList();
        notifyListeners();
      }
      print(productsFirebase);
    } catch (e) {
      print(e.toString());
    }

    // _products.add(jsonDecode(productsFirebase.body));
  }

  Future<void> addOder(CartProductProvider cart) async {
    final response =
        await http.post(Uri.parse("$_url/$userId.json?auth=$token"),
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
    order.insert(
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
