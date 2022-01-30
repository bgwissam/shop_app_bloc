import 'package:flutter/material.dart';

class SnackBarWidget {
  BuildContext context;
  String content;
  void showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
