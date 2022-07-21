import 'package:animate_do/animate_do.dart';
import 'package:app_quick_reports/modules/reports/detail/reports_detail_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

class ReportsDetailPage extends StatelessWidget {
  final _conX = Get.put(ReportsDetailController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _conX.handleBack,
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: _buildContent(constraints),
                  physics: BouncingScrollPhysics(),
                );
              },
            ),
            Obx(
              () => _conX.allDataLoaded.value
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FadeIn(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: akContentPadding * 0.85),
                          decoration: BoxDecoration(
                            color: akScaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF8D8B8B).withOpacity(.4),
                                blurRadius: 8,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: _buildMainButton(),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
            Obx(() => LoadingLayer(_conX.loading.value)),
            Obx(() => _conX.isDownloadingFile(_conX.dwPercent.value)
                ? _buildDownloading(_conX.dwPercent.value.toDouble())
                : SizedBox())
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: akContentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.0),
                Row(
                  children: [
                    ArrowBack(
                      onTap: () async =>
                          await _conX.handleBack() ? Get.back() : null,
                    ),
                  ],
                ),
                Obx(() => _conX.allDataLoaded.value
                    ? FadeIn(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTitle(),
                            _buildBody(),
                          ],
                        ),
                      )
                    : SizedBox()),
                // Expanded(child: SizedBox()), // No quitar
                SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Content(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CIconFolder(
                  size: Get.width * 0.30,
                ),
              ],
            ),
            SizedBox(height: 35.0),
            AkText(
              _conX.report?.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: akFontSize + 8.0,
                color: akTitleColor,
              ),
            ),
            SizedBox(height: 7.0),
            AkText(_conX.report?.content ?? ''),
            SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Content(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DataItem(
                label: 'Equipo', text: _conX.equipment?.description ?? ''),
            _DataItem(
                label: 'Fecha',
                text: _conX.report?.inspectionDate?.toIso8601String() ?? ''),
            _DataItem(label: 'Técnico', text: _conX.technicalUser?.name ?? ''),
            _DataItem(
                label: 'Supervisor', text: _conX.supervisorUser?.name ?? ''),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Content(
      child: Row(
        children: [
          Expanded(
            child: GetBuilder<ReportsDetailController>(
              id: _conX.gbBtnDownload,
              builder: (_) {
                if (_conX.tasks?.isNotEmpty ?? false) {
                  return _BtnDownload(
                    task: _conX.tasks!.first,
                    onDownloadTap: (t) {
                      print('onDownloadTap');
                      _conX.requestDownload(t);
                    },
                    onRetryTap: (t) {
                      print('onRetryTap');
                      _conX.retryDownload(t);
                    },
                    onOpenTap: (t) {
                      print('onOpenTap');
                      _conX.openDownloadedFile(t).then((success) {
                        if (!success) {
                          AppSnackbar()
                              .error(message: 'No se puede abrir el archivo');
                        }
                      });
                    },
                    onDeleteTap: (t) {
                      print('onDeleteTap');
                      _conX.delete(t);
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          SizedBox(width: 8.0),
          _BtnView(onPressed: _conX.onButtonViewTap)
        ],
      ),
    );
  }

  Widget _buildDownloading(double widthFactor) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(color: Colors.black.withOpacity(.35)),
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(akContentPadding * 2),
          padding: EdgeInsets.all(akContentPadding),
          decoration: BoxDecoration(
            color: akWhiteColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 6.0,
                spreadRadius: 4.0,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AkText(
                'Descargando...',
                style: TextStyle(
                  fontSize: akFontSize + 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              _DownloadBar(
                widthFactor: widthFactor,
              ),
              SizedBox(height: 15.0),
              AkButton(
                fluid: true,
                enableMargin: false,
                onPressed: () {
                  _conX.cancelDownload(_conX.tasks!.first);
                },
                text: 'Cancelar',
                type: AkButtonType.outline,
                size: AkButtonSize.small,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BtnView extends StatelessWidget {
  final VoidCallback onPressed;

  const _BtnView({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AkButton(
      contentPadding: EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 20.0,
      ),
      enableMargin: false,
      onPressed: onPressed,
      variant: AkButtonVariant.accent,
      backgroundColor: akAccentColor,
      child: Row(
        children: [
          Icon(
            Icons.remove_red_eye_outlined,
            color: akTextColor,
          ),
          SizedBox(width: 10.0),
          AkText(
            'VER',
            style: TextStyle(
              color: akTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 5.0),
        ],
      ),
    );
  }
}

enum _TypeBtnDownload { base, complete, failed }

class _BtnDownload extends StatelessWidget {
  final TaskInfo task;
  final Function(TaskInfo)? onDownloadTap;
  final Function(TaskInfo)? onRetryTap;
  final Function(TaskInfo)? onOpenTap;
  final Function(TaskInfo)? onDeleteTap;

  const _BtnDownload({
    Key? key,
    required this.task,
    this.onDownloadTap,
    this.onRetryTap,
    this.onOpenTap,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bRadius = 30.0;

    Color bgColor = Colors.indigo;
    Color textColor = Colors.teal;

    _TypeBtnDownload type = _TypeBtnDownload.base;

    if (task.status == DownloadTaskStatus.complete) {
      type = _TypeBtnDownload.complete;
      bgColor = Color(0xFF276EF1);
      textColor = akWhiteColor;
    } else if (task.status == DownloadTaskStatus.failed) {
      type = _TypeBtnDownload.failed;
      bgColor = akErrorColor;
      textColor = akWhiteColor;
    } else {
      bgColor = akTextColor;
      textColor = akWhiteColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Helpers.lighten(bgColor, 0.05)),
        borderRadius: BorderRadius.circular(bRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(bRadius),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (type == _TypeBtnDownload.complete)
                Container(
                  color: Helpers.darken(bgColor, 0.05),
                  child: PopupMenuButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: akWhiteColor,
                    ),
                    offset: Offset(0, -70),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Eliminar archivo'),
                        value: 1,
                        onTap: () {
                          if (task.status == DownloadTaskStatus.complete) {
                            onDeleteTap?.call(task);
                          }
                        },
                      )
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  color: bgColor,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        if (task.status == DownloadTaskStatus.undefined) {
                          onDownloadTap?.call(task);
                        } else if (task.status == DownloadTaskStatus.complete) {
                          onOpenTap?.call(task);
                        } else if (task.status == DownloadTaskStatus.failed ||
                            task.status == DownloadTaskStatus.canceled) {
                          onRetryTap?.call(task);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 14.0,
                        ),
                        child: (task.status == DownloadTaskStatus.enqueued ||
                                task.status == DownloadTaskStatus.running)
                            ? Center(
                                child: SpinLoadingIcon(
                                  size: akFontSize,
                                ),
                              )
                            : AkText(
                                type == _TypeBtnDownload.complete
                                    ? 'ABRIR'
                                    : (type == _TypeBtnDownload.failed
                                        ? 'REINTENTAR'
                                        : 'DESCARGAR'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadBar extends StatelessWidget {
  final double widthFactor;

  _DownloadBar({
    Key? key,
    required this.widthFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fracFactor = widthFactor / 100;

    return Stack(
      children: [
        Container(
          height: 10.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: akAccentColor.withOpacity(.15),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        FractionallySizedBox(
          widthFactor: fracFactor < 0 ? 0 : (fracFactor > 1 ? 1 : fracFactor),
          child: Container(
            height: 10.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: akAccentColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ],
    );
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String text;
  final Color? iconColor;
  final double? iconWidth;

  const _DataItem({
    Key? key,
    required this.label,
    required this.text,
    this.iconWidth,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AkText(
            label,
            style: TextStyle(
              color: akTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: akFontSize + 4.0,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: AkText(
                  text,
                  style: TextStyle(
                    fontSize: akFontSize,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
