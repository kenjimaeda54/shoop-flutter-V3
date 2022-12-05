import "package:flutter/material.dart";
import 'package:shopp/models/OrderModel.dart';
import "package:intl/intl.dart";

class SingleOrder extends StatefulWidget {
  final OrderModel order;

  const SingleOrder(this.order, {super.key});

  @override
  State<SingleOrder> createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    void handleExpanded() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return Card(
      child: Column(children: [
        ListTile(
            title: Text("R\$ ${widget.order.total.toStringAsFixed(2)}"),
            subtitle:
                Text(DateFormat("dd/MM/yyyy  HH:mm").format(widget.order.date)),
            trailing: IconButton(
                onPressed: handleExpanded,
                icon: const Icon(Icons.expand_more))),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            height: (widget.order.products.toList().length * 40) + 10,
            child: ListView(
              children: widget.order.products
                  .map((it) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            it.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${it.quantity}x ${it.price.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
