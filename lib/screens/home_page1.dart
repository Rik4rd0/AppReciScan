import 'dart:io';
import 'package:appreciscan/screens/home_page2.dart';
//
//w11s+import 'package:appreciscan/screens/navigation_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  final picker = ImagePicker();
  List? _recognitions;

  // Mapa de etiquetas a colores de contenedores
  final Map<String, String> containerColorMap = {
    'cardboard': 'Marrón',
    'glass': 'Verde',
    'metal': 'Amarillo',
    'paper': 'Azul',
    'plastic': 'Rojo',
    'trash': 'Gris',
  };

  // Mapa de etiquetas a iconos de contenedores
  final Map<String, IconData> containerIconMap = {
    'cardboard': Icons.delete_outline,
    'glass': Icons.delete_outline,
    'metal': Icons.delete_outline,
    'paper': Icons.delete_outline,
    'plastic': Icons.delete_outline,
    'trash': Icons.delete_outline,
  };

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _openCamera() async {
    await _checkPermission();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      classifyImage(_image!);
    }
  }

  Future<void> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    setState(() {
      _recognitions = output;
      _recognitions?.forEach((recognition) {
        String label = recognition['label'];
        String? containerColor = containerColorMap[label];
        if (kDebugMode) {
          print('Object: $label goes to: $containerColor container');
        }
      });
    });
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return;
    } else if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isRestricted) {
      if (kDebugMode) {
        print('Permission is restricted');
      }
    } else if (status.isPermanentlyDenied) {
      if (kDebugMode) {
        print('Permission is permanently denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReciScan'),
        centerTitle: true, // Centra el título
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecyclingInfoPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _image == null
            ? Padding(
                padding: const EdgeInsets.only(
                    bottom: 80.0), // Añade espacio en la parte inferior
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Establece el ancho al ancho de la pantalla
                  child: Image.asset(
                    'assets/Image/inicio.png',
                    fit: BoxFit
                        .fitWidth, // Esto hace que la imagen mantenga su relación de aspecto
                  ),
                ),
              )
            // Reemplaza 'your_image.png' con el nombre de tu imagen
            : SingleChildScrollView(
                child: // ...
                    Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          15.0), // Añade esquinas redondeadas
                      child: Image.file(
                        _image!,
                        width: 300, // Define el ancho de la imagen
                        height: 300, // Define la altura de la imagen
                        fit: BoxFit
                            .cover, // Asegura que la imagen cubra el espacio disponible
                      ),
                    ),
                    ..._recognitions?.map((recognition) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Añade esquinas redondeadas al Card
                            ),
                            elevation: 10, // Añade sombra al Card
                            child: ListTile(
                              leading: Icon(
                                containerIconMap[recognition["label"]],
                                size: 30, // Aumenta el tamaño del icono
                              ),
                              title: Text(
                                'Object: ${recognition["label"]}',
                                style: const TextStyle(
                                  fontSize: 20, // Aumenta el tamaño del texto
                                  fontWeight: FontWeight
                                      .bold, // Hace el texto en negrita
                                ),
                              ),
                              subtitle: Text(
                                'Container: ${containerColorMap[recognition["label"]]}',
                                style: const TextStyle(
                                  fontSize: 18, // Aumenta el tamaño del texto
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ],
                ),
              ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 30.0,
            left: 0.0,
            right: 0.0,
            child: SizedBox(
              height: 70.0, // Ajusta el tamaño del botón
              width: 70.0, // Ajusta el tamaño del botón
              child: FloatingActionButton(
                heroTag: 'botonCamera',
                onPressed: _openCamera,
                tooltip: 'Take a photo',
                child: const Icon(
                  Icons.camera_alt,
                  size: 60.0, // Aumenta el tamaño del ícono
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Centra el botón flotante de acción
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('_image', _image));
  }
}
