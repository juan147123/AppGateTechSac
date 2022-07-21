import 'package:get/get.dart';

class HomeController extends GetxController {
  final isMenuVisible = false.obs;

  void setStatusMenuVisible(bool value) {
    isMenuVisible.value = value;
  }
}
