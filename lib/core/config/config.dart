import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../local/hive_constants.dart';

Box authBox = Hive.box(HiveConstantBox.authBox);
showLoading({double? size, Color? color}) {
  return Center(
    child: SizedBox(
      height: size ?? 50,
      width: size ?? 50,
      child: Center(
        child: const CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.teal,
        ),
      ),
    ),
  );
}
