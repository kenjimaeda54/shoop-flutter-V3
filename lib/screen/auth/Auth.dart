import 'dart:math';

import "package:flutter/material.dart";
import 'package:shopp/components/auth_form/AuthForm.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(215, 177, 255, 0.5),
              Color.fromRGBO(255, 188, 117, 0.9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                //cascate operator
                //com anotação de depois pontos consigo retornar o proprio valor que o instancionou
                //traslate retorno void com cascade consigo retornoar o matrix4
                //https://flutterbyexample.com/lesson/cascade-notation
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepOrange.shade900,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 8))
                    ]),
                child: const Text(
                  "Minha Loja",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Antom', fontSize: 30),
                ),
              ),
              const AuthForm()
            ],
          ),
        )
      ],
    ));
  }
}
