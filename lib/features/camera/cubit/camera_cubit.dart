import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());
  Timer? _timer;

  void switchCamera() {
    emit(state.copyWith(isFrontCamera: !state.isFrontCamera));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(seconds: state.seconds + 1));
    });
  }

  void startRecording() {
    emit(state.copyWith(isRecording: true, seconds: 0));
    _startTimer();
  }

  void stopRecording() {
    emit(state.copyWith(isRecording: false));
    _timer?.cancel();
  }

  Future<void> selectOverlay() async {
    emit(state.copyWith(overlayImagePath: ''));
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      emit(state.copyWith(overlayImagePath: image.path));
    } catch (e) {
      print(e);
    }
  }
}
