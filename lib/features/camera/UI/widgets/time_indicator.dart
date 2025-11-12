import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtask/core/utils/time_formatter.dart';
import 'package:testtask/features/camera/cubit/camera_cubit.dart';

class RecordingTimeIndicator extends StatelessWidget {
  const RecordingTimeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,
      left: 0,
      right: 30,
      child: BlocBuilder<CameraCubit, CameraState>(
        buildWhen: (previous, current) => previous.isRecording != current.isRecording || previous.seconds != current.seconds,
        builder: (context, state) {
          return Column(
            children: [
              if (state.isRecording)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
                      const SizedBox(width: 5),
                      Text(formatTime(state.seconds), style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
