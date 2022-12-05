import 'package:flutter/material.dart';
import 'package:shopp/components/badge/Badge.dart';
import 'package:shopp/models/CartProductModel.dart';
import "package:provider/provider.dart";
import 'package:shopp/providers/CartProductProvider.dart';
import 'package:shopp/utils/ConstantsRoutes.dart';
import '../../components/appDrawer/AppDrawer.dart';
import '../../components/productGrid/ProductGrid.dart';

enum FavoritesOrNo {
  showAll,
  showFavorites,
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showAllProducts = true;

  void handlePopUpMenu(FavoritesOrNo value) {
    //name ira trazer showAll ou showFavorites pois são as propriedades que estão no enum
    //muito parecido com swift,possuo tambem o hashCode e o index
    setState(() {
      _showAllProducts = value.index == 0;
    });
  }

  void handleNavigation() {
    Navigator.of(context).pushNamed(ConstantRoutes.cartProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: const Text("Minha loja"),
        actions: [
          PopupMenuButton<FavoritesOrNo>(
              onSelected: (FavoritesOrNo value) => handlePopUpMenu(value),
              itemBuilder: (_) =>
              [
                const PopupMenuItem(
                  value: FavoritesOrNo.showAll,
                  child: Text("Mostrar todos"),
                ),
                const PopupMenuItem(
                  value: FavoritesOrNo.showFavorites,
                  child: Text("Mostrar favoritos"),
                )
              ]),
          //quem vai mandar o valor para badge este componente então obvio que consumer
          //ficara aqui
          Consumer<CartProductProvider>(
            child: IconButton(
                onPressed: handleNavigation,
                icon: const Icon(Icons.shopping_cart)),
            builder: (ctx, card, child) =>
                Badge(
                  value: "${card.itemCount}",
                  child: child!,
                ),
          )
        ],
      ),
      body: ProductGrid(_showAllProducts),
      drawer: const AppDrawer(),
    );
  }
}
