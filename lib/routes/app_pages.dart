import 'package:app_quick_reports/modules/home/home_page.dart';
import 'package:app_quick_reports/modules/login/form/login_form_page.dart';
import 'package:app_quick_reports/modules/login/lost_password/login_lost_password_page.dart';
import 'package:app_quick_reports/modules/misc/error/misc_error_page.dart';
import 'package:app_quick_reports/modules/misc/prueba/misc_prueba_page.dart';
import 'package:app_quick_reports/modules/profile/password/profile_password_page.dart';
import 'package:app_quick_reports/modules/profile/view/profile_view_page.dart';
import 'package:app_quick_reports/modules/reports/detail/reports_detail_page.dart';
import 'package:app_quick_reports/modules/splash/splash_page.dart';
import 'package:app_quick_reports/modules/view_pdf/view_pdf_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;
  static const _transition = Transition.cupertino;

  static final routes = [
    // LOGIN
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      transition: _transition,
    ),

    // LOGIN
    GetPage(
      name: AppRoutes.LOGIN_FORM,
      page: () => LoginFormPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_LOST_PASSWORD,
      page: () => LoginLostPasswordPage(),
      transition: _transition,
    ),

    // HOME
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      transition: _transition,
    ),

    // PROFILE
    GetPage(
      name: AppRoutes.PROFILE_VIEW,
      page: () => ProfileViewPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PROFILE_PASSWORD,
      page: () => ProfilePasswordPage(),
      transition: _transition,
    ),

    // REPORTS
    GetPage(
      name: AppRoutes.REPORTS_DETAIL,
      page: () => ReportsDetailPage(),
      transition: _transition,
    ),

    // PDF
    GetPage(
      name: AppRoutes.VIEW_PDF,
      page: () => ViewPdfPage(),
      transition: _transition,
    ),

    // MISC
    GetPage(
        name: AppRoutes.MISC_ERROR,
        page: () => MiscErrorPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.MISC_PRUEBA,
        page: () => MiscPruebaPage(),
        transition: _transition),
  ];
}
