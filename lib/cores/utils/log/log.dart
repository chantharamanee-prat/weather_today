import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void initializeLog() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.SEVERE;
  }

  Logger.root.onRecord.listen((record) {
    var msg = '${record.level.name}: ${record.time}: ${record.message}';

    if (record.stackTrace != null) {
      msg += "\n${record.stackTrace?.toString()}";
    }

    debugPrint(msg, wrapWidth: 1024);
  });
}
