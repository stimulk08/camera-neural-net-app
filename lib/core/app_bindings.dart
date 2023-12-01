import 'package:CameraBot/core/camera_service.dart';
import 'package:CameraBot/core/pytorch_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut(() => CameraService(), fenix: true);
    Get.lazyPut(() => PytorchService(), fenix: true);
  }
}