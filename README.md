#  Shoop
Versão 3 do aplicativo da [Loja](https://github.com/kenjimaeda54/shoop-flutter-v1).</br>
Nesta versão os dados foram salvos no firbase e também utilizamos o recurso de autenticação

## Feature
- Para salvar os dados no firebase utilizamos o real time,ele disponibiliza uma Api Rest 
- Para consumir  api podemos usar o pacote [http](https://pub.dev/packages/http) 
- Flutter em requisições trabalha com conceitos parecidos com Swift, quando desejamos receber um json usamos jsonDecode e se for enviar seria jsonEncode
- Abaixo um exemplo de post,get e patch
- Repara que usamos chave e valor no jsonEncode ou seja  trabalha com o conceito de map


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
            
 final responseFavorite = requestFavorite.body != 'null'
            ? jsonDecode(requestFavorite.body)
            : {};            

 
 
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
- Para autenticação usamos o conceito do token para verificar se o usuario esta logado
- Os tokens são expirados apos determinado tempo
- Abaixo uma lógica para comparar o token
- Com isAfter eu vejo se o tempo  da variável está no futuro, se  não estiver significa  expirou
- Essa variável e instanciada  pegando a hora exata e adicionamos em segundos o tempo que ira expirar
- Teoricamente caso agora seja 9 horas e o tempo de expiração 1 hora, então essa variável expira às 10 horas
- [ExpiresIn](https://firebase.google.com/docs/reference/rest/auth) e o segundos que o token ira expirar, fornecido pelo  firebase
- Repara que firebase trabalha com conceito de chave e valor no Flutter

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
- Para garantir autenticação de forma correta usamos uma rota como middleware e futuramente ela foi usada também para implementar o auto login
- Essa rota precisa ser registrada como a home da aplicação no main.dart


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
- Para salvar os dados localmente usei o [Shared Preferences](https://pub.dev/packages/shared_preferences)
- Usando essa abordagem e possível o auto login, pois os dados ficam localmente
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





