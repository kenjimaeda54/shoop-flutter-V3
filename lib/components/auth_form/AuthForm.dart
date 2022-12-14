import "package:flutter/material.dart";
import 'package:shopp/Exception/AuthException.dart';
import 'package:shopp/providers/AuthProvider.dart';
import "package:provider/provider.dart";
import 'package:shopp/utils/ConstantsRoutes.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum TypeAuth {
  signIn,
  signUp,
}

class _AuthFormState extends State<AuthForm> {
  //global key não pode ficar dentro do build(BuildContext context)
  //https://stackoverflow.com/questions/51320692/flutter-keyboard-disappears-immediately-when-editing-my-text-fields
  final formKey = GlobalKey<FormState>();
  TypeAuth typeAuth = TypeAuth.signIn;
  bool isLoading = false;

  //para comparar se o as senhas são iguais
  final passwordController = TextEditingController();
  final formData = <String, Object>{};

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    final deviceSize = MediaQuery.of(context).size;

    void showError(e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text("Ok"))
          ],
        ),
      );
    }

    void handleSubmit() async {
      setState(() {
        isLoading = true;
      });
      final validate = formKey.currentState?.validate() ?? false;

      if (!validate) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      formKey.currentState?.save();

      try {
        if (typeAuth == TypeAuth.signIn) {
          await authProvider
              .signIn(
                  email: formData["email"] as String,
                  password: formData["password"] as String)
              .then(
                (value) => setState(() {
                  isLoading = false;
                  Navigator.of(context)
                      .pushReplacementNamed(ConstantRoutes.middleRoute);
                }),
              );
          // entrar
        } else {
          await authProvider
              .signUp(
                  email: formData["email"] as String,
                  password: formData["password"] as String)
              .then((value) => setState(() {
                    isLoading = false;
                    Navigator.of(context)
                        .pushReplacementNamed(ConstantRoutes.middleRoute);
                  }));
        }
      } on AuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        showError(e);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showError(e);
      }
    }

    String? validatorPasswordIsEqual(String? password) {
      if (password != passwordController.text) {
        return "Senhas precisam ser iguais";
      }
      return null;
    }

    String? validatorPassword(String? password) {
      final text = password ?? "";
      if (text.isEmpty && text.length < 5) {
        return "Senha precisa ser preenchida";
      }
      return null;
    }

    void handleSave({String? text, required String field}) {
      formData[field] = text ?? "";
    }

    String? validatorString(String? email) {
      final text = email ?? "";
      if (text.isEmpty && text.length < 4) {
        return "Email precisa ser preenchidos";
      }
      return null;
    }

    void toggleAuth(TypeAuth auth) => setState(() => typeAuth = auth);

    return Container(
      height: typeAuth == TypeAuth.signUp ? 400 : 330,
      width: deviceSize.width * 0.78,
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 8,
        child: Form(
          key: formKey,
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: validatorString,
                  onSaved: (text) => handleSave(text: text, field: "email"),
                  decoration: const InputDecoration(label: Text("E-mail")),
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  onSaved: (text) => handleSave(text: text, field: "password"),
                  validator: validatorPassword,
                  decoration: const InputDecoration(
                    label: Text("Senha"),
                  ),
                ),
                if (typeAuth == TypeAuth.signUp)
                  TextFormField(
                    obscureText: true,
                    onSaved: (text) =>
                        handleSave(text: text, field: "confirmPassword"),
                    decoration:
                        const InputDecoration(label: Text("Confirmar senha")),
                    validator: validatorPasswordIsEqual,
                  ),
                isLoading
                    //para diminuir um tamanho pode usar o tranform
                    ? Transform.scale(
                        scaleY: 0.6,
                        scaleX: 0.1,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: handleSubmit,
                            child: const Text("Entrar")),
                      ),
                typeAuth == TypeAuth.signUp
                    ? TextButton(
                        onPressed: () => toggleAuth(TypeAuth.signIn),
                        child: Text(
                          "Deseja realizar login?",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                    : TextButton(
                        onPressed: () => toggleAuth(TypeAuth.signUp),
                        child: Text(
                          "Deseja registrar?",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
              ]),
        ),
      ),
    );
  }
}
