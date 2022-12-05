import 'dart:math';

import "package:flutter/material.dart";
import 'package:shopp/models/CartProductModel.dart';
import 'package:shopp/providers/CartProductProvider.dart';

import '../models/OrderModel.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _order = [];

  List<OrderModel> getAllOrder() => [..._order];

  int get orderLenght {
    return _order.length;
  }

  void addOder(CartProductProvider cart) {
    //assim sempre ficara ordernado
    _order.insert(
      0,
      OrderModel(
          id: "${Random().nextDouble()}-${_order.length}-${Random().nextDouble()}",
          total: cart.shouldReturnTotalPrice,
          //values e os valores da chave do dicionario ou seja o proprio Cart
          products: cart.getAllProcut().values.toList(),
          date: DateTime.now()),
    );
  }
}
