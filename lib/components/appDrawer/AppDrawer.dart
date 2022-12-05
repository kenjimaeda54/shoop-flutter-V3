import 'package:flutter/material.dart';
import 'package:shopp/utils/ConstantsRoutes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleNavigation(String routes) {
      Navigator.of(context).pushReplacementNamed(routes);
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Seja bem vindo"),
            backgroundColor: Theme.of(context).primaryColor,
            //remover o icone que e aplicado automatico no header
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: const Icon(
                Icons.shop,
              ),
              title: const Text("Loja"),
              onTap: () => handleNavigation(ConstantRoutes.homeScreen)),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.credit_card,
            ),
            title: const Text("Pedidos"),
            onTap: () => handleNavigation(ConstantRoutes.oder),
          ),
          ListTile(
            leading: const Icon(
              Icons.credit_card,
            ),
            title: const Text("Gerenciar Pedidos"),
            onTap: () => handleNavigation(ConstantRoutes.manageProduct),
          ),
        ],
      ),
    );
  }
}
