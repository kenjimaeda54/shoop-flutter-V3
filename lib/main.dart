import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/AuthProvider.dart';
import 'package:shopp/providers/CartProductProvider.dart';
import 'package:shopp/providers/OrderProvider.dart';
import 'package:shopp/providers/ProductListProvider.dart';
import 'package:shopp/screen/auth/Auth.dart';
import 'package:shopp/screen/cartProduct/CartProduct.dart';
import 'package:shopp/screen/formProduct/FormProduct.dart';
import 'package:shopp/screen/home/Home.dart';
import 'package:shopp/screen/manageProduct/ManageProduct.dart';
import 'package:shopp/screen/order/Order.dart';
import 'package:shopp/screen/productDetail/ProductDetail.dart';
import 'package:shopp/utils/ConstantsRoutes.dart';
import "./screen/authOrHome/AuthOrHome.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //precisa importar o import 'package:provider/provider.dart';
      //do pacote de provider
      providers: [
        //para criar uma conexao entre os providers quando um depende do outro
        //preciso o maior esta no topo.
        //AuthProvider ira fornecer o token para ProductList carregar
        //Procut depende do Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        //este virou proxyprovider porque depende do auth
        //preciso do genericos
        ChangeNotifierProxyProvider<AuthProvider, ProductListProvider>(
          create: (_) => ProductListProvider(token: '', products: []),
          //se atualizar terei a lista anterior no previous
          update: (ctx, auth, previous) {
            return ProductListProvider(
                token: auth.token ?? "",
                products: previous?.products ?? [],
                userId: auth.uid);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(token: "", order: []),
          update: (ctx, auth, previous) {
            return OrderProvider(
                token: auth.token ?? "",
                order: previous?.order ?? [],
                userId: auth.uid);
          },
        ),
        ChangeNotifierProvider(create: (_) => CartProductProvider()),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.purple,
            fontFamily: "Lato",
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.deepOrange,
            )),
        home: const AuthOrHome(),
        //sera essa rota que ira determinar se e auth ou home
        debugShowCheckedModeBanner: false,
        routes: {
          ConstantRoutes.middleRoute: (_) => const AuthOrHome(),
          ConstantRoutes.homeScreen: (_) => const Home(),
          ConstantRoutes.productDetail: (_) => const ProductDetails(),
          ConstantRoutes.cartProduct: (_) => const CartProduct(),
          ConstantRoutes.oder: (_) => const Order(),
          ConstantRoutes.manageProduct: (_) => const ManageProduct(),
          ConstantRoutes.formProduct: (_) => const FormProduct(),
          ConstantRoutes.auth: (_) => const Auth(),
        },
      ),
    );
  }
}
