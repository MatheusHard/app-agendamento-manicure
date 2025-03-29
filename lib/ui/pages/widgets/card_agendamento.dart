
import 'package:flutter/material.dart';

class CardAgendamento extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap; // Callback de clique

  const CardAgendamento({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap, // Ação de clique
        title: Text(title),
        subtitle: Text(subtitle),
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
          ),
        ),
        trailing: Icon(icon),
      ),
    );
  }
}