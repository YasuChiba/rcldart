import 'package:logging/logging.dart';

import 'logger.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
  void tmp() {
    initLogger();
    rclDartLogger.fine("aaa");
  }
}
