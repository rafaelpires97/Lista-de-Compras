import 'package:flutter/material.dart';
import 'package:miniprojetofluttera21702113/Produto.dart';
import 'Produto.dart';
import 'AdicionarProduto.dart';
import 'EditarProdutos.dart';
import 'shake.dart';
import 'dart:io';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HistoricScreen(),
    );
  }
}

  List<Produto> produtos=[
    Produto(Image.asset("lib/assets/logo0.png"),"escova de dentes", 2, 3.49,""),
    Produto(Image.asset("lib/assets/logo1.png"),"batatas fritas", 1, 2,""),
    Produto(Image.asset("lib/assets/logo2.png"),"lasanha", 1, 1.7,""),
  ];

  int indexTrack=0;
  File imageFile;
  Image imagem;

  int verImagem(indice){
    for(var i = 0; i<=produtos.length; i++){
      if(i == indice){
        return i;
      }
    }
  }

  String verNome(indice){
    for(var i = 0; i<=produtos.length; i++){
      if(i == indice){
        return produtos[i].nameProduto;
      }
    }
  }

  int verqtd(indice){
    for(var i = 0; i<=produtos.length; i++){
      if(i == indice){
        return produtos[i].qtd;
      }
    }
  }

  double verprecoUnidade(indice){
    for(var i = 0; i<=produtos.length; i++){
      if(i == indice){
        return produtos[i].priceUnidade;
      }
    }
  }

  String verObservacoes(indice){
    for(var i = 0; i<=produtos.length; i++){
      if(i == indice){
        return produtos[i].observacoes;
      }
    }
  }

  double precoTotal(){
    double precoTotal= 0.0;
    for(var i = 0; i<produtos.length; i++){
      precoTotal += produtos[i].priceUnidade*produtos[i].quantidade;
    }
    return precoTotal;
  }

  int qtdTotal(){
    int qtd =0;
    for(var i = 0; i<produtos.length; i++){
      qtd += produtos[i].qtd;
    }
    return qtd;
  }

class HistoricScreen extends StatefulWidget {
    @override
    _HistoricScreenState createState() => _HistoricScreenState();
  }

class _HistoricScreenState extends State<HistoricScreen> {

    Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Remover',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

    Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              "Marcar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

    void _decrementarProd(int index) {
      setState(() {
        if(produtos[index].quantidade > 0){
          produtos[index].qtd--;
        };
      });
    }

    void _incrementarProd(int index) {
      setState(() {
          produtos[index].qtd++;
      });
    }

    void initState() {
      super.initState();
      ShakeDetector.autoStart(onPhoneShake: () {
        setState(() {
          showAlertDialog(context);
        });
      });
    }

    void showAlertDialog(BuildContext context) {
      Widget cancelaButton = FlatButton(
        child: Text("Cancelar"),
        onPressed:  () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>HistoricScreen()),
          );
        },
      );
      Widget continuaButton = FlatButton(
        child: Text("Proceder"),
        onPressed:  () {
          produtos.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>HistoricScreen()),
          );
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("IMPORTANTE"),
        content: Text("Quer proceder com a eliminação de toda a lista de produtos?"),
        actions: [
          cancelaButton,
          continuaButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Compras"),
        ),
        body: ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context,index){
              return new Dismissible(
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd){ //esquerda para a direita
                      setState(() {
                        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("O artigo " + produtos[index].nomeProduto + " foi removido da lista com sucesso")));
                        produtos.removeAt(index);
                      }
                      );
                    }else{ //direita para a esquerda
                      setState(() {
                        if(produtos[index].cor==Colors.white){
                          produtos[index].cor= Colors.green;
                          Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("O artigo " + produtos[index].nomeProduto + " foi marcado da lista")));
                        }else{
                          produtos[index].cor= Colors.white;
                          Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("O artigo " + produtos[index].nomeProduto + " foi desmarcado da lista")));
                        }
                      });
                    }
                  },
                 child:Card(
                   color:produtos[index].cor,
                   child: ListTile(
                     onTap: (){
                       indexTrack=index;
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context)=>EditarProduto()),
                       );

                     },
                    leading: produtos[index].imagem,
                    isThreeLine: true,
                    title: Text(verNome(index)),
                    subtitle: Text("Quantidade: " + verqtd(index).toString() +  "\nPreço Unidade: " + verprecoUnidade(index).toString() +"€"+
                       "\nPreço: " + (verqtd(index)*verprecoUnidade(index)).roundToDouble().toString()+"€"),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            tooltip: 'Tira 1 de quantidade',
                            onPressed: () {
                            _decrementarProd(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            tooltip: 'Adiciona 1 de quantidade',
                            onPressed: () {
                              _incrementarProd(index);
                            },
                          ),
                        ]
                    ),
                    ),
                 )
              );
           },
        ),
        bottomNavigationBar:BottomNavigationBar(
          iconSize: 25,
          selectedFontSize: 25,
          unselectedFontSize: 25,
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,
                  color: Colors.green),
              title: Text(qtdTotal().toString(), style: TextStyle(color: Colors.grey),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.euro_symbol,
                  color: Colors.green),
              title: Text(precoTotal().toString(), style: TextStyle(color: Colors.grey),),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Adicionar Produto',
          onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>AdicionarProduto()),
            );
          },
          label: Text('Produto'),
          icon: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}



