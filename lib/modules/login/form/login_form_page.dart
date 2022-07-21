import 'dart:ui';

import 'package:app_quick_reports/modules/login/form/login_form_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFormPage extends StatelessWidget {
  final _conX = Get.put(LoginFormController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/login_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(),
                ),
                Positioned.fill(
                  child: Container(
                    color: akPrimaryColor.withOpacity(.57),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: .63,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.0, 0.60, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            akPrimaryColor.withOpacity(.51),
                            akPrimaryColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: _buildContent(constraints),
                  physics: BouncingScrollPhysics(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Content(
          child: Column(
            children: [
              Expanded(child: SizedBox()), // No quitar
              Column(children: [
                SizedBox(height: 100.0),
                Row(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Hero(
                        tag: 'hLogoApp',
                        child: LogoApp(
                          size: Get.width * .57,
                          whiteMode: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Obx(() => IgnorePointer(
                      ignoring: _conX.loading.value,
                      child: _InputsLogin(_conX),
                    )),
                SizedBox(height: 35.0),
                Obx(() => Stack(
                      children: [
                        AkButton(
                          onPressed: _conX.onLoginButtonTap,
                          fluid: true,
                          enableMargin: false,
                          text: _conX.loading.value ? '' : 'INICIAR SESIÓN',
                          variant: AkButtonVariant.accent,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 17.0,
                          ),
                        ),
                        _conX.loading.value
                            ? Positioned.fill(
                                child: Container(
                                  child: Center(
                                    child: SpinLoadingIcon(
                                      strokeWidth: 3.0,
                                      size: akFontSize + 2.0,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    )),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: _conX.onResetPasswordTap,
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            child: AkText(
                              '¿OLVIDASTE TU CONTRASEÑA?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: akWhiteColor.withOpacity(.60),
                                fontSize: akFontSize - 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 35.0),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputsLogin extends StatelessWidget {
  final LoginFormController _conX;

  const _InputsLogin(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(
      color: Colors.white.withOpacity(.20),
    );
    final textStyle = TextStyle(
      color: Colors.white,
    );
    final inputDecoration = InputDecoration(
      hintText: '',
      hintStyle: hintStyle,
      counterText: '',
      border: OutlineInputBorder(borderSide: BorderSide.none),
    );

    return Column(
      children: [
        _GlassMorphism(
          child: TextFormField(
            controller: _conX.emailCtlr,
            decoration:
                inputDecoration.copyWith(hintText: 'correo@empresa.com'),
            cursorColor: Colors.white,
            keyboardType: TextInputType.emailAddress,
            style: textStyle,
            maxLength: 150,
          ),
        ),
        SizedBox(height: 20.0),
        _GlassMorphism(
          child: TextFormField(
            controller: _conX.passwordCtlr,
            decoration: inputDecoration.copyWith(hintText: 'contraseña'),
            cursorColor: Colors.white,
            obscureText: true,
            style: textStyle,
            maxLength: 30,
          ),
        )
      ],
    );
  }
}

class _GlassMorphism extends StatelessWidget {
  final Widget child;

  const _GlassMorphism({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(13.0);

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24.0,
            spreadRadius: 16.0)
      ]),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16.0,
            sigmaY: 16.0,
          ),
          child: Container(
            width: double.infinity,
            height: 57.0,
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF484848).withOpacity(0.2),
              borderRadius: borderRadius,
              border: Border.all(
                width: 1.5,
                color: Color(0xFF484848).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: this.child,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
