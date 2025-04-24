
import 'package:flutter/material.dart';


class CardCliente extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap; // Callback de clique
  final String photoname;

  const CardCliente({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    required this.photoname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap, // Ação de clique
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            photoname,
          ),
        ),
        trailing: Icon(icon),
      ),
    );
  }
}