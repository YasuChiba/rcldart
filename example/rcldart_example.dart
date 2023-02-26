import 'dart:io';

import 'package:rcldart/rcldart.dart';
import 'package:rcldart/src/logger.dart';

void main() {
  RclDart().init();
  var node = RclDart().createNode("samplenodefromdart", "");

  var pub = node.createPublisher();
  pub.publish();
  while (true) {
    sleep(Duration(seconds: 3));
    pub.publish();
  }
}
