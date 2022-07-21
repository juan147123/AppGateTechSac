import 'package:app_quick_reports/data/models/empresa.dart';
import 'package:app_quick_reports/data/providers/empresa_provider.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';

class ProfileViewController extends GetxController {
  final _authX = Get.find<AuthController>();

  final _empresaProvider = EmpresaProvider();

  final loading = false.obs;
  final allDataLoaded = false.obs;

  Empresa? empresa;

  String appVersion = '';

  @override
  void onInit() {
    super.onInit();

    appVersion = _authX.packageInfo.version;

    _fetchData();
  }

  Future<void> _fetchData() async {
    loading.value = true;
    await tryCatch(
      code: () async {
        empresa =
            await _empresaProvider.getById(_authX.userCredentials!.companyid);
        allDataLoaded.value = true;
      },
      onCancelRetry: () => Get.back(),
    );
    loading.value = false;
  }

  void onChangePasswordButtonTap() {
    Get.toNamed(AppRoutes.PROFILE_PASSWORD);
  }

  void onLogoutButtonTap() {
    _authX.logout();
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    return true;
  }
}
