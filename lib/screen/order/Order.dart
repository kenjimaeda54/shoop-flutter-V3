import "package:flutter/material.dart";
import 'package:shopp/components/appDrawer/AppDrawer.dart';
import 'package:shopp/models/OrderModel.dart';
import 'package:shopp/providers/OrderProvider.dart';
import "package:provider/provider.dart";

import '../../components/singleOrder/SingleOrder.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderProvider orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Order"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: orders.getAllOrder().length,
          itemBuilder: (ctx, index) =>
              SingleOrder(orders.getAllOrder()[index])),
      drawer: const AppDrawer(),
    );
  }
}
