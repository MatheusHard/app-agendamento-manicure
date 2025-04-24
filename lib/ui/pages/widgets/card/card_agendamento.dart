
import 'package:flutter/material.dart';

import '../../../api/configurations/dio/configs.dart';
import '../../utils/core/app_images.dart';
import '../../utils/metods/utils.dart';

class CardAgendamento extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? urlFotoCliente;
  final IconData icon;
  final VoidCallback? onTap; // Callback de clique
  final Configs _customDio = Configs();

  CardAgendamento({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.urlFotoCliente,
    required this.icon,
    this.onTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap, // Ação de clique
        title: Text(title),
        subtitle: Text(Utils.formatarData(subtitle, false)),
        leading: CircleAvatar(
          backgroundImage:  urlFotoCliente != null ?
                    NetworkImage('${_customDio.dio.options.baseUrl}/${Utils.URL_UPLOAD}$urlFotoCliente') :
                    AssetImage(AppImages.semfoto)
        ),
        trailing: Icon(icon),
      ),
    );
  }
}