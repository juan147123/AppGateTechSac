import 'package:app_quick_reports/modules/home/components/menu_drawer.dart';
import 'package:app_quick_reports/modules/home/home_controller.dart';
import 'package:app_quick_reports/modules/reports/list/reports_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final _conX = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final drawerWidth = Get.width - 150.0;

    return ZoomDrawer(
      slideWidth: drawerWidth,
      duration: Duration(milliseconds: 200),
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeInOut,
      style: DrawerStyle.Style6,
      menuScreen: MenuDrawer(
        width: drawerWidth + 50.0,
        homeX: _conX,
      ),
      mainScreen: ReportsListPage(_conX),
    );
  }
}
