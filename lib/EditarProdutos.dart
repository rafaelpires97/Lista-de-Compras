import 'package:flutter/material.dart';
import 'package:miniprojetofluttera21702113/Produto.dart';
import 'Produto.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';

class EditarProduto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Editar Produto';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.green,
        ),
        resizeToAvoidBottomPadding: false,
        body: EditarProdutoForm(),
      ),
    );
  }
}

class EditarProdutoForm extends StatefulWidget {
  @override
  EditarProdutoFormState createState() {
    return EditarProdutoFormState();
  }
}

class EditarProdutoFormState extends State<EditarProdutoForm> {

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

  String nome="";
  int quantidade=0;
  double preco=0;
  String observacoes="";

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
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.green,
                fontSize: 14,
              ),
              icon: Icon(Icons.shopping_basket,
                  color: Colors.green),
              hintText: verNome(indexTrack),
              labelText: 'Nome Produto',
            ),
            validator: (value) {
              if (value.isEmpty) {
                nome = verNome(indexTrack);
              }else{
                nome = _controladorNome.text;
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
                      decoration:  InputDecoration(
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
                          hintText: verprecoUnidade(indexTrack).toString(),
                          labelText: 'Preço Unitário',
                          suffixText: 'euro(s)'
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          preco= verprecoUnidade(indexTrack);
                        }else{
                          preco = double.tryParse(_controladorPreco.text);
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controladorQuantidade,
                      decoration:  InputDecoration(
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
                        hintText: verqtd(indexTrack).toString(),
                        labelText: 'Qtd',
                        suffixText: 'unidade(s)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          quantidade=verqtd(indexTrack);
                        }else{
                          quantidade = int.tryParse(_controladorQuantidade.text);
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
              decoration:  InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
                icon: Icon(Icons.comment,
                    color: Colors.green),
                hintText: verObservacoes(indexTrack),
                labelText: 'Observação',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  observacoes = verObservacoes(indexTrack);
                }else{
                  observacoes = _controladorObservacoes.text;
                }
                return null;
              },
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
                    imagem=produtos[indexTrack].imagem;
                  }
                  Produto produto1 = new Produto(imagem,nome,quantidade,preco,observacoes);
                  produtos.removeAt(indexTrack);
                  produtos.add(produto1);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processando Informação')));
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

