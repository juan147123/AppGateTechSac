import 'package:app_quick_reports/data/models/detailstr.dart';
import 'package:app_quick_reports/modules/home/home_controller.dart';
import 'package:app_quick_reports/modules/reports/components/menu_icon.dart';
import 'package:app_quick_reports/modules/reports/list/reports_list_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class ReportsListPage extends StatelessWidget {
  final HomeController _homeX;
  final _conX = Get.put(ReportsListController());

  ReportsListPage(this._homeX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canPop = Navigator.of(context).canPop();
        if (canPop) {
          return true;
        } else {
          final exitAppConfirm = await Helpers.confirmCloseAppDialog();
          return exitAppConfirm;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                color: Colors.transparent,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          MenuIcon(
                            size: 5.0,
                            onPressed: () {
                              var zoomDrawer = ZoomDrawer.of(context)!;
                              zoomDrawer.open();
                              _homeX.setStatusMenuVisible(true);
                              Get.focusScope?.unfocus();
                            },
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                LogoApp(
                                  size: Get.width * .45,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(child: _BodyContent(_conX))
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Obx(() => _homeX.isMenuVisible.value
                  ? GestureDetector(
                      onTap: () {
                        var zoomDrawer = ZoomDrawer.of(context)!;
                        zoomDrawer.close();
                        _homeX.setStatusMenuVisible(false);
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    )
                  : SizedBox()),
            ),
            Obx(() => LoadingLayer(_conX.loading.value)),
          ],
        ),
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  final ReportsListController _conX;

  const _BodyContent(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Content(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                SearchInput(
                  onChanged: (val) => _conX.searchText.value = val.trim(),
                  onSearchTap: _conX.onSeachTap,
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _conX.loading.value
                  ? _ExpedientesSkeletonList()
                  : _ExpedientesList(conX: _conX),
            ),
          ),
        )
      ],
    );
  }
}

class _ExpedientesList extends StatelessWidget {
  final ReportsListController conX;

  const _ExpedientesList({Key? key, required this.conX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conX.listReports.length == 0) {
      return _NoItems();
    }

    return GetBuilder<ReportsListController>(
        id: conX.gbList,
        builder: (_) {
          List<DetailsTR> list = [];
          if (conX.searchText.value.isNotEmpty) {
            list = conX.listReports
                .where((promo) =>
                    (promo.title?.toLowerCase() ?? '##############')
                        .contains(conX.searchText.value.toLowerCase()))
                .toList();
          } else {
            list = conX.listReports;
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (_, i) {
              return Content(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    i == 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 6.0,
                              bottom: 6.0,
                            ),
                            child: AkText(
                              'Reportes',
                              style: TextStyle(
                                color: akTitleColor,
                                fontWeight: FontWeight.w500,
                                fontSize: akFontSize + 4.0,
                              ),
                            ),
                          )
                        : SizedBox(),
                    _ListItem(
                      report: list[i],
                      isFirst: i == 0,
                      isLast: i == (list.length - 1),
                      // alternate: !(i % 2 == 0),
                      alternate: (i % 2 == 0),
                      onTap: conX.onItemListTap,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class _ListItem extends StatelessWidget {
  final DetailsTR report;
  final bool isFirst;
  final bool isLast;
  final double bubbleSize = 10.0;
  final bool alternate;
  final void Function(DetailsTR report)? onTap;

  const _ListItem({
    Key? key,
    required this.report,
    this.isFirst = false,
    this.isLast = false,
    this.alternate = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlyDayMonth = report.inspectionDate == null
        ? ''
        : formatDate(report.inspectionDate!, [dd, '-', M],
            locale: SpanishDateLocale());

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(height: 15.0),
              Container(
                width: akFontSize * 3.3,
                child: AkText(
                  onlyDayMonth,
                  style: TextStyle(
                    fontSize: akFontSize - 2.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 2.0),
          Container(
            child: Column(
              children: [
                _LineVertical(
                  height: 15.0,
                  color: isFirst ? Colors.transparent : akPrimaryColor,
                ),
                Container(
                  padding: EdgeInsets.all(bubbleSize * 0.2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300.0),
                    border: Border.all(
                      color: akPrimaryColor,
                      width: 2.0,
                    ),
                  ),
                  child: Container(
                    width: bubbleSize,
                    height: bubbleSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300.0),
                        color: isFirst
                            ? akPrimaryColor
                            : akPrimaryColor.withOpacity(.2)),
                  ),
                ),
                Expanded(
                  child: _LineVertical(
                    color: isLast ? Colors.transparent : akPrimaryColor,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(akContentPadding * 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 13.0),
                  _CardDescription(
                    report: this.report,
                    alternate: alternate,
                    onTap: () {
                      onTap?.call(this.report);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineVertical extends StatelessWidget {
  final Color color;
  final double? height;

  const _LineVertical({Key? key, required this.color, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: 2.0,
      height: height,
      color: color,
    );

    if (height != null) {
      return Column(
        children: [line],
      );
    } else {
      return line;
    }
  }
}

class _ExpedientesSkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final total = 10;
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: total,
      itemBuilder: (_, i) => _SkeletonItem(
        isFirst: i == 0,
        isLast: i == (total - 1),
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _SkeletonItem({Key? key, this.isFirst = false, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Content(
      child: Container(
        child: Opacity(
          opacity: .55,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: akFontSize * 3,
                  child: Column(
                    children: [
                      SizedBox(height: 18.0),
                      Skeleton(fluid: true, height: 12.0),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Column(
                  children: [
                    _LineVertical(
                      height: 15.0,
                      color: isFirst
                          ? Colors.transparent
                          : akGreyColor.withOpacity(0.45),
                    ),
                    Skeleton(width: 18.0, height: 18.0),
                    Expanded(
                      child: _LineVertical(
                        color: isLast
                            ? Colors.transparent
                            : akGreyColor.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Skeleton(fluid: true, height: 15.0)),
                          Expanded(flex: 6, child: SizedBox())
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Skeleton(fluid: true, height: 12.0)),
                          Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                              flex: 2,
                              child: Skeleton(fluid: true, height: 12.0)),
                          Expanded(flex: 4, child: SizedBox()),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: Skeleton(fluid: true, height: 12.0)),
                          Expanded(flex: 3, child: SizedBox())
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Skeleton(fluid: true, height: 12.0)),
                          Expanded(flex: 8, child: SizedBox())
                        ],
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -100),
      child: Opacity(
        opacity: .6,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: akContentPadding * 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/empty_box.svg',
                width: Get.width * 0.22,
                color: akTextColor.withOpacity(.45),
              ),
              AkText(
                'No hay resultados para mostrar',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDescription extends StatelessWidget {
  final DetailsTR report;
  final bool alternate;
  final void Function()? onTap;

  _CardDescription({required this.report, this.alternate = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final onlyTime = report.inspectionDate == null
        ? ''
        : (formatDate(report.inspectionDate!, [hh, ':', nn, ' ', am]))
            .toLowerCase();
    final imgSize = 30.0;

    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Container(
          decoration: BoxDecoration(
            color: akWhiteColor,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                onTap?.call();
              },
              child: Container(
                width: double.infinity,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: alternate ? akAccentColor : akPrimaryColor,
                        width: 6.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: imgSize,
                                // height: imgSize,
                                decoration: BoxDecoration(
                                  color: akScaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(akFontSize * 0.5),
                                child: CIconFolder(
                                  size: imgSize,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AkText(
                                          'Hora: ',
                                          style: TextStyle(
                                            color:
                                                akTitleColor.withOpacity(.67),
                                            fontSize: akFontSize - 2.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          child: AkText(
                                            onlyTime,
                                            style: TextStyle(
                                              fontSize: akFontSize - 2.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      child: AkText(
                                        report.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          height: 1.45,
                                          fontSize: akFontSize - 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
