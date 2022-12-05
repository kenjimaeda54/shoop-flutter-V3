import 'package:flutter/material.dart';
import 'package:shopp/providers/CounterProvider.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    CounterProvider? provider = CounterProvider.of(context);

    void handleAddValue() {
      setState(() {
        provider?.state.increment();
      });
    }

    void handleDecrementValue() {
      setState(() {
        provider?.state.decrement();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Text(provider?.state.value.toString() ?? "0"),
          TextButton(onPressed: handleAddValue, child: const Icon(Icons.add)),
          TextButton(
              onPressed: handleDecrementValue, child: const Icon(Icons.remove))
        ],
      ),
    );
  }
}
