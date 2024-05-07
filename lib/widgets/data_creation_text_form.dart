import 'package:flutter/material.dart';

class DataCreationTextForm extends StatelessWidget{

  final TextEditingController controller;
  final String labelText;
  final bool isNumeric;

  const DataCreationTextForm({super.key, required this.controller, required this.labelText, this.isNumeric = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      ),
    );
  }

}