import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:rcldart/src/rcldart.dart';

import 'gen/rcldart_rcl_bindings_generated.dart';
import 'msgs/std_msgs_string.dart';

class Publisher {
  final Pointer<rcl_publisher_s> nativePublisher;

  late StdMsgsString msg;

  Publisher(this.nativePublisher) {
    msg = StdMsgsString("valuevalu!!");
  }

  void publish() {
    rclBindings.rcl_publish(nativePublisher, msg.strMsg.cast(), nullptr);
  }
}
