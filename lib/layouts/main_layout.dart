import 'package:CameraBot/ui/abstract_state.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends AbstractState<MainLayout> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(body: Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          colors: [theme.primaryColor, theme.colorScheme.secondary],
          stops: const [0, 1],
          radius: 1.5,
        ),
      ),
      child: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Camera bot',
                  style: TextStyle(
                    fontSize: 55,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(child: widget.child)
        ],
      )),
    ));
  }
}
