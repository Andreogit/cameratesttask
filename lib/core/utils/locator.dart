import 'package:get_it/get_it.dart';
import 'package:testtask/features/camera/cubit/camera_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<CameraCubit>(CameraCubit());
}
