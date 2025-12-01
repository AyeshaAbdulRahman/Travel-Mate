import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

Future<T?> pushNamed<T extends Object?>(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.of(context).pushNamed<T>(
    routeName,
    arguments: arguments,
  );
}
