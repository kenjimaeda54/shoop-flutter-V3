import 'package:flutter/material.dart';
import 'package:shopp/models/CartProductModel.dart';
import 'package:shopp/providers/CartProductProvider.dart';
import 'package:shopp/providers/ProductListProvider.dart';
import 'package:shopp/models/ProductModel.dart';
import '../../components/singleProduct/SingleProduct.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showAllProducts;

  const ProductGrid(this.showAllProducts, {super.key});

  @override
  Widget build(BuildContext context) {
    final ProductListProvider stateProduct = Provider.of(context);
    List<ProductModel> products =
    showAllProducts ? stateProduct.getItens() : stateProduct.getItensFilter();

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),

        //estou enviando pelo crate do ChangenOtifier o product ao componente
        //SingleShop

        //uso o value,porque já existe um changeNotifierProvider fornecendo
        //uma coleção no main.dart
        itemBuilder: (ctx, index) =>
            ChangeNotifierProvider.value(
                value: products[index], child: const SingleShop()));
  }
}
