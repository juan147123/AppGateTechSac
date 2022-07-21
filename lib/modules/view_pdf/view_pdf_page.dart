import 'package:app_quick_reports/modules/view_pdf/view_pdf_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class ViewPdfPage extends StatelessWidget {
  final _conX = Get.put(ViewPdfViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.only( akContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.0),
              Row(
                children: [
                  ArrowBack(onTap: () => Get.back()),
                  GetBuilder<ViewPdfViewController>(
                      id: _conX.gbPdfActions,
                      builder: (_) {
                        if (_conX.pdfControllerPinch != null) {
                          return Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.navigate_before,
                                    color: akTextColor,
                                  ),
                                  onPressed: () {
                                    _conX.pdfControllerPinch!.previousPage(
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 100),
                                    );
                                  },
                                ),
                                PdfPageNumber(
                                  controller: _conX.pdfControllerPinch!,
                                  builder:
                                      (_, loadingState, page, pagesCount) =>
                                          Container(
                                    alignment: Alignment.center,
                                    child: AkText(
                                      '$page/${pagesCount ?? 0}',
                                      style: TextStyle(
                                        fontSize: akFontSize,
                                        color: akTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: akTextColor,
                                  ),
                                  onPressed: () {
                                    _conX.pdfControllerPinch!.nextPage(
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 100),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.zoom_in_map_rounded,
                                    color: akTextColor,
                                    size: akFontSize + 8.0,
                                  ),
                                  onPressed: () {
                                    _conX.pdfControllerPinch!.animateToPage(
                                        pageNumber:
                                            _conX.pdfControllerPinch!.page);
                                  },
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ],
              ),
              GetBuilder<ViewPdfViewController>(
                  id: _conX.gbPdfViewer,
                  builder: (_) {
                    if (_conX.pdfControllerPinch != null) {
                      return _buildBody();
                    } else {
                      return Expanded(child: _LoadCenter());
                    }
                  }),
            ],
          ),
        ),
      ),
      /*appBar: AppBar(
        title: const Text('Pdfx example'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _conX.pdfControllerPinch.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _conX.pdfControllerPinch,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _conX.pdfControllerPinch.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_conX.isSampleDoc) {
                _conX.pdfControllerPinch.loadDocument(
                    PdfDocument.openAsset('assets/files/flutter_tutorial.pdf'));
              } else {
                _conX.pdfControllerPinch.loadDocument(
                    PdfDocument.openAsset('assets/files/hello.pdf'));
              }
              _conX.isSampleDoc = !_conX.isSampleDoc;
            },
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                // otro();
              },
              child: Text('holsa')),
          Expanded(
            child: PdfViewPinch(
              builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                pageLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                errorBuilder: (_, error) =>
                    Center(child: Text(error.toString())),
              ),
              controller: _conX.pdfControllerPinch,
            ),
          ),
        ],
      ),*/
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Container(
        color: Color(0xFF9F9CA0),
        child: PdfViewPinch(
          builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) => _LoadCenter(),
            pageLoaderBuilder: (_) => const _LoadCenter(),
            errorBuilder: (_, error) => Center(child: Text(error.toString())),
          ),
          controller: _conX.pdfControllerPinch!,
        ),
      ),
    );
  }
}

class _LoadCenter extends StatelessWidget {
  const _LoadCenter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
        ),
        LoadingLayer(
          true,
          bgColor: Colors.transparent,
        ),
      ],
    );
  }
}
