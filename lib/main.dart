import 'package:app_quick_reports/config/config.dart';
import 'package:app_quick_reports/instance_binding.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await FlutterDownloader.initialize(debug: Config.DOWNLOAD_DEBUG);

  await GetStorage.init();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://44880915835f4308a3af531271d0a72b@o1197162.ingest.sentry.io/6334310';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    customizeAkStyle();
    return GetMaterialApp(
      initialBinding: InstanceBinding(),
      debugShowCheckedModeBanner: true,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
      ],
      title: 'Quick Reports',
      theme: dfAppThemeLight,
      darkTheme: dfAppThemeDark,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
