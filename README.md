#  Shoop
Versao 3 do aplicativo de Loja. Nesta versao os dados foram salvos no firbase e tambem utlizamos o recurso de autenticacao


## Feature
- Para salvar os dados no firebase utilizamos o real time,ele disponibiliza uma api rest 
- Para consumir api podemos usar o pacote [http](https://pub.dev/packages/http) 
- Flutter em requisicoes trabalha com conceitos parecidos com Swift,quando desejamos receber um json suamos jsonDecode e se for enviar seria jsonEncode
- Abaixo um exemplo de post,get e patch
- Reapara qeu usamos chave e valor no jsonEncode ou seja ele trabalha com o coneito de map


 ```dart 
 //post 
    http
        .post(
      Uri.parse("$_url.json?auth=$token"),
      body: jsonEncode({
        "name": product.title,
        "imageUrl": product.imageUrl,
        "description": product.description,
        "price": product.price,
      }),
 
 
 //get 
 final requestFavorite =
            await http.get(Uri.parse("$_urlFavorite/$userId.json?auth=$token"));

 
 
 //patch
 final hasIndex = products.indexWhere((it) => it.id == productModel.id);
    if (hasIndex >= 0) {
      await http.patch(
        Uri.parse("$_url/${productModel.id}.json?auth=$token"),
        body: jsonEncode({
          "name": productModel.title,
          "imageUrl": productModel.imageUrl,
          "description": productModel.description,
          "price": productModel.price,
        }),
      );
 
 
 
 //delte
  final response = await http
          .delete(Uri.parse("$_url/${productModel.id}.json?auth=$token"));
 
 
  ```


##
- Recurso interessante para tratar os erros e criar uma classe customizada de erros como exemplo abaixo
- Criei um map com os erros genericos do firebase, assim consigo disparar os erros de forma customizada


```dart
class AuthException implements Exception {
  late String key;

  AuthException(this.key);

  final Map<String, String> errors = {
    'EMAIL_NOT_FOUND': "Email não encontrado",
    'INVALID_PASSWORD': 'Senha ou email invalidos',
    'USER_DISABLED': 'Úsuario desabilitado pelo administrador',
    'EMAIL_EXISTS': 'Email já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Bloqueado por muitas tentativas.Aguarde e tente mais tarde'
  };


  @override
  String toString() {
    return errors[key] ?? "Erro desconhecido";
  }
}


//classe que implementa
 if (responseDecode["error"] != null) {
      throw AuthException(responseDecode["error"]["message"]);
    } else {
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


```

## 
- Para autenticacao usamos o conceito do token para verificar se o usuairo esta logado
- Os tokens sao expireados apos determinado tempo
- Abaixo uma logica para comparar o token
- Com isAfter eu vejo se o tempo dentro da variavel esta no futuro se  nao estiver e que o tempo ja expirou
- Essa variavel e instanciada  pegando a hora exta e adicionamos em segundos o tempo que ira expirar
- Tericamente caso agora seja 9 horas e o tempo de expiracao 1 hora, entao essa variavel expira as 10 horas
- [ExpiresIn](https://firebase.google.com/docs/reference/rest/auth) e o segundos que o token ira expirar e fornecido pelo  firebase
- Repaara qeu firebase trabalha com coneito de chave e valor no flutter

``` dart

  bool get isAuthenticated {
    bool isExpire = expires?.isAfter(DateTime.now()) ?? false;
    return token != null && isExpire;
  }


 //instanciando a variavel
 final responseDecode = jsonDecode(response.body);
 expires = DateTime.now()
          .add(Duration(seconds: int.parse(responseDecode["expiresIn"])));

```

##
- Para garantir autenticacao de forma correta usmoas uma rota como middleware e futurametne ela foi usada tambem para implmeentar o auto login
- Essa rota precisa ser registrada como a home da aplicacao no main.dart


```dart
//main.dart
home: const AuthOrHome(),


//rota middleware
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


```
## 
- Para salvar os dados locammente usei o [Shared Preferences](https://pub.dev/packages/shared_preferences)
- Usando essa abordagem e possivel o auto login  pois os dados ficam localmente
- E recomendado salvar poucos dados usando esta abordagem


```dart
//classe para salvar
  static void saveMap(
      {required String key, required Map<String, dynamic> value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      return jsonDecode(await getString(key));
    } catch (_) {
      return {};
    }
  }
  
  //quem implementa
  
   Store.saveMap(key: ConstantStore.storeMap, value: {
        "expires": expires?.toIso8601String(),
        "uid": uid,
        "token": token,
        "email": email,
      });
      
      
   Store.saveMap(key: ConstantStore.storeMap, value: {
        "expires": expires?.toIso8601String(),
        "uid": uid,
        "token": token,
        "email": email,
      });    



```





