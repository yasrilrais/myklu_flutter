import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  static void showTopSnackBar(
    BuildContext context,
    String message,
    Color color,
  ) =>
      showSimpleNotification(
        Text(message),
        background: color,
      );
}