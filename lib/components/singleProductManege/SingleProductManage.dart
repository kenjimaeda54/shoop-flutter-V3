import "package:flutter/material.dart";
import 'package:shopp/models/ProductModel.dart';
import 'package:shopp/providers/ProductListProvider.dart';
import 'package:shopp/utils/ConstantsRoutes.dart';
import "package:provider/provider.dart";

class SingleProductManage extends StatelessWidget {
  final ProductModel product;

  const SingleProductManage(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductListProvider productList = Provider.of(context);

    void handleNavigation() {
      Navigator.of(context)
          .pushNamed(ConstantRoutes.formProduct, arguments: product);
    }

    void handlePop(bool status) {
      if (status) {
        productList.removeProduct(product);
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).pop();
    }

    void handleDelteProduct() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Deseja excluir"),
                content: const Text("Apos feito não sera possivel reverter"),
                actions: [
                  TextButton(
                      onPressed: () => handlePop(false),
                      child: const Text("Cancelar")),
                  TextButton(
                      onPressed: () => handlePop(true),
                      child: const Text("Confirmar"))
                ],
              ));
    }

    return ListTile(
        //se for colocar uma imagem dentro do circle usando backgorundImage
        //precisa usar construtor NetworkImage
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        //se for colocar row dentro do trailling precisa declar um width
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: handleNavigation,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: handleDelteProduct,
              )
            ],
          ),
        ));
  }
}
