import 'package:app_quick_reports/modules/splash/splash_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final _conX = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    _conX.authX.platform = Theme.of(context).platform;

    return Scaffold(
      backgroundColor: akPrimaryColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => _conX.logoCacheLoaded.value
                  ? Material(
                      type: MaterialType.transparency,
                      child: Hero(
                        tag: 'hLogoApp',
                        child: LogoApp(
                          size: Get.width * 0.45,
                          whiteMode: true,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
