import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtask/core/utils/locator.dart';
import 'package:testtask/features/camera/UI/camera_screen.dart';
import 'package:testtask/features/camera/cubit/camera_cubit.dart';

late List<CameraDescription> cameras;
CameraCubit cameraCubit = locator.get();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cameraCubit,
      child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Test', home: const CameraScreen()),
    );
  }
}
