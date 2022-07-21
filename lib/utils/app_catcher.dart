part of 'utils.dart';

class AppCatcher {
  static void exec(Future<void> Function() exec) async {
    try {
      await exec.call();
    } catch (e) {
      print('Error AppCatcher');
    }

    print('ultimo');
  }
}
