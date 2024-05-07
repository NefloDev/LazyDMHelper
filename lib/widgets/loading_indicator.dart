import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget{
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 200,
        height: 200,
        child: CircularProgressIndicator(
          strokeWidth: 16,
        )
    );
  }

}