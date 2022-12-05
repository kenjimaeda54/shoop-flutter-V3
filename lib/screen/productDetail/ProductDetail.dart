import 'package:flutter/material.dart';
import 'package:shopp/models/ProductModel.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(product.imageUrl),
          ),
          const SizedBox(height: 20),
          Text("R\$ ${product.price.toStringAsFixed(2)}"),
          Text(product.description)
        ]),
      ),
    );
  }
}
