import 'package:flutter/material.dart';
import 'package:projeto_ufba/app/list_imc.dart';

import '../database/script.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
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
                decoration: InputDecoration(
                  labelText: "Altura",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Peso",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    final nomeController = TextEditingController();
                    final alturaController = TextEditingController();
                    final pesoController = TextEditingController();
                    final nome = nomeController.text;
                    final altura = double.parse(alturaController.text);
                    final peso = double.parse(pesoController.text);
                    final imc = peso / (altura * altura);
                    final newIMC =
                        IMC(nome: nome, altura: altura, peso: peso, imc: imc);
                    DatabaseHelper.insertIMC(newIMC);
                  },
                  child: const Text("Calcular",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ))),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => ListImc())));
                  },
                  child: const Text("Histórico",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
