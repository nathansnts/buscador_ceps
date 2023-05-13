import 'dart:convert';

class Endereco {
  final String? cep;
  final String? logradouro;
  final String? bairro;
  final String? localidade;
  final String? uf;

  Endereco({this.cep, this.logradouro, this.bairro, this.localidade, this.uf});

  String toJson() => jsonEncode(toMap());

  factory Endereco.fromJson(Map<String, dynamic> json) => Endereco(
        cep: json['cep'],
        logradouro: json['logradouro'],
        bairro: json['bairro'],
        localidade: json['localidade'],
        uf: json['uf'],
      );

  Map<String, dynamic> toMap() => {
        "cep": cep,
        "logradouro": logradouro,
        "bairro": bairro,
        "localidade": localidade,
        "estado": uf,
      };
}
