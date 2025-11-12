import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtask/features/camera/cubit/camera_cubit.dart';
import 'package:testtask/main.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.startRecording,
    required this.stopRecording,
    required this.switchCamera,
    required this.takePicture,
  });

  final void Function() startRecording;
  final void Function() stopRecording;
  final void Function() switchCamera;
  final void Function() takePicture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                GestureDetector(onTap: switchCamera, child: Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 30)),
                SizedBox(width: 10),
                GestureDetector(onTap: cameraCubit.selectOverlay, child: Icon(Icons.add_circle_outline, color: Colors.white, size: 34)),
              ],
            ),
          ),
          BlocBuilder<CameraCubit, CameraState>(
            buildWhen: (previous, current) => previous.isRecording != current.isRecording,
            builder: (context, state) {
              return GestureDetector(
                onTap: state.isRecording ? stopRecording : startRecording,
                child: Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: state.isRecording ? Colors.red.shade600 : Colors.transparent),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(onTap: takePicture, child: Icon(Icons.image_outlined, color: Colors.white, size: 30)),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
