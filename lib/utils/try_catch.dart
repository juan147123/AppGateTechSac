part of 'utils.dart';

// Version 1.0.0 - SDK 2.10.4
FutureOr<bool> tryCatch({
  GetxController? self,
  required FutureOr<void> Function() code,
  FutureOr<bool> Function(dynamic error)? onBeforeApiLoop,
  FutureOr<bool> Function(dynamic error)? onError,
  FutureOr<void> Function()? onCancelRetry,
  FutureOr<void> Function()? onFinally,
  Duration delayApiRetries = const Duration(milliseconds: 200),
  int apiAttempts = 1,
}) async {
  // Validación
  if (apiAttempts <= 0) return false;

  // Local variables
  bool retry = false;
  bool finishOk = false;
  bool cancelSelected = false;
  do {
    retry = false;
    finishOk = false;

    int count = 0;
    bool hasError = false;
    dynamic error;
    dynamic stackTrace;

    String? errorMsg;
    do {
      try {
        await code();
        count = apiAttempts;
      } on ApiException catch (e, st) {
        errorMsg = e.message;
        Helpers.logger.e(errorMsg);

        final continueLoop = (await onBeforeApiLoop?.call(e) ?? true);
        if (continueLoop) {
          await Future.delayed(delayApiRetries, () => count++);
          // print('count $count');
          if (count == apiAttempts) {
            hasError = true;
            error = e;
            stackTrace = st;
          }
        } else {
          count = apiAttempts;
          hasError = true;
          error = e;
          stackTrace = st;
        }
      } on BusinessException catch (e, st) {
        errorMsg = e.message;
        Helpers.logger.e(errorMsg);

        count = apiAttempts;
        hasError = true;
        error = e;
        stackTrace = st;
      } catch (e, st) {
        errorMsg = 'Ocurrió un error inesperado.';
        Helpers.logger.e(errorMsg);

        count = apiAttempts;
        hasError = true;
        error = e;
        stackTrace = st;
      }
    } while (count != apiAttempts);

    if (self != null && self.isClosed) return finishOk;

    if (hasError) {
      final showErrorPage = (await onError?.call(error) ?? true);

      /* print(error);
      print(stackTrace);
      await Sentry.captureException(error, stackTrace: stackTrace); */
      // final d = error;

      if (showErrorPage) {
        final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
            arguments: MiscErrorArguments(content: errorMsg));
        if (ers == MiscErrorResult.retry) {
          await Helpers.sleep(1500);
          retry = true;
        } else {
          retry = false;
          cancelSelected = true;
        }
      }
    } else {
      finishOk = true;
    }
  } while (retry);

  if (cancelSelected) {
    await onCancelRetry?.call();
  }

  await onFinally?.call();
  // Llega a este punto en el caso que no se muestre Misc Error
  return finishOk;
}
