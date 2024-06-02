import 'package:flutter/material.dart';

class ErrorMessageDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorMessageDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Oops!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        errorMessage,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: const Text('Fechar'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pop(); // Dismiss the dialog
        //     // You can add your retry logic here
        //   },
        //   child: const Text('Retry'),
        // ),
      ],
    );
  }
}
