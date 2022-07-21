import 'package:app_quick_reports/modules/login/lost_password/login_lost_password_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginLostPasswordPage extends StatelessWidget {
  final _conX = Get.put(LoginLostPasswordController());

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
            Obx(() => LoadingLayer(_conX.loading.value)),
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
        child: Container(
          padding: EdgeInsets.all(akContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: akContentPadding * 0.5),
              Row(
                children: [
                  ArrowBack(onTap: () async {
                    if (await _conX.handleBack()) Get.back();
                  }),
                ],
              ),
              SizedBox(height: 10.0),
              AkText(
                'Recuperar contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: akFontSize + 8.0,
                  color: akTitleColor,
                ),
              ),
              SizedBox(height: 10.0),
              AkText(
                'Se enviará un correo con el enlace para recuperar tu contraseña.',
                style: TextStyle(
                  fontSize: akFontSize,
                ),
              ),
              SizedBox(height: 30.0),
              AkText(
                'Ingresa tu correo electrónico:',
                style: TextStyle(
                  fontSize: akFontSize,
                ),
              ),
              SizedBox(height: 10.0),
              _buildInput(
                controller: _conX.emailCtlr,
                maxLength: 150,
                hint: 'micorreo@correo.com',
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                enabledClean: true,
                icon: Icons.mail_outline_rounded,
              ),
              SizedBox(height: 10.0),
              Expanded(child: SizedBox()), // No quitar
              AkButton(
                enableMargin: false,
                onPressed: _conX.onSendButtonTap,
                text: 'Enviar correo',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    TextEditingController? controller,
    IconData? icon,
    bool onlyRead = false,
    void Function()? onTap,
    bool enabledClean = true,
    int maxLength = 30,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
    void Function()? onFieldCleaned,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.words,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: AkInput(
        maxLength: maxLength,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        // size: AkInputSize.small,
        textCapitalization: textCapitalization,
        type: AkInputType.legend,
        filledColor: Color(0xFFE7EAF3),
        filledFocusedColor: Color(0xFFE7EAF3),
        enabledBorderColor: Color(0xFFDADDE3),
        hintText: hint,
        inputFormatters: inputFormatters,
        labelColor: akTitleColor.withOpacity(.36),
        prefixIcon: icon != null ? Icon(icon) : null,
        readOnly: onlyRead,
        showCursor: !onlyRead,
        enableClean: enabledClean,
        onFieldCleaned: onFieldCleaned,
        onTap: () {
          onTap?.call();
        },
      ),
    );
  }
}
