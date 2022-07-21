import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/profile/view/profile_view_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileViewPage extends StatelessWidget {
  final _conX = Get.put(ProfileViewController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _conX.handleBack,
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.transparent),
            Positioned.fill(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: akContentPadding * 0.5),
                      ArrowBack(onTap: () async {
                        if (await _conX.handleBack()) Get.back();
                      }),
                      Obx(() => _conX.allDataLoaded.value
                          ? Content(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.0),
                                  /* Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _AvatarStyled(),
                                    ],
                                  ), */
                                  SizedBox(height: 20.0),
                                  _BodyContent(_conX),
                                ],
                              ),
                            )
                          : SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => LoadingLayer(_conX.loading.value)),
          ],
        ),
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  final _authX = Get.find<AuthController>();
  final ProfileViewController conX;

  _BodyContent(
    this.conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Color(0xFFE1E4EB), borderRadius: BorderRadius.circular(5)),
          child: AkText(
            'Mis datos',
            style: TextStyle(color: akPrimaryColor),
          ),
        ),
        SizedBox(height: 20.0),
        AkText(
          _authX.user?.name ?? '',
          style: TextStyle(
            fontSize: akFontSize + 8.0,
            fontWeight: FontWeight.w500,
            color: akTitleColor,
          ),
        ),
        SizedBox(height: 30.0),
        _DataItem(
            label: 'Empresa', text: conX.empresa?.name ?? '', icon: 'id_card'),
        _DataItem(
            label: 'Contacto',
            text: _authX.user?.name ?? '',
            iconColor: akTitleColor,
            icon: 'user'),
        _DataItem(
            label: 'Correo electrónico',
            text: _authX.user?.email ?? '',
            icon: 'email'),
        _DataItem(
          label: 'Nro documento',
          text: _authX.user?.ndocument ?? '',
          icon: 'user',
          iconColor: akTitleColor,
          iconWidth: akFontSize + 3.0,
        ),
        SizedBox(height: 10.0),
        AkButton(
          type: AkButtonType.outline,
          fluid: true,
          onPressed: conX.onChangePasswordButtonTap,
          text: 'Cambiar contraseña',
        ),
        SizedBox(height: 10.0),
        AkButton(
          type: AkButtonType.outline,
          variant: AkButtonVariant.red,
          fluid: true,
          onPressed: conX.onLogoutButtonTap,
          text: 'Cerrar sesión',
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AkText(
                'Versión ${conX.appVersion}',
                style: TextStyle(
                    color: akTitleColor.withOpacity(
                  .40,
                )),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String text;
  final String icon;
  final Color? iconColor;
  final double? iconWidth;

  const _DataItem({
    Key? key,
    required this.label,
    required this.text,
    required this.icon,
    this.iconWidth,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalIconSize = this.iconWidth ?? akFontSize + 2.0;

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
              Container(
                alignment: Alignment.centerLeft,
                width: akFontSize * 2.2,
                child: SvgPicture.asset(
                  'assets/icons/$icon.svg',
                  width: finalIconSize,
                  color: iconColor ?? akTextColor,
                ),
              ),
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

class _AvatarStyled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sqSize = Get.width * 0.35;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -6.0,
          left: -10.0,
          child: SquareRoundedWidget(
            size: sqSize,
            color: akAccentColor,
          ),
        ),
        Positioned(
          top: 7.0,
          left: 10.0,
          child: SquareRoundedWidget(
            size: sqSize,
            color: akPrimaryColor,
          ),
        ),
        Stack(
          children: [
            SquareRoundedWidget(
              size: sqSize,
              color: Helpers.darken(akScaffoldBackgroundColor),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Helpers.darken(akScaffoldBackgroundColor),
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Container(
                    child: ImageFade(
                      imageUrl:
                          'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SquareRoundedWidget extends StatelessWidget {
  final double size;
  final Color color;

  const SquareRoundedWidget(
      {Key? key, this.size = 40.0, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red),
          color: color,
          borderRadius: BorderRadius.circular(9.0),
        ),
      ),
    );
  }
}
