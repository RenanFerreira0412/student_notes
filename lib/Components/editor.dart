import 'package:flutter/material.dart';

class EditorTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int lines;
  final String labelText;
  final String dica;
  final bool validaCampo;
  final bool readOnly;
  final Icon fieldIcon;
  final VoidCallback? action;

  const EditorTextFormField(
      {Key? key,
      required this.controller,
      required this.maxLength,
      required this.lines,
      required this.labelText,
      required this.dica,
      required this.validaCampo,
      required this.readOnly,
      required this.fieldIcon,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, bottom: 13),
      child: TextFormField(
        onTap: action,
        controller: controller,
        maxLength: maxLength,
        maxLines: lines,
        readOnly: readOnly,
        style: const TextStyle(
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          icon: fieldIcon,
          hintText: dica,
          helperText: dica,
          border: const OutlineInputBorder(),
        ),
        validator: validaCampo
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo Obrigatório!';
                }
                return null;
              }
            : null,
      ),
    );
  }
}
