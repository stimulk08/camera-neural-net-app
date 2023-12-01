import 'package:CameraBot/core/app_bindings.dart';
import 'package:CameraBot/core/config.dart';
import 'package:CameraBot/core/pytorch_service.dart';
import 'package:CameraBot/layouts/main_layout.dart';
import 'package:CameraBot/pages/main/main_page.dart';
import 'package:CameraBot/styles.dart';
import 'package:CameraBot/ui/abstract_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends AbstractState<SplashScreen> {
  bool visible = false;
  double size = 0.9;

  Future<void> initServices() async {
    await AppBindings().dependencies();
    final pytorchService = Get.find<PytorchService>();
    await pytorchService.initImageModel("assets/models/$modelFileName", "assets/labels/$labelFileName");
    await Future.delayed(const Duration(seconds: 5), () => print(123));
  }

  @override
  void onInitPage() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        visible = true;
      });
    });
    initServices().then((_) => Get.offAll(
          () => const MainLayout(
            child: MainPage(),
          ),
          duration: const Duration(seconds: 1),
        ));
  }

  void performScale() {
    setState(() {
      size = (size == 0.9) ? 1 : 0.9;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Camera bot", style: headerStyle),
              const SizedBox(height: 30,),
              AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(seconds: 1, milliseconds: 500),
                curve: Curves.easeInQuad,
                onEnd: performScale,
                child: AnimatedScale(
                  scale: size,
                  curve: Curves.easeInSine,
                  duration: const Duration(milliseconds: 800),
                  onEnd: performScale,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    theme: SvgTheme(currentColor: theme.colorScheme.secondary),
                    height: 150,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
