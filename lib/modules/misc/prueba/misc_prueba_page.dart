import 'package:app_quick_reports/modules/misc/prueba/misc_prueba_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MiscPruebaPage extends StatelessWidget {
  final _conX = Get.put(MiscPruebaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => AkText(
                'Loading: ${_conX.loading.value.toString().toUpperCase()}')),
            SizedBox(height: 15.0),
            AkButton(
              onPressed: _conX.launch,
              text: 'Launch',
            ),
          ],
        ),
      ),
    );
  }
}
