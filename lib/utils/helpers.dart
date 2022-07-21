part of 'utils.dart';

enum SnackBarVariant { primary, success, error, info, warning }

class Helpers {
  static Future<void> sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static bool keyboardIsVisible() {
    final compare = Get.mediaQuery.viewInsets.bottom == 0.0;
    return !(compare);
  }

  static final logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static void showError(String message, {String? devError}) async {
    Helpers.logger.e(devError ?? message);
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => AppSnackbar().error(message: message));
  }

  static void snackbar(
      {String? title,
      String message = '',
      SnackBarVariant variant = SnackBarVariant.info,
      bool hideIcon = false,
      SnackPosition snackPosition = SnackPosition.BOTTOM,
      bool snackMini = false}) {
    Color color = akPrimaryColor;
    IconData icon = Icons.android;
    String titleMsg = '';
    switch (variant) {
      case SnackBarVariant.primary:
        color = akPrimaryColor;
        icon = Icons.check;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.success:
        color = akSuccessColor;
        icon = Icons.check;
        titleMsg = title ?? 'Exitoso';
        break;
      case SnackBarVariant.error:
        color = akErrorColor;
        icon = Icons.error;
        titleMsg = title ?? 'Hubo un error';
        break;
      case SnackBarVariant.info:
        color = akInfoColor;
        icon = Icons.info;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.warning:
        color = akWarningColor;
        icon = Icons.warning;
        titleMsg = title ?? 'Advertencia';
        break;
    }

    if (snackMini) {
      Get.snackbar(
        '',
        '',
        margin: EdgeInsets.all(0),
        snackPosition: snackPosition,
        messageText: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: color),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: AkText(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        titleText: SizedBox(),
        backgroundColor: Colors.transparent,
      );
      return;
    }

    if (hideIcon) {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: akRadiusSnackbar,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
      );
    } else {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
        borderRadius: akRadiusSnackbar,
        icon: Icon(icon, color: Colors.white),
      );
    }
  }

  static Future<bool> confirmCloseAppDialog() async {
    return await Get.dialog(
        AlertDialog(
          content: Container(
            child: AkText(
              '¿Desea cerrar la aplicación?',
              style: TextStyle(fontSize: akFontSize + 2.0),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkButton(
                      text: 'Sí',
                      contentPadding: EdgeInsets.all(8.0),
                      type: AkButtonType.outline,
                      onPressed: () {
                        Get.back(result: true);
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkButton(
                      text: 'No',
                      contentPadding: EdgeInsets.all(8.0),
                      onPressed: () {
                        Get.back(result: false);
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            )
          ],
        ),
        barrierDismissible: false);
  }

  static Future<bool?> confirmDialog(String message) async {
    return await Get.dialog(
        AlertDialog(
          content: Text(message),
          actions: [
            MaterialButton(
              child: Text('SI'),
              onPressed: () {
                Get.back(result: true);
              },
            ),
            MaterialButton(
              child: Text('NO'),
              onPressed: () {
                Get.back(result: false);
              },
            )
          ],
        ),
        barrierDismissible: false);
  }

  static String capitalizeFirstLetter(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : s;

  static String getObfuscateEmail(String completeEmail) {
    List<String> arrs = completeEmail.split('@');
    if (arrs.length == 2) {
      String firstPart = arrs[0];
      String obfuscateFp = '';
      int fpLength = firstPart.length;
      if (fpLength >= 5) {
        int middleCount = fpLength - 4;
        obfuscateFp = '${firstPart[0]}${firstPart[1]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp +=
            '${firstPart[fpLength - 2]}${firstPart[fpLength - 1]}@${arrs[1]}';
      } else if (fpLength >= 3) {
        int middleCount = fpLength - 2;
        obfuscateFp = '${firstPart[0]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp += '${firstPart[fpLength - 1]}@${arrs[1]}';
      } else {
        obfuscateFp = completeEmail;
      }
      return obfuscateFp;
    } else {
      return completeEmail;
    }
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Color hexToColor(String code, double opacity) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000)
        .withOpacity(opacity);
  }

  static String extractDate(
    DateTime dateTime, {
    String separator = '/',
  }) {
    final dateFormat =
        formatDate(dateTime, [dd, '$separator', mm, '$separator', yyyy]);
    return dateFormat;
  }

  static String extractTime(
    DateTime dateTime, {
    bool seconds = false,
    bool upperCase = true,
  }) {
    var estructure = [hh, ':', nn];
    if (seconds) {
      estructure.addAll([':', ss]);
    }
    estructure.addAll([' ', am]);

    var timeFormat = formatDate(dateTime, estructure);
    timeFormat =
        upperCase ? timeFormat.toUpperCase() : timeFormat.toLowerCase();
    return timeFormat;
  }

  static String replaceBgColorJs(Color color) {
    final hexValue = color.value.toRadixString(16);
    final hexColor = '#${hexValue.substring(2, hexValue.length)}';

    return "const cssOverrideStyle = document.createElement('style');"
        "cssOverrideStyle.textContent = `body {background-color: $hexColor;}`;"
        "document.head.append(cssOverrideStyle);";
  }

  static String formatBytes(int numBytes) {
    String sizeFile = "";
    double numKb;
    double numMb;
    if (numBytes > 1000) {
      numKb = numBytes / 1000;
      if (numKb > 1000) {
        numMb = numKb / 1000;

        sizeFile = numMb.toStringAsFixed(2) + " mb";
      } else {
        sizeFile = numKb.toStringAsFixed(2) + " kb";
      }
    } else {
      sizeFile = numBytes.toStringAsFixed(2) + " bytes";
    }

    return sizeFile;
  }

  static bool checkIfDataBase64IsImage(String dataBase64) {
    return dataBase64.contains('image/jpeg') ||
        dataBase64.contains('image/png');
  }

  static Uint8List getDecodedBytes(String encodedString) {
    String cleanBase64 = encodedString;
    if (encodedString.contains(';base64,')) {
      cleanBase64 = encodedString.split(';base64,')[1];
    }
    return base64Decode(cleanBase64);
  }
}
