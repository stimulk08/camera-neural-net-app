import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GetPageOf<T extends Widget> extends GetPage {
  GetPageOf(
      String name,
      Widget page,
      T Function(Widget page) creator
      ) : super(name: name, page: () => creator(page));
}