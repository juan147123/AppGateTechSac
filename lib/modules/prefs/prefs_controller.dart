import 'dart:convert';

import 'package:app_quick_reports/constants/constants.dart';
import 'package:app_quick_reports/data/models/user_credentials.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PrefsController extends GetxController {
  final box = GetStorage();

  // Obtiene las credenciales al Storage desde el String en memoria
  UserCredentials? get userCredentialStored {
    try {
      final credentialsEncoded = box.read(K_BOX_USERSESSION_KEY);
      if (credentialsEncoded is String) {
        final credentialsDecoded = jsonDecode(credentialsEncoded);
        final credentialsInstance =
            UserCredentials.fromJson(credentialsDecoded);
        return credentialsInstance;
      } else {
        Helpers.logger.wtf('No hay usuario..');
        return null;
      }
    } catch (e) {
      Helpers.logger.e(e.toString());
      Helpers.logger.e('No se pudo decodificar el usuario o no hay usuario');
      deleteAll();
      return null;
    }
  }

  Future<void> setUserCredentialStored(UserCredentials? credentials) async {
    if (credentials != null) {
      final credentialsJsonString = jsonEncode(credentials.toJson());
      await box.write(K_BOX_USERSESSION_KEY, credentialsJsonString);
    } else {
      await box.remove(K_BOX_USERSESSION_KEY);
    }
  }

  Future<void> deleteAll() async {
    await box.erase();
  }
}
