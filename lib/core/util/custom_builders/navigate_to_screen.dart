import 'package:flutter/material.dart';

Future<T?> navigateTo<T>(BuildContext context, Widget widget) =>
    Navigator.push<T>(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(BuildContext context, Widget widget) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
