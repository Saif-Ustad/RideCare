import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Exit App'),
                ],
              ),
              content: const Text(
                'Are you sure you want to close the app?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check),
                  label: const Text('Yes, Exit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
      ) ??
      false;
}
