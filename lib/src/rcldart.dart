import 'package:rcldart/src/initOptions.dart';
import 'package:rcldart/src/logger.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:rcldart/src/nodeOptions.dart';
import 'package:rcldart/src/util/dylibLoader.dart';

import 'context.dart';
import 'gen/rcldart_rcl_bindings_generated.dart';
import 'node.dart';

final RclDartRclBindings rclBindings = RclDartRclBindings(dylibLoader("rcl"));

// singleton class
class RclDart {
  static final RclDart _instance = RclDart._internal();

  Context? _context;

  factory RclDart() {
    return _instance;
  }

  RclDart._internal() {
    initLogger();
  }

  /// initialize rcl
  init() {
    if (_context != null) {
      return;
    }

    rclDartLogger.info("start initializing rcl");

    var initOptions = InitOptions();

    _context = Context();
    var initResult = rclBindings.rcl_init(
        0, nullptr, initOptions.nativeInitOptions, getContext().nativeContext);
    if (initResult != RCL_RET_OK) {
      throw Exception("unable to init rcl");
    }
    rclDartLogger.info("successfully initialize rcl");
  }

  Node createNode(String nodeName, String nameSpace) {
    var node = Node("temporaryFlutterNode", "", getContext());
    rclDartLogger.info(
        "successfully created node. nodeName: $nodeName, nameSpace: $nameSpace");
    return node;
  }

  Context getContext() {
    if (_context == null) {
      throw Exception("initialize rcldart before doing something!");
    }
    return _context!;
  }
}
