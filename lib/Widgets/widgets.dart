import 'package:flutter/material.dart';

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;

  const ListTileOptions(
      {Key? key,
        required this.icone,
        required this.title,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icone),
    title: Text(title),
    onTap: onTap
  );
}
