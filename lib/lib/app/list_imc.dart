import 'package:flutter/material.dart';
import 'package:projeto_ufba/database/script.dart';

class ListImc extends StatelessWidget {
  const ListImc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text('Histórico de IMC', style: TextStyle(color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,),),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: FutureBuilder<List<IMC>>(
        future: DatabaseHelper.getAllIMCs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final imcs = snapshot.data!;
            return ListView.builder(
              itemCount: imcs.length,
              itemBuilder: (context, index) {
                final imc = imcs[index];
                return ListTile(
                  title: Text('Nome: ${imc.nome}'),
                  subtitle: Text('Altura: ${imc.altura}, Peso: ${imc.peso}, IMC: ${imc.imc}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
