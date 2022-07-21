import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:app_quick_reports/config/config.dart';
import 'package:app_quick_reports/data/models/company.dart';
import 'package:app_quick_reports/data/models/detailstr.dart';
import 'package:app_quick_reports/data/models/equipment.dart';
import 'package:app_quick_reports/data/models/user.dart';
import 'package:app_quick_reports/data/providers/company_provider.dart';
import 'package:app_quick_reports/data/providers/equipment_provider.dart';
import 'package:app_quick_reports/data/providers/user_provider.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/view_pdf/view_pdf_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportsDetailController extends GetxController {
  final _authX = Get.find<AuthController>();

  final _equipmentProvider = EquipmentProvider();
  final _userProvider = UserProvider();
  final _companyProvider = CompanyProvider();

  final loading = false.obs;

  final allDataLoaded = false.obs;

  DetailsTR? report;
  Equipment? equipment;
  User? technicalUser;
  CompanyEmployee? supervisorUser;

  bool _permissionReady = false;

  final gbBtnDownload = 'gbBtnDownload';

  @override
  void onInit() {
    super.onInit();

    if (!(Get.arguments is ReportsDetailArguments)) {
      Helpers.showError('Error recibiendo los argumentos');
      return;
    }

    final arguments = Get.arguments as ReportsDetailArguments;
    report = arguments.report;

    if (report!.equipmentId == null) {
      Helpers.showError('Este reporte no tiene equipment');
      return;
    }

    if (report!.technicalUserId == null) {
      Helpers.showError('Este reporte no tiene technicalUser');
      return;
    }

    if (report!.supervisorUserId == null) {
      Helpers.showError('Este reporte no tiene supervisorUser');
      return;
    }

    // Set initial to Download
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);

    _permissionReady = false;

    _fetchData();
  }

  @override
  void onClose() {
    _unbindBackgroundIsolate();
    super.onClose();
  }

  Future<void> _fetchData() async {
    loading.value = true;
    await tryCatch(
      code: () async {
        equipment = await _equipmentProvider.getById(report!.equipmentId!);
        technicalUser =
            await _userProvider.getUserById(report!.technicalUserId!);
        supervisorUser =
            await _companyProvider.getEmployeeById(report!.supervisorUserId!);
      },
      onCancelRetry: () => Get.back(),
    );
    _prepare();
  }

  Future<bool> isEnableToDownload() async {
    if (!_permissionReady) {
      _permissionReady = await _checkPermission();

      if (_permissionReady) {
        await _prepareSaveDir();
      } else {
        AppSnackbar().warning(
            message:
                'Debes habilitar los permisos de almacenamiento para descargar.');
        return false;
      }
    }

    return true;
  }

  void onButtonViewTap() async {
    Get.toNamed(
      AppRoutes.VIEW_PDF,
      arguments: ViewPdfViewArguments(report: report!),
    );
  }

  final dwPercent = 0.obs;
  void showDownloadProgress(int percent) {
    dwPercent.value = percent;
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    if (isDownloadingFile(dwPercent.value)) return false;

    return true;
  }

  //*****************************************/
  //***** LOGICA PARA DESCARGAR ARCHIVO *****/
  //*****************************************/
  List<TaskInfo>? tasks;
  late String _localPath;
  ReceivePort _port = ReceivePort();

  Future<void> _prepare() async {
    final tasksSQLite = await FlutterDownloader.loadTasks();

    tasks = [];

    // Limpiar SQLite solo para Depuración.
    // Mantener comentado
    /* if (tasksSQLite != null) {
      for (var tsq in tasksSQLite) {
        await FlutterDownloader.remove(taskId: tsq.taskId);
      }
    } */

    // Adding task to download
    tasks!.add(TaskInfo(
      name: 'Reporte_${report!.id}',
      link:
          '${Config.URL_API}/api/detailstechnicalreviewallpdfapp/${report!.id}',
    ));

    tasksSQLite!.forEach((task) {
      for (TaskInfo info in tasks!) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    allDataLoaded.value = true;
    loading.value = false;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (_authX.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt != null &&
        androidInfo.version.sdkInt! <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (Config.DOWNLOAD_DEBUG) {
        print('UI Isolate Callback: $data');
      }

      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      if (tasks != null && tasks!.isNotEmpty) {
        final task = tasks!.firstWhere((task) => task.taskId == id);
        task.status = status;
        task.progress = progress;

        if (task.status == DownloadTaskStatus.failed) {
          AppSnackbar().error(message: 'No se pudo descargar el archivo');
        }

        update([gbBtnDownload]);
        if (task.progress is int) {
          showDownloadProgress(task.progress!);
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (Config.DOWNLOAD_DEBUG) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> requestDownload(TaskInfo task) async {
    if (!(await isEnableToDownload())) return;

    final dateTime =
        formatDate(DateTime.now(), [yyyy, mm, dd, '_', HH, nn, ss]);

    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {'Authorization': 'Bearer ${_authX.userCredentials!.token}'},
      fileName: task.name! + '_$dateTime' + '.pdf',
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }

  Future<void> retryDownload(TaskInfo task) async {
    if (!(await isEnableToDownload())) return;

    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> cancelDownload(TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId!);
  }

  Future<bool> openDownloadedFile(TaskInfo? task) async {
    if (!(await isEnableToDownload())) return false;

    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> delete(TaskInfo task) async {
    if (!(await isEnableToDownload())) return;

    await FlutterDownloader.remove(
        taskId: task.taskId!, shouldDeleteContent: true);
    await _prepare();
    update([gbBtnDownload]);
  }

  // ***** Config Download Path *****/
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  bool isDownloadingFile(int processDownload) {
    return (processDownload != 0 &&
        processDownload != 100 &&
        processDownload != -1);
  }
}

class ReportsDetailArguments {
  final DetailsTR report;

  ReportsDetailArguments({required this.report});
}

class TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInfo({this.name, this.link});
}
