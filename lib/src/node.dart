import 'dart:ffi';

import 'gen/rcldart_rcl_bindings_generated.dart';

class Node {
  final Pointer<rcl_node_s> node;
  Node(this.node);
}
