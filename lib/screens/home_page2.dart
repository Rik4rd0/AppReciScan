import 'package:flutter/material.dart';

class RecyclingInfoPage extends StatelessWidget {
  const RecyclingInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Reciclaje'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Aquí va la información de reciclaje...',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Image.asset(
                  'assets/Image/hands.jpg'), // Asegúrate de tener esta imagen en tu carpeta de assets
              const SizedBox(height: 20),
              const Text(
                'Plástico: Los envases de plástico van en el contenedor amarillo.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Image.asset(
                  'assets/Imagen/plastic.jpg'), // Asegúrate de tener esta imagen en tu carpeta de assets
              const SizedBox(height: 20),
              const Text(
                'Papel: El papel y el cartón van en el contenedor azul.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Image.asset(
                  'assets/Image/paper.jpg'), // Asegúrate de tener esta imagen en tu carpeta de assets
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
