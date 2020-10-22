import 'package:flutter/material.dart';
import 'Produto.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';


class AdicionarProduto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Adicionar Produto';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.green,
        ),
        resizeToAvoidBottomPadding: false,
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  _openGallery(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future <void>_showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Escolher Foto"),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Galeria"),
                  onTap: (){
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
              ],
            )
        ),
      );
    });
  }

  Widget _decideImageView(){
    if(imageFile == null){
      return Text("Nenhuma foto selecionada");
    }else{
      imagem = Image.file(imageFile,width: 50, height: 50);
      return imagem;
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorQuantidade = TextEditingController();
  final TextEditingController _controladorObservacoes = TextEditingController();
  final TextEditingController _controladorPreco = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _decideImageView(),
                  RaisedButton(onPressed:() {
                    _showChoiceDialog (context);
                  },
                    child: Text("Selecionar Imagem!"),)
                ],
              )
          ),
          TextFormField(
            controller: _controladorNome,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              labelStyle: TextStyle(
                color: Colors.green,
                fontSize: 14,
                ),
              icon: Icon(Icons.shopping_basket,
                  color: Colors.green),
              hintText: 'Insere o nome do Produto',
              labelText: 'Nome Produto *',

            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Expanded(
              flex: 0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _controladorPreco,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                          icon: Icon(Icons.euro_symbol,
                              color: Colors.green),
                          helperText: 'Insere o Preço por unidade',
                          labelText: 'Preço Unitário *',
                          suffixText: 'euro(s)'
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controladorQuantidade,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                        icon: Icon(Icons.format_list_numbered,
                            color: Colors.green),
                        helperText: 'Insere a quantidade',
                        labelText: 'Qtd *',
                        suffixText: 'unidade(s)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
          ),
          Expanded(
            flex: 0,
            child: TextFormField(
              controller: _controladorObservacoes,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
                icon: Icon(Icons.comment,
                    color: Colors.green),
                hintText: 'Insere alguma Observação',
                labelText: 'Observação',
                helperText: 'Todos os campos marcados com um * são de preenchimento obrigatório.',
                helperMaxLines: 2,
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if(imagem==null){
                    imagem= Image.asset("lib/assets/logo3.png");
                  }
                  final String nome = _controladorNome.text;
                  final int quantidade = int.tryParse(_controladorQuantidade.text);
                  final double preco = double.tryParse(_controladorPreco.text);
                  final String observacoes = _controladorObservacoes.text;
                  Produto produto1 = new Produto(imagem,nome,quantidade,preco,observacoes);//
                  produtos.add(produto1);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>HistoricScreen()),
                  );
                }
              },
              child: Text('Submeter'),

            ),
          ),
        ],
      ),
    );
  }
}