import "package:flutter/material.dart";
import 'package:shopp/providers/AuthProvider.dart';
import "package:provider/provider.dart";
import 'package:shopp/screen/auth/Auth.dart';
import 'package:shopp/screen/home/Home.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    return Scaffold(
        body: FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Ops algo deu errado"),
          );
        }
        return auth.isAuthenticated ? const Home() : const Auth();
      },
    ));
  }
}
