import 'package:flutter/material.dart';

// Global navigator key to control navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Function to show the error dialog globally
void showErrorDialog(String errorMessage) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                navigatorKey.currentState?.pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ),
  );
}
