import "package:flutter/material.dart";
import 'package:shopp/components/appDrawer/AppDrawer.dart';
import 'package:shopp/components/singleProductManege/SingleProductManage.dart';
import 'package:shopp/providers/ProductListProvider.dart';
import "package:provider/provider.dart";
import 'package:shopp/utils/ConstantsRoutes.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductListProvider products = Provider.of(context);

    void handleNavigation() {
      Navigator.of(context).pushNamed(ConstantRoutes.formProduct);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar produtos"),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        centerTitle: true,
        actions: [
          IconButton(onPressed: handleNavigation, icon: const Icon(
              Icons.add
          ))
        ],
      ),
      body: ListView.builder(
        itemCount: products.shouldReturnTotalOfProducts,
        itemBuilder: (ctx, index) =>
            Column(
              children: [
                SingleProductManage(products.getItens()[index]),
                const Divider()
              ],
            ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
