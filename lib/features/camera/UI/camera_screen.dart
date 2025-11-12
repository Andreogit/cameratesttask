import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtask/core/widgets/app_scaffold.dart';
import 'package:testtask/features/camera/UI/widgets/bottom_bar.dart';
import 'package:testtask/features/camera/UI/widgets/time_indicator.dart';
import 'package:testtask/features/camera/cubit/camera_cubit.dart';
import 'package:testtask/main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController? controller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.max, enableAudio: true);
    initializeControllerFuture = controller!.initialize();
    controller
        ?.initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                print('Camera access denied');
                break;
              default:
                print('Camera initialization error: $e');
                break;
            }
          }
        });
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    if (controller != null && controller!.value.isInitialized) {
      final image = await controller!.takePicture();
      debugPrint('Picture saved to ${image.path}');
    }
  }

  Future<void> _switchCamera() async {
    controller?.dispose();
    setState(() {
      controller == null;
    });
    cameraCubit.switchCamera();
    controller = CameraController(cameras[cameraCubit.state.isFrontCamera ? 1 : 0], ResolutionPreset.max, enableAudio: true);
    initializeControllerFuture = controller!.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (controller != null && controller!.value.isInitialized && !cameraCubit.state.isRecording) {
      await controller?.startVideoRecording();
      cameraCubit.startRecording();
    }
  }

  Future<void> _stopRecording() async {
    if (controller != null && controller!.value.isInitialized && controller!.value.isRecordingVideo) {
      final file = await controller!.stopVideoRecording();
      cameraCubit.stopRecording();
      debugPrint('Video saved to: ${file.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50 + MediaQuery.of(context).padding.top),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Camera test task", style: TextStyle(color: Colors.black, fontSize: 28)),
              ),
            ],
          ),
          if (controller != null)
            Expanded(
              child: Stack(
                children: [
                  CameraPreviewWidget(controller: controller, initializeControllerFuture: initializeControllerFuture),
                  // PreviewOverlayImage(controller: controller),
                  RecordingTimeIndicator(),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).padding.bottom + 5,
                    child: BottomBar(
                      startRecording: _startRecording,
                      stopRecording: _stopRecording,
                      switchCamera: _switchCamera,
                      takePicture: _takePicture,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key, this.controller, this.initializeControllerFuture});

  final CameraController? controller;
  final Future<void>? initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Transform.scale(scale: controller!.value.aspectRatio, child: Center(child: CameraPreview(controller!)));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        PreviewOverlayImage(),
      ],
    );
  }
}

class PreviewOverlayImage extends StatelessWidget {
  const PreviewOverlayImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BlocBuilder<CameraCubit, CameraState>(
        buildWhen: (previous, current) => previous.overlayImagePath != current.overlayImagePath,
        builder: (context, state) {
          if (state.overlayImagePath.isEmpty) return SizedBox();
          return Image.asset(state.overlayImagePath, fit: BoxFit.cover, opacity: AlwaysStoppedAnimation(0.2));
        },
      ),
    );
  }
}
