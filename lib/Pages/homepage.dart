import 'package:buscador_cep/services/consult_service_cep.dart';
import 'package:buscador_cep/widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController txt = TextEditingController();
  String _resultData = '';
  String _resultError = '';
  bool _searchingCep = false;

  void dispose() {
    super.dispose();
    txt.clear();
  }

  var maskFormattInput = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  void messageDialog() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Campo não preenchido corretamente!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void searchProgress() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 15),
            Text('Buscando cep..'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Future _searchCep() async {
      if (txt.text.length != 9 || txt.text.isEmpty) {
        setState(() {
          messageDialog();
        });
        return;
      }

      //bool _validCep = false;
      setState(() {
        _searchingCep = true;
      });
      searchProgress();

      var cp = txt.text.replaceAll('-', '');
      // ignore: non_constant_identifier_names

      try {
        final resultCep = await ConsultServiceCep.searchAddres(cep: cp);

        setState(() {
          _resultData = 'Rua: ${resultCep.logradouro}\n \n'
              'Cidade: ${resultCep.localidade} \n \n'
              'Bairro: ${resultCep.bairro}\n \n'
              'Estado: ${resultCep.uf}';

          _searchingCep = false;
          _resultError = '';
        });
      } catch (e) {
        setState(() {
          _searchingCep = false;
          _resultError = 'Erro ao realizar a busca do cep';
          _resultData = '';
        });
        Navigator.of(context).pop();
        return;
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BUSCADOR DE CEP'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'lib/imgs/buscacepicone.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(
              height: 80,
            ),
            TextField(
              controller: txt,
              inputFormatters: [maskFormattInput],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Digite seu cep',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.00),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10.00),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.00),
                    ),
                  ),
                ),
                onPressed: _searchingCep
                    ? null
                    : () async {
                        _searchCep();
                      },
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (_resultError.isNotEmpty) ErrorMessage(message: _resultError),
            Text(
              _resultData,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
