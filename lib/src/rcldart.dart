import 'package:rcldart/src/logger.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'package:ffi/ffi.dart';

import 'gen/rcldart_rcl_bindings_generated.dart';
import 'node.dart';

const String _libName = 'rcl';
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final RclDartRclBindings _bindings = RclDartRclBindings(_dylib);

// singleton class
class RclDart {
  static final RclDart _instance = RclDart._internal();

  Pointer<rcl_context_s>? context;

  factory RclDart() {
    return _instance;
  }

  RclDart._internal() {
    initLogger();
  }

  /// initialize rcl
  init() {
    if (context != null) {
      return;
    }

    rclDartLogger.info("start initializing rcl");

    var initOptions = malloc<rcl_init_options_t>()
      ..ref = _bindings.rcl_get_zero_initialized_init_options();
    var allocator = _bindings.rcutils_get_default_allocator();

    var initOptionsResult =
        _bindings.rcl_init_options_init(initOptions, allocator);
    if (initOptionsResult != RCL_RET_OK) {
      throw Exception("unable to initialize init_options");
    }

    context = malloc<rcl_context_s>()
      ..ref = _bindings.rcl_get_zero_initialized_context();
    var initResult = _bindings.rcl_init(0, nullptr, initOptions, context!);
    if (initResult != RCL_RET_OK) {
      throw Exception("unable to init rcl");
    }
    rclDartLogger.info("successfully initialize rcl");

    //malloc.free(initOptions);
  }

  Node createNode(String nodeName, String nameSpace) {
    var node = malloc<rcl_node_s>()
      ..ref = _bindings.rcl_get_zero_initialized_node();

    var nodeOptions = malloc<rcl_node_options_s>()
      ..ref = _bindings.rcl_node_get_default_options();

    final _nodeName = nodeName.toNativeUtf8().cast<Char>();
    final _namespace = nameSpace.toNativeUtf8().cast<Char>();

    print("START!!!6");
    var nodeInitResult = _bindings.rcl_node_init(
        node, _nodeName, _namespace, context!, nodeOptions);

    if (nodeInitResult != RCL_RET_OK) {
      throw Exception("unable to create node");
    }
    rclDartLogger.info(
        "successfully created node. nodeName: $nodeName, nameSpace: $nameSpace");
    return Node(node);
  }
}
