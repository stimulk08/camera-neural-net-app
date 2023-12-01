import 'package:CameraBot/core/pytorch_service.dart';
import 'package:CameraBot/styles.dart';
import 'package:CameraBot/ui/abstract_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file_image/cross_file_image.dart';

enum PageMode { camera, photos, choose }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends AbstractState<MainPage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  final PytorchService _pytorch = Get.find<PytorchService>();

  XFile? _file;
  String? _prediction;
  int direction = 0;
  PageMode mode = PageMode.choose;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<XFile?> _pickImage() async {
    return ImagePicker().pickImage(source: ImageSource.gallery);
    // .catchError((err) => null);
  }

  Future<void> startCamera(int direction) async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      if (e.description == 'No camera found for the given camera options.') {
        Get.showSnackbar(const GetSnackBar(
          title: 'Камера не найдена',
          message: 'Подключите камеру и попробуйте снова',
          duration: Duration(seconds: 3),
        ));
      }
    }
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,

    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Flexible(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.9,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: _file == null
                        ? CameraPreview(cameraController)
                        : Image(
                            image: XFileImage(_file!),
                          )))),
        const SizedBox(
          height: 30,
        ),
        Visibility(
            visible: _prediction != null,
            child: Column(
              children: [
                Text("It`s $_prediction", style: headerStyle.copyWith(fontSize: 18),),
                const SizedBox(height: 10,)
              ],
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: _file == null,
              child: GestureDetector(
                onTap: () {
                  cameraController.takePicture().then((XFile? file) {
                    if (mounted) {
                      if (file != null) {
                        print("Picture saved to ${file.path}");
                        setState(() {
                          _file = file;
                        });
                      }
                    }
                  });
                },
                child: _buildButton(const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black54,
                )),
              ),
            ),
            Visibility(visible: _file != null, child: _buildAnalizeButton()),
            GestureDetector(
              onTap: () {
                if (_file == null) return _switchToChooseMode();
                setState(() {
                  _file = null;
                  _prediction = null;
                });
              },
              child: _buildButton(const Icon(
                Icons.close,
                color: Colors.black54,
              )),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosView() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.9,
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: _file == null
                        ? Center(
                            child: SvgPicture.asset(
                              'assets/images/logo.svg',
                              theme: SvgTheme(
                                  currentColor: theme.colorScheme.secondary),
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image(
                            image: XFileImage(_file!),
                          ))),
          ),
          const SizedBox(
            height: 30,
          ),
          Visibility(
              visible: _prediction != null,
              child: Column(
                children: [
                  Text("It`s $_prediction", style: headerStyle.copyWith(fontSize: 18),),
                  const SizedBox(height: 10,)
                ],
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnalizeButton(),
              GestureDetector(
                  onTap: _switchToChooseMode,
                  child: _buildButton(const Icon(
                    Icons.close,
                    color: Colors.black54,
                  ))),
            ],
          )
        ],
      ),
    );
  }

  void _switchToChooseMode() {
    setState(() {
      _file = null;
      _prediction = null;
      mode = PageMode.choose;
    });
  }

  Widget _buildChooseView() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.9,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black, width: 2)),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        theme:
                            SvgTheme(currentColor: theme.colorScheme.secondary),
                        fit: BoxFit.contain,
                      ),
                    ))),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: _buildButton(const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black54,
                )),
                onTap: () async {
                  await startCamera(0);
                  setState(() {
                    mode = PageMode.camera;
                  });
                },
              ),
              GestureDetector(
                child: _buildButton(const Icon(
                  Icons.folder,
                  color: Colors.black54,
                )),
                onTap: () async {
                  final image = await _pickImage();
                  print(image?.path);
                  if (image != null) {
                    setState(() {
                      _file = image;
                      mode = PageMode.photos;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mode == PageMode.camera) return _buildCameraView();
    if (mode == PageMode.photos) return _buildPhotosView();
    return _buildChooseView();
  }

  Widget _buildAnalizeButton() {
    return GestureDetector(
      onTap: () async {
        print("ANALIZING");
        final result = await _pytorch.getImagePrediction(await _file!.readAsBytes());
        setState(() {
          _prediction = result;
        });
      },
      child: _buildButton(Padding(
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset("assets/images/logo.svg"),
      )),
    );
  }

  Widget _buildButton(Widget icon) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 20,
      ),
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}
