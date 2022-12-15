import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:shopp/Exception/AuthException.dart';
import 'package:shopp/data/Store.dart';
import 'package:shopp/utils/ConstantStore.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  String? email;
  DateTime? expires;
  String? uid;

  bool get isAuthenticated {
    //vai expirar o token depois de uma hora
    //estou adicionado uma duraçao quando logar de secondos
    bool isExpire = expires?.isAfter(DateTime.now()) ?? false;
    return token != null && isExpire;
  }

  String? get emailAuthenticated {
    return isAuthenticated ? email : null;
  }

  String? get idAuthenticated {
    return isAuthenticated ? uid : null;
  }

  String? get tokenAuthenticated {
    return isAuthenticated ? token : null;
  }

  Future<void> autenticated({required String emailUser,
    required String password,
    required String urlFragment}) async {
    final baseUrl =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyAqT06MJN44FzspoXwoJI8Yn3dOgZvuhOU";

    final response = await http.post(Uri.parse(baseUrl),
        body: jsonEncode({
          "email": emailUser,
          "password": password,
          "returnSecureToken": true,
        }));

    final responseDecode = jsonDecode(response.body);

    if (responseDecode["error"] != null) {
      throw AuthException(responseDecode["error"]["message"]);
    } else {
      //adicionando a duração
      //não esquece de parsear para inteiro o seconds
      expires = DateTime.now()
          .add(Duration(seconds: int.parse(responseDecode["expiresIn"])));
      uid = responseDecode["localId"];
      token = responseDecode["idToken"];
      email = responseDecode["email"];

      Store.saveMap(key: ConstantStore.storeMap, value: {
        "expires": expires?.toIso8601String(),
        "uid": uid,
        "token": token,
        "email": email,
      });
      autoLogOut();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    final data = await Store.getMap(ConstantStore.storeMap);
    if (data.isEmpty) return;

    final parseStoreExpires = DateTime.parse(data["expires"]);
    if (parseStoreExpires.isBefore(DateTime.now())) return;

    uid = data["uid"];
    expires = parseStoreExpires;
    email = data["email"];
    token = data["token"];
  }

  Future<void> signUp({required String email, required String password}) async {
    return autenticated(
        emailUser: email, password: password, urlFragment: "signUp");
  }

  Future<void> signIn({required String email, required String password}) async {
    return autenticated(
        emailUser: email,
        password: password,
        urlFragment: "signInWithPassword");
  }

  void logOut() {
    token = null;
    email = null;
    expires = null;
    uid = null;
    Store.removeStore(ConstantStore.storeMap).then((_) => notifyListeners());
  }

  //tentar resolver o timer
  void autoLogOut() {
    //duration vai retornar os segundos diferente entre o tempo forneceido e a data de agora
    final duration = expires
        ?.difference(DateTime.now())
        .inSeconds;
    Timer.periodic(Duration(seconds: duration ?? 0), (timer) {
      timer.cancel();
      logOut();
    });
  }
}
