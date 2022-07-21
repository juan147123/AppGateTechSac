import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/home/home_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class MenuDrawer extends StatelessWidget {
  final _authX = Get.find<AuthController>();
  final HomeController homeX;
  final double width;

  MenuDrawer({required this.width, required this.homeX});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: akPrimaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: _buildContent(constraints, context, homeX),
            physics: BouncingScrollPhysics(),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BoxConstraints constraints, BuildContext c, HomeController homeX) {
    // final _cp = akContentPadding;
    final _widthLogoWrapper = width * .90;
    final iSize = akFontSize + 2.0;
    final iColor = Colors.white;

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.12),
                Container(
                  padding: EdgeInsets.symmetric(vertical: width * 0.05),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.08),
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(12.0))),
                  width: _widthLogoWrapper,
                  child: Column(
                    children: [
                      LogoApp(
                        size: width * .45,
                        whiteMode: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                GetBuilder<AuthController>(
                    id: _authX.gbMenuDrawer,
                    builder: (context) {
                      return _NameAndSetting(
                        name: _authX.user?.name ?? '',
                        widthLogoWrapper: _widthLogoWrapper,
                        homeX: homeX,
                      );
                    }),
                SizedBox(height: 30.0),
                _CategoryLabel(
                    label: 'MENÚ PRINCIPAL',
                    widthLogoWrapper: _widthLogoWrapper),
                _buildTile(
                  c,
                  'Mi perfil',
                  Icon(Icons.person_outline_rounded,
                      size: iSize + 2.0, color: iColor.withOpacity(.75)),
                  () => Get.toNamed(AppRoutes.PROFILE_VIEW),
                  homeX,
                ),
                _buildTile(
                  c,
                  'Revisiones',
                  Icon(Icons.format_list_numbered_rtl_outlined,
                      size: iSize + 2.0, color: iColor.withOpacity(.75)),
                  () {},
                  homeX,
                ),
                SizedBox(height: 30.0),
                _VersionBottom(
                  width: width,
                  version: _authX.packageInfo.version,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String text, Widget icon,
      void Function()? onTap, HomeController homeX) {
    final _cp = akContentPadding;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Helpers.darken(akPrimaryColor),
        highlightColor: Helpers.darken(akPrimaryColor),
        onTap: () async {
          ZoomDrawer.of(context)!.close();
          homeX.setStatusMenuVisible(false);

          onTap?.call();
        },
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: _cp, vertical: _cp * 0.87),
                width: width,
                child: Row(
                  children: [
                    SizedBox(width: 10.0),
                    icon,
                    SizedBox(width: 15.0),
                    Expanded(
                      child: AkText(
                        text,
                        style: TextStyle(
                          color: akWhiteColor.withOpacity(.95),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: akFontSize * 1.7,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        // color: akWhiteColor.withOpacity(.28),
                        color: Colors.transparent,
                        size: akFontSize * 0.75,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionBottom extends StatelessWidget {
  final double width;
  final String version;

  const _VersionBottom({Key? key, required this.width, this.version = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cp = akContentPadding;
    return Container(
      width: width,
      padding: EdgeInsets.all(_cp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Opacity(
                opacity: .40,
                child: LogoApp(
                  size: width * .35,
                  whiteMode: true,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: AkText(
                  '   Versión $version',
                  style: TextStyle(
                      fontSize: akFontSize - 3.0,
                      color: akWhiteColor.withOpacity(.40),
                      fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NameAndSetting extends StatelessWidget {
  final String name;
  final double widthLogoWrapper;
  final HomeController homeX;

  const _NameAndSetting(
      {Key? key,
      required this.name,
      required this.widthLogoWrapper,
      required this.homeX})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthLogoWrapper,
      child: Row(
        children: [
          SizedBox(width: akContentPadding * 0.80),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AkText(
                  'Hola,',
                  style: TextStyle(
                    fontSize: akFontSize - 2.0,
                    color: Colors.white.withOpacity(.50),
                  ),
                ),
                AkText(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(.80),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(15, 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(100.0),
              onTap: () {
                ZoomDrawer.of(context)!.close();
                homeX.setStatusMenuVisible(false);
                Get.toNamed(AppRoutes.PROFILE_VIEW);
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/icons/setting_gear.svg',
                  color: akWhiteColor.withOpacity(.80),
                  width: 20.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String label;
  final double widthLogoWrapper;

  const _CategoryLabel(
      {Key? key, required this.label, required this.widthLogoWrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthLogoWrapper,
      padding: EdgeInsets.only(
        top: 35.0,
        bottom: 10.0,
      ),
      child: Row(
        children: [
          SizedBox(width: akContentPadding * 0.8),
          Expanded(
            child: AkText(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(.60),
                fontSize: akFontSize - 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
