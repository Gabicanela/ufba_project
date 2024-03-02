import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_ufba/app/list_imc.dart';
import 'package:projeto_ufba/database/script.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Vamos conhecer seu IMC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Qual o seu nome",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: alturaController,
                decoration: InputDecoration(
                  labelText: "Altura (metros)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value != null) {
                    double altura = double.tryParse(value)!;
                    if (altura < 0.5 || altura > 2.5) {
                      return 'Insira um valor válido para altura (entre 0.5 e 2.5 m)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pesoController,
                decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null) {
                    double peso = double.tryParse(value)!;
                    if (peso < 10 || peso > 500) {
                      return 'Insira um valor válido para peso (entre 10 e 500 kg)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    double altura = double.parse(alturaController.text);
                    double peso = double.parse(pesoController.text);
                    double imc = peso / (altura * altura);
                    String imcInterpretation = interpretarIMC(imc);

                    IMC novoImc = IMC(
                      nome: nomeController.text,
                      altura: altura,
                      peso: peso,
                      imc: imc,
                    );

                    await DatabaseHelper.insertIMC(novoImc);

                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Seu IMC é:'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(imc.toStringAsFixed(2)),
                              const SizedBox(height: 10),
                              Text(imcInterpretation),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Fechar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  "Calcular",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ListImc())));
                },
                child: const Text(
                  "Histórico",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String interpretarIMC(double imc) {
    if (imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc >= 18.5 && imc < 24.9) {
      return 'Peso normal';
    } else if (imc >= 24.9 && imc < 29.9) {
      return 'Sobrepeso';
    } else if (imc >= 29.9 && imc < 34.9) {
      return 'Obesidade grau I';
    } else if (imc >= 34.9 && imc < 39.9) {
      return 'Obesidade grau II';
    } else {
      return 'Obesidade grau III';
    }
  }
}
