
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_images.dart';
import 'package:flutter/material.dart';

import '../../../api/configurations/dio/configs.dart';
import '../../utils/metods/utils.dart';


class CardCliente extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap; // Callback de clique
  final String? photoname;
  final Configs _customDio = Configs();

  CardCliente({
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
          backgroundImage: photoname != null ?
                              NetworkImage('${_customDio.dio.options.baseUrl}/${Utils.URL_UPLOAD}$photoname') :
                              AssetImage(AppImages.semfoto),
        ),
        trailing: Icon(icon),
      ),
    );
  }
}