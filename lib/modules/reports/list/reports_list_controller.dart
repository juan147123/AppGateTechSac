import 'package:app_quick_reports/data/models/detailstr.dart';
import 'package:app_quick_reports/data/providers/detailstr_provider.dart';
import 'package:app_quick_reports/data/providers/user_provider.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/misc/error/misc_error_controller.dart';
import 'package:app_quick_reports/modules/reports/detail/reports_detail_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';

class ReportsListController extends GetxController {
  late ReportsListController _self;

  final _authX = Get.find<AuthController>();

  final _detailsTRProvider = DetailsTRProvider();
  final _userProvider = UserProvider();

  final loading = true.obs;
  List<DetailsTR> listReports = [];

  final gbList = 'gbList';
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    debounce<String>(searchText, (txt) {
      filterList(txt);
    }, time: Duration(milliseconds: 600));

    _init();
  }

  Future<void> _init() async {
    _getUserData();
  }

  Future<void> _getUserData() async {
    String? errorMsg;
    try {
      loading.value = true;
      final data = await _userProvider.getUserById(_authX.userCredentials!.id);
      _authX.setUser(data);
      _authX.refreshMenuDrawer();
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg =
          'Ocurrió un error inesperado obteniendo información del usuario.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _getUserData();
      } else {
        loading.value = false;

        // Si hay un error, cerramos la sesión
        _authX.logout();
      }
    } else {
      loading.value = false;

      _fetchList();
    }
  }

  Future<void> _fetchList() async {
    String? errorMsg;
    try {
      loading.value = true;
      listReports = [];
      final items = await _detailsTRProvider
          .getListByCompanyId(int.parse(_authX.userCredentials!.companyid));
      listReports = items;
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado obteniendo la lista de reportes.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _fetchList();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
    }
  }

  Future<void> onSeachTap() async {}

  void onItemListTap(DetailsTR report) {
    Get.focusScope?.unfocus();
    Get.toNamed(AppRoutes.REPORTS_DETAIL,
        arguments: ReportsDetailArguments(report: report));
  }

  void filterList(String term) {
    update([gbList]);
  }
}
