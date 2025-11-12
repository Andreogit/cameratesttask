// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final bool isFrontCamera;
  final bool isRecording;
  final int seconds;
  final String overlayImagePath;
  const CameraState({this.isFrontCamera = true, this.isRecording = false, this.seconds = 0, this.overlayImagePath = ''});

  @override
  List<Object?> get props => [isFrontCamera, isRecording, seconds, overlayImagePath];

  CameraState copyWith({bool? isFrontCamera, bool? isRecording, int? seconds, String? overlayImagePath}) {
    return CameraState(
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isRecording: isRecording ?? this.isRecording,
      seconds: seconds ?? this.seconds,
      overlayImagePath: overlayImagePath ?? this.overlayImagePath,
    );
  }
}
