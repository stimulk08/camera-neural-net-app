import 'package:CameraBot/ui/abstract_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PageMode { camera, photos, choose }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends AbstractState<MainPage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int direction = 0;
  PageMode mode = PageMode.choose;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> startCamera(int direction) async {
    cameras = await availableCameras();
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  child: CameraPreview(cameraController))),
        ),
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                cameraController.takePicture().then((XFile? file) {
                  if (mounted) {
                    if (file != null) {
                      print("Picture saved to ${file.path}");
                    }
                  }
                });
              },
              child: _buildButton(Icons.camera_alt_outlined),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  mode = PageMode.choose;
                });
              },
              child: _buildButton(Icons.close),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosView() {
    return Container(color: Colors.green);
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
                child: _buildButton(Icons.camera_alt_outlined),
                onTap: () async {
                  await startCamera(0);
                  setState(() {
                    mode = PageMode.camera;
                  });
                },
              ),
              GestureDetector(
                child: _buildButton(Icons.folder),
                onTap: () async {
                  setState(() {
                    mode = PageMode.photos;
                  });
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

  Widget _buildButton(IconData icon) {
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
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }
}
