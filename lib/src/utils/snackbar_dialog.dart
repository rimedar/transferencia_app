import 'package:flutter/material.dart';

class SnackbarDialog {
  showSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[300],
        content: Text(
          mensaje,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        )));
  }
}
