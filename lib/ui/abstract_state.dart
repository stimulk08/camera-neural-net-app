import 'package:flutter/material.dart';

abstract class AbstractState<T extends StatefulWidget> extends State<T> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    onInitPage();
  }

  void onInitPage() {}

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  void onDispose() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    theme = Theme.of(context);

    onDidChangeDependencies();
  }

  void onDidChangeDependencies() {}
}