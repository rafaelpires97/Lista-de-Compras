import 'package:flutter/material.dart';

class Produto{
  Image imagem;
  String nomeProduto;
  int qtd;
  double precoUnidade;
  String observacoes;
  Color cor= Colors.white;


  Produto(Image imagem, String nomeProduto, int qtd, double precoUnidade, String observacoes){
    this.imagem=imagem;
    this.nomeProduto=nomeProduto;
    this.qtd=qtd;
    this.precoUnidade=precoUnidade;
    this.observacoes=observacoes;
  }


  String get nameProduto {
    return nomeProduto;
  }

  int get quantidade {
    return qtd;
  }

  double get priceUnidade {
    return precoUnidade;
  }



}