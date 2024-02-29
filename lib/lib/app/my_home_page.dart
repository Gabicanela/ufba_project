import 'package:flutter/material.dart';
import 'package:projeto_ufba/app/list_imc.dart'; 
import 'package:projeto_ufba/database/script.dart'; 

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController alturaController = TextEditingController();
    TextEditingController pesoController = TextEditingController();

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
                  labelText: "Altura",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pesoController,
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
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  double? altura = double.tryParse(alturaController.text);
                  double? peso = double.tryParse(pesoController.text);
                  if (altura != null && peso != null && altura > 0 && peso > 0) {
                    double imc = peso / (altura * altura);

                    // Criar uma instância do modelo IMC
                    IMC novoImc = IMC(
                      nome: nomeController.text,
                      altura: altura.toDouble(), // Converter para inteiro
                      peso: peso,
                      imc: imc,
                    );

                    // Salvar no banco de dados
                    await DatabaseHelper.insertIMC(novoImc);

                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Seu IMC é:'),
                          content: Text(imc.toStringAsFixed(2)),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: const Text('Por favor, insira valores válidos.'),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => const ListImc())));
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
}
