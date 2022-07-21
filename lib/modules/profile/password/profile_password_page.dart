import 'package:app_quick_reports/modules/profile/password/profile_password_controller.dart';
import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfilePasswordPage extends StatelessWidget {
  final _conX = Get.put(ProfilePasswordController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _conX.handleBack,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: _buildContent(constraints),
              physics: BouncingScrollPhysics(),
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: akContentPadding),
          child: Column(
            children: [
              SizedBox(height: akContentPadding * 0.5),
              Row(
                children: [
                  ArrowBack(onTap: () async {
                    if (await _conX.handleBack()) Get.back();
                  }),
                ],
              ),
              Content(
                child: Column(
                  children: [
                    _buildTitle(),
                    _buildForm(),
                  ],
                ),
              ),
              Expanded(child: SizedBox()), // No quitar
              Content(child: _buildMainButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          AkText(
            'Seguridad',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: akFontSize + 8.0,
              color: akTitleColor,
            ),
          ),
          SizedBox(height: 7.0),
          AkText('Completa el formulario para actualizar la contraseña.'),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      child: Form(
        key: _conX.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Contraseña actual'),
            _buildInput(
              controller: _conX.oldPassword,
              hint: 'Tu actual contraseña',
            ),
            _buildLabel('Nueva contraseña'),
            _buildInput(
              controller: _conX.newPassword,
              hint: 'Escribe una nueva contraseña',
            ),
            _buildLabel('Confirmar contraseña'),
            _buildInput(
              controller: _conX.repeatNewPassword,
              hint: 'Vuelve a escribir la nueva contraseña',
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    Widget spin = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinLoadingIcon(
          color: akWhiteColor,
          size: akFontSize + 3.0,
          strokeWidth: 3.0,
        )
      ],
    );

    return Obx(() => AkButton(
          fluid: true,
          enableMargin: false,
          onPressed: _conX.onSubmitTap,
          text: 'GUARDAR',
          variant: AkButtonVariant.accent,
          child: _conX.loading.value ? spin : null,
        ));
  }

  Widget _buildLabel(String txt) {
    return AkText(
      txt,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: akTitleColor,
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
    int maxLength = 20,
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
        textCapitalization: textCapitalization,
        type: AkInputType.legend,
        filledColor: Color(0xFFE7EAF3),
        filledFocusedColor: Color(0xFFE7EAF3),
        enabledBorderColor: Color(0xFFDADDE3),
        hintText: hint,
        inputFormatters: inputFormatters,
        labelColor: akTitleColor.withOpacity(.36),
        suffixIcon: icon != null ? Icon(icon) : null,
        readOnly: onlyRead,
        showCursor: !onlyRead,
        enableClean: enabledClean,
        obscureText: true,
        onFieldCleaned: onFieldCleaned,
        validator: _conX.validateField,
        onTap: () {
          onTap?.call();
        },
      ),
    );
  }
}
