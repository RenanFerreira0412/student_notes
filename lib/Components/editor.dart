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

class EditorAuthField extends StatefulWidget {
  final TextEditingController controlador;
  final TextEditingController? controllerSenha;
  final String rotulo;
  final String dica;
  final String errorText;
  final Icon icon;
  final bool verSenha;
  final bool confirmPasswordField;

  const EditorAuthField(
      {Key? key,
      required this.controlador,
      required this.rotulo,
      required this.dica,
      required this.errorText,
      required this.icon,
      required this.verSenha,
      required this.confirmPasswordField,
      this.controllerSenha})
      : super(key: key);

  @override
  State<EditorAuthField> createState() => _EditorAuthFieldState();
}

class _EditorAuthFieldState extends State<EditorAuthField> {
  late bool _habilitaVerSenha;
  late bool _verSenha;

  @override
  void initState() {
    super.initState();
    _habilitaVerSenha = widget.verSenha;
    _verSenha = widget.verSenha;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, bottom: 13),
      child: TextFormField(
          obscureText: _verSenha,
          controller: widget.controlador,
          style: const TextStyle(
            fontSize: 18.0,
          ),
          decoration: InputDecoration(
              labelText: widget.rotulo,
              hintText: widget.dica,
              prefixIcon: widget.icon,
              suffixIcon: _habilitaVerSenha
                  ? (_verSenha
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              //Quando o usuário clicar nesse ícone, ele mudará para falso
                              debugPrint('Você está vendo a sua senha');
                              _verSenha = false;
                            });
                          },
                          icon: const Icon(Icons.lock_rounded))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              //Quando o usuário clicar nesse ícone, ele mudará para verdadeiro
                              debugPrint('Você não está vendo a sua senha');
                              _verSenha = true;
                            });
                          },
                          icon: const Icon(Icons.lock_open_rounded)))
                  : null,
              border: const OutlineInputBorder()),
          validator: widget.confirmPasswordField
              ? (value) {
                  if (value == null || value != widget.controllerSenha!.text) {
                    return widget.errorText;
                  }
                  return null;
                }
              : (value) {
                  if (value == null || value.isEmpty) {
                    return widget.errorText;
                  }
                  return null;
                }),
    );
  }
}
