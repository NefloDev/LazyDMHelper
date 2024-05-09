import 'package:flutter/material.dart';

class DataCreationTextForm extends StatelessWidget{

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isNumeric;
  final bool isDecimal;

  const DataCreationTextForm({super.key, required this.controller, required this.labelText, this.isNumeric = false, this.isDecimal = false, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Expanded(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
              hintText: hintText
          ),
          keyboardType: isNumeric || isDecimal ? TextInputType.numberWithOptions(decimal: isDecimal) : TextInputType.text,
        ),
      ),
    );
  }

}