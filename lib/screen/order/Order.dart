import "package:flutter/material.dart";
import 'package:shopp/components/appDrawer/AppDrawer.dart';
import 'package:shopp/providers/OrderProvider.dart';
import "package:provider/provider.dart";
import '../../components/singleOrder/SingleOrder.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Order"),
        centerTitle: true,
      ),
      //maneira mais simples de lidar com requisições e arvore de componetentes Future Builder
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false)
            .loadOrderOnFirebase(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Ocorreu error"));
          }
          return Consumer<OrderProvider>(
            builder: (ctx, orders, _) => ListView.builder(
                itemCount: orders.getAllOrder().length,
                itemBuilder: (ctx, index) =>
                    SingleOrder(orders.getAllOrder()[index])),
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
