part of 'ak_ui.dart';

// NOTA:
// Para visualizar todos los cambios debe hacer un Hot Restart
// de lo contrario, algunos colores, medidas y estilos
// NO se actualizarán correctamente.

double akRadiusDrawerContainer = akRadiusGeneral;
double akRadiusSnackbar = akRadiusGeneral;
double akMapPaddingBase = 12.0;

void customizeAkStyle() {
  akPrimaryColor = Color(0xFF1d1d27);
  akAccentColor = Color(0xFF12C4AB);

  akSecondaryColor = akPrimaryColor.withOpacity(.8);

  akSuccessColor = Color(0xFF61BF09);
  akErrorColor = Color(0xFFF94844);
  akInfoColor = Color(0xFF36B4E7);
  akWarningColor = Color(0xFFFEBC33);

  akDefaultFontFamily = 'Rubik';

  akFontSize = 15.0;

  akRadiusGeneral = 8.0;
  if (Get.width >= 360.0) {
    akContentPadding = 20.0;
  } else {
    akContentPadding = 20.0;
  }

  akScaffoldBackgroundColor = Color(0xFFf5f4f9);

  akTitleColor = Color(0xFF0c2043);
  akTextColor = akTitleColor.withOpacity(.60);

  // Buttons
  akBtnBorderRadius = 30.0;

  akAppbarBackgroundColor = akAccentColor;
  akAppbarTextColor = akTextColor;
  akAppbarElevation = 0.0;

  // Changing default app flutter theme
  dfAppThemeLight = dfAppThemeLight.copyWith(
    appBarTheme: dfAppBarLight.copyWith(
      titleTextStyle: dfAppBarTitleStyle.copyWith(color: akPrimaryColor),
      iconTheme: dfAppBarIconTheme.copyWith(color: akPrimaryColor),
    ),
  );
}
