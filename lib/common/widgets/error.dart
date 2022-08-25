 import 'package:blog/common/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String message;
  final VoidCallback callback;
  
  const Error({required this.message, required this.callback}) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          CustomButtom(title: 'Retry', onTap: callback)
        ],
      ),
    );
  }
}