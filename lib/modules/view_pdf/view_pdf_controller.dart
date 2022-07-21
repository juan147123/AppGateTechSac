import 'dart:io';
import 'dart:typed_data';

import 'package:app_quick_reports/data/models/detailstr.dart';
import 'package:app_quick_reports/data/providers/pdf_provider.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class ViewPdfViewController extends GetxController {
  late ViewPdfViewController _self;
  final _pdfProvider = PdfProvider();

  static const int _initialPage = 1;
  bool isSampleDoc = true;
  PdfControllerPinch? pdfControllerPinch;

  // Getbuilder ID's
  final gbPdfActions = 'gbPdfActions';
  final gbPdfViewer = 'gbPdfViewer';

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    if (!(Get.arguments is ViewPdfViewArguments)) {
      Helpers.showError('Error recibiendo los argumentos');
      return;
    }

    final arguments = Get.arguments as ViewPdfViewArguments;

    _fetchData(arguments.report);
  }

  @override
  void onClose() {
    pdfControllerPinch?.dispose();
    super.onClose();
  }

  Future<void> _fetchData(DetailsTR report) async {
    tryCatch(
      self: _self,
      code: () async {
        final path = await loadPdf(report);
        if (_self.isClosed) return;
        pdfControllerPinch = PdfControllerPinch(
          document: PdfDocument.openFile(path),
          initialPage: _initialPage,
        );
        update([gbPdfViewer, gbPdfActions]);
      },
      onCancelRetry: () => Get.back(),
    );
  }

  // ******** FUNCIONES PARA DESCARGAR EL ARCHIVO **********
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/last_review.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPDF(DetailsTR report) async {
    final response = await _pdfProvider.getDetailsPDF(
      technicalReviewId: report.id,
    );
    return response;
  }

  Future<String> loadPdf(DetailsTR report) async {
    await writeCounter(await fetchPDF(report));

    return (await _localFile).path;
  }
}

class ViewPdfViewArguments {
  final DetailsTR report;

  ViewPdfViewArguments({required this.report});
}
