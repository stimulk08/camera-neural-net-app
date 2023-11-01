import 'package:CameraBot/core/app_bindings.dart';
import 'package:CameraBot/layouts/get_page_of.dart';
import 'package:CameraBot/layouts/main_layout.dart';
import 'package:CameraBot/pages/main/main_page.dart';
import 'package:CameraBot/pages/splash/splash_screen.dart';
import 'package:CameraBot/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const LazyMails());
}

class LazyMails extends StatelessWidget {
  const LazyMails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lazy Mails',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialBinding: AppBindings(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPageOf<MainLayout>(
          '/edit-letter',
          const MainPage(),
              (page) => MainLayout(child: page),
        ),
      ],
    );
  }
}