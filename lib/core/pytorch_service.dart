import 'dart:typed_data';
import 'package:pytorch_lite/pytorch_lite.dart';

class PytorchService {
  late final ClassificationModel _imageModel;
  late final ModelObjectDetection _objectModel;
  late final ModelObjectDetection _yolov8Model;

  Future<void> initImageModel(String modelPath, String labelPath) async {
    _imageModel = await PytorchLite.loadClassificationModel(
        modelPath, 224, 224, 1000,
        labelPath: labelPath);
  }

  Future<String> getImagePrediction(Uint8List imageBytes) async {
    return _imageModel.getImagePrediction(imageBytes);
  }

  Future<List<ResultObjectDetection>> getImageObjectPrediction(Uint8List imageBytes) async {
    return _objectModel.getImagePrediction(imageBytes);
  }

  Future<List<ResultObjectDetection>> getImageYolovPrediction(Uint8List imageBytes) async {
    return _yolov8Model.getImagePrediction(imageBytes);
  }

  Future<void> initObjectModel(String modelPath, String labelPath) async {
    _objectModel = await PytorchLite.loadObjectDetectionModel(
        modelPath, 80, 640, 640,
        labelPath: labelPath);
  }

  Future<void> initYolovModel(String modelPath, String labelPath) async {
    _yolov8Model = await PytorchLite.loadObjectDetectionModel(
        modelPath, 80, 640, 640,
        labelPath: labelPath,
        objectDetectionModelType: ObjectDetectionModelType.yolov8);
  }
}
