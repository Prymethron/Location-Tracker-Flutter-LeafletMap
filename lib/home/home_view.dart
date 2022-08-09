import 'package:flutter/material.dart';

import 'package:location_notificator_app/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:location_notificator_app/home/home_widgets.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
      ),
      body: HomeMap(),
      floatingActionButton: FAT(),
    );
  }
}
