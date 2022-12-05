import 'dart:math';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shopp/models/ProductModel.dart';
import 'package:shopp/providers/ProductListProvider.dart';

class FormProduct extends StatefulWidget {
  const FormProduct({Key? key}) : super(key: key);

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _priceFoucs = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _urlController =
      TextEditingController(); //foi criado esse campo,porque preciso acesso a url
  //antes de subtmer o form
  //com o compontente Form tenho acesso aos capos apos submeter
  final _formKey =
      GlobalKey<FormState>(); //isto sera adicionado ao campo formulario
  final _formData = <String, Object>{};

  //https://api.flutter.dev/flutter/widgets/State/didChangeDependencies.html
  @override
  void didChangeDependencies() {
    //ciclo de vida toda vez que um state é alterado
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as ProductModel?;

    if (args != null) {
      //para os campos refletirem precisa colocar no initialState
      //do textfield
      //campos controlados pelo controller não precisam do
      //initialState
      _formData["id"] = args.id;
      _formData["name"] = args.title;
      _formData["price"] = args.price;
      _formData["description"] = args.description;
      _formData["url"] = args.imageUrl;
      //url esta no controller
      _urlController.text = args.imageUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    _urlController.addListener(handleListenerUrl);
    //vou adicionar uma funcão para atualizar o setState da url, assim
    //ao sar ou entrar no campo tenho acesso a url
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocus.dispose();
    _priceFoucs.dispose();
    _urlFocus.dispose();
    _urlController.removeListener(handleListenerUrl);
  }

  void handleListenerUrl() {
    setState(() {});
  }

  String? handleValitorFieldString(
      {required String? text, required int quantity}) {
    final field = text ?? "";
    if (field.trim().isEmpty) {
      return "Precisa prrencher o campo ele é obrigatorio";
    }

    if (field.trim().length < quantity) {
      return "O campor precisa possuir mais que $quantity letras";
    }

    return null;
  }

  String? handleValidatorFieldDouble(String? price) {
    final priceString = price ?? "";
    final tryParse = double.tryParse(priceString) ?? -1;

    if (tryParse <= 0) {
      return "Preço precisa ser inserido é não pode ser negativo";
    }
    return null;
  }

  String? handleValidatorUrl(String? url) {
    final urlString = url ?? "";
    final absolutePath = Uri.tryParse(urlString)?.hasAbsolutePath ?? false;
    //possível validação se url não terminar com png,jpg
    // final endsWithFile = urlString.toLowerCase().endsWith(".png") ||
    //     urlString.toLowerCase().endsWith(".jpg") ||
    //     urlString.toLowerCase().endsWith(".jpeg");
    if (!absolutePath) {
      return "Url precisa ser valida ";
    }

    return null;
  }

  void handleSubmitForm() {
    final validator = _formKey.currentState?.validate() ?? false;

    if (!validator) {
      return;
    }

    _formKey.currentState?.save(); //agor" tenho acesso aos campos no saved
    //estou fora do método build então listenr precisa ser falso
    //contexto consigo pegar por heranca poruue e uma classe stateful
    final ProductListProvider provider = Provider.of(context, listen: false);

    if (provider.hasProduct(_formData)) {
      final productModel = ProductModel(
          id: _formData["id"] as String,
          title: _formData["name"] as String,
          description: _formData["description"] as String,
          price: double.parse(_formData["price"] as String),
          imageUrl: _formData["url"] as String);

      provider.updateProduct(productModel);
    } else {
      final productModel = ProductModel(
          id: "${Random().nextDouble().toString()}-${_formData["name"]}-${_formData["url"]}",
          title: _formData["name"] as String,
          description: _formData["description"] as String,
          price: double.parse(_formData["price"] as String),
          imageUrl: _formData["url"] as String);
      provider.addProdct(productModel);
    }
    Navigator.of(context).pop();
  }

  //text não posso desembrulhar usando != null
  void handleSave({String? text, bool? isDouble, required String field}) {
    if (isDouble != null) {
      //usar replace para trocar o , por  .
      _formData[field] = double.parse(text ?? "0");
    }
    _formData[field] = text ?? "ola";
  }

  @override
  Widget build(BuildContext context) {
    void handleFocus(FocusNode node) {
      Focus.of(context).requestFocus(node);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário de produtos"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(onPressed: handleSubmitForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey, //agora tenho acesso no metodo save
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData["name"]?.toString(),
                decoration: const InputDecoration(label: Text("Nome")),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => handleFocus(_priceFoucs),
                onSaved: (name) => handleSave(text: name, field: "name"),
                validator: (name) =>
                    handleValitorFieldString(text: name, quantity: 3),
              ),
              TextFormField(
                initialValue: _formData["price"]?.toString(),
                decoration: const InputDecoration(label: Text("Preço")),
                textInputAction: TextInputAction.next,
                focusNode: _priceFoucs,
                onFieldSubmitted: (_) => handleFocus(_descriptionFocus),
                onSaved: (price) =>
                    handleSave(text: price, field: "price", isDouble: true),
                validator: (price) => handleValidatorFieldDouble(price),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                initialValue: _formData["description"]?.toString(),
                decoration: const InputDecoration(label: Text("Descrição")),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                onSaved: (description) =>
                    handleSave(text: description, field: "description"),
                validator: (description) =>
                    handleValitorFieldString(text: description, quantity: 10),
                maxLines: 3,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //se não houver o expanded o elemento não ira aparecer,porque existe uma row em volta
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(label: Text("Url")),
                      keyboardType: TextInputType.url,
                      focusNode: _urlFocus,
                      textInputAction: TextInputAction.done,
                      controller: _urlController,
                      onFieldSubmitted: (_) => handleSubmitForm(),
                      onSaved: (url) => handleSave(text: url, field: "url"),
                      validator: (url) => handleValidatorUrl(url),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black45,
                      width: 1,
                    )),
                    child: _urlController.text.isEmpty
                        ? const Text("Imagem da url")
                        : Image.network(_urlController.text),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
