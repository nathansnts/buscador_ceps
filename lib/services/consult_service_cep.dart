import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:buscador_cep/model/address.dart';

class ConsultServiceCep {
  static Future<Endereco> searchAddres({required String cep}) async {
    final result =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (result.statusCode != 200) {
      throw Exception('Erro ao fazer busca do cep');
    }

    print(result.body);

    final data = jsonDecode(result.body);

    if (data.containsKey('erro') && data['erro']) {
      throw Exception('Cep inválido');
    }

    return Endereco.fromJson(jsonDecode(result.body));
  }
}
