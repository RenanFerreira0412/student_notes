import 'package:flutter/material.dart';

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const ListTileOptions(
      {Key? key,
        required this.icone,
        required this.title,
        required this.onTap,
        required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icone, color: color),
    title: Text(title),
    onTap: onTap
  );
}
