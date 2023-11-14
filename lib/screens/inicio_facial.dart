import 'dart:typed_data';
import 'package:auth_bio/screens/inicio_contra.dart';
import 'package:auth_bio/screens/loged/bienvenida.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as mlkit;
import 'dart:async';

class ReconocimientoFacialScreen extends StatefulWidget {
  const ReconocimientoFacialScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReconocimientoFacialScreenState createState() => _ReconocimientoFacialScreenState();
}

class _ReconocimientoFacialScreenState extends State<ReconocimientoFacialScreen> {
  late CameraController _controller;
  late CameraDescription _cameraDescription;
  bool _isDetecting = false;
  late mlkit.FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();

    // Inicializar la cámara
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        _cameraDescription = cameras[0];
        _controller = CameraController(_cameraDescription, ResolutionPreset.high);
        _controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
          _controller.startImageStream(_processCameraImage);
        });
      }
    });

    // Inicializar el detector de rostros
    _faceDetector = mlkit.GoogleMlKit.vision.faceDetector();
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    if (!_isDetecting) {
      _isDetecting = true;

      final inputImage = FirebaseVisionImage.fromBytes(
        concatenatePlanes(cameraImage.planes),
        FirebaseVisionImageMetadata(
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          rawFormat: cameraImage.format.raw,
          rotation: ImageRotation.rotation270,
          planeData: cameraImage.planes.map((currentPlane) {
            return FirebaseVisionImagePlaneMetadata(
              bytesPerRow: currentPlane.bytesPerRow,
              height: currentPlane.height,
              width: currentPlane.width,
            );
          }).toList(),
        ),
      );

      await buildMetaData(inputImage as mlkit.InputImage);

      _isDetecting = false;
    }
  }

  Future<void> buildMetaData(mlkit.InputImage inputImage) async {
    final List<mlkit.Face> faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      // Rostro reconocido, redirigir a la pantalla de bienvenida
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BienvenidaScreen(''),
        ),
      );
    } else {
      // Rostro no reconocido, redirigir a la pantalla de inicio
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  void _toggleCamera() {
    final CameraLensDirection newDirection = _cameraDescription.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    availableCameras().then((cameras) {
      final newCamera = cameras.firstWhere((camera) => camera.lensDirection == newDirection);
      _controller = CameraController(newCamera, ResolutionPreset.high);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _cameraDescription = newCamera;
        });
        _controller.startImageStream(_processCameraImage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación Facial'),
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_controller),
            Positioned(
              top: 20.0,
              right: 20.0,
              child: IconButton(
                icon: const Icon(Icons.switch_camera),
                onPressed: _toggleCamera,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Capturar el rostro y realizar el proceso de reconocimiento
                    _processCameraImage(_controller.value as CameraImage);
                  },
                  child: const Text('Autenticarse'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    List<int> concatenatedBytes = <int>[];

    for (int i = 0; i < planes.length; i++) {
      concatenatedBytes += planes[i].bytes.toList();
    }

    return Uint8List.fromList(concatenatedBytes);
  }
}