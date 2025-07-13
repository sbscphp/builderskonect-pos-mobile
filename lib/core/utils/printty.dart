import 'dart:developer';

import 'package:flutter/foundation.dart';

void printty(dynamic val, {String? logName}) {
  if (kDebugMode) {
    log("==== ${logName ?? "Logger"} ==== ${val.toString()} ");
  }
}
