import 'package:flutter/material.dart';

void showCustomScaffold(
  BuildContext context,
  Widget content,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
  ));
}
