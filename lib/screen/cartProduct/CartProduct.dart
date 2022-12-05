import 'package:flutter/material.dart';
import 'package:shopp/components/singleCartProduct/SingleCartProduct.dart';
import 'package:shopp/providers/CartProductProvider.dart';
import "package:provider/provider.dart";
import 'package:shopp/providers/OrderProvider.dart';
import "../../models/CartProductModel.dart";

class CartProduct extends StatelessWidget {
  const CartProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProductProvider cartProvider = Provider.of(context);
    OrderProvider order = Provider.of(context);
    //values e uma propriedade do Map,retorna os valores do map
    List<CartProductModel> cartModel =
    cartProvider
        .getAllProcut()
        .values
        .toList();

    void handlePurchase() {
      order.addOder(cartProvider);
      cartProvider.clearList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: Column(children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Chip(
                  label: Text(
                    "R\$ ${cartProvider.shouldReturnTotalPrice.toStringAsFixed(
                        2)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.purple,
                ),
                const Spacer(),
                TextButton(
                    onPressed: handlePurchase,
                    child: const Text(
                      "COMPRAR",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: cartModel.length,
                itemBuilder: (ctx, index) =>
                    SingleCartProduct(cartModel[index])))
      ]),
    );
  }
}
