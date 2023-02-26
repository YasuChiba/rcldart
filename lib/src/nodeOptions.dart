import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:rcldart/src/rcldart.dart';

import 'gen/rcldart_rcl_bindings_generated.dart';

class NodeOptions {
  final Pointer<rcl_node_options_t> nativeNodeOptions;

  NodeOptions._internal(this.nativeNodeOptions);

  factory NodeOptions() {
    var nodeOptions = malloc<rcl_node_options_s>()
      ..ref = rclBindings.rcl_node_get_default_options();
    return NodeOptions._internal(nodeOptions);
  }
}
