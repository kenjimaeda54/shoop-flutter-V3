import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shopp/providers/CartProductProvider.dart';
import '../../models/CartProductModel.dart';

class SingleCartProduct extends StatelessWidget {
  final CartProductModel cartModel;

  const SingleCartProduct(this.cartModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //de preferencia deixar aqui no topo para sempre ser chamdo
    CartProductProvider cartProvider = Provider.of(context);

    void handleDeleteCart() {
      cartProvider.removeItemOfList(cartModel.productId);
    }

    void handlePop(bool status) {
      Navigator.of(context).pop(status);
    }

    Future<bool?> handleConfirmDelete() {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Tem certeza que deseja excluir?"),
                content: const Text("Apos excluir não sera possivel reverter"),
                actions: [
                  TextButton(
                      onPressed: () => handlePop(true),
                      child: const Text("Sim")),
                  TextButton(
                      onPressed: () => handlePop(false),
                      child: const Text("Não"))
                ],
              ));
    }

    return Dismissible(
      key: Key(cartModel.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.delete,
          size: 23,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => handleDeleteCart(),
      confirmDismiss: (_) => handleConfirmDelete(),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: ListTile(
          trailing: Text("${cartModel.quantity}x"),
          title: Text(cartModel.name),
          subtitle: Text("Total R\$ ${cartModel.price * cartModel.quantity}"),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                    child: Text(
                  "${cartModel.price}",
                  style: const TextStyle(color: Colors.white),
                ))),
          ),
        ),
      ),
    );
  }
}
