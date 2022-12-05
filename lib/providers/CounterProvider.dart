import 'package:flutter/material.dart';

class CounterState {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;

  int get currentValue {
    return value;
  }

  //aqui estou criando uma logica para atulizar o componente
  //so no momento de fato que precisa ser atualizado
  bool shouldUpdate(CounterState old) {
    return old.value != value;
  }
}

class CounterProvider extends InheritedWidget {
  CounterProvider({super.key, required Widget child}) : super(child: child);

  //instanciando uma classe que criei
  CounterState state = CounterState();

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  //metodo responsavel por notificar quando atualizar
  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    throw oldWidget.state.shouldUpdate(state);
  }
}
