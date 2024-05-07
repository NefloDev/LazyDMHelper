import 'package:flutter/material.dart';

class DataCreationTextForm extends StatelessWidget{

  final TextEditingController controller;
  final String labelText;
  final String? initial;

  const DataCreationTextForm({super.key, required this.controller, required this.labelText, this.initial});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: TextFormField(
        initialValue: initial,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText
        ),
      ),
    );
  }

}