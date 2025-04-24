import 'package:flutter/material.dart';

import '../../../enums/drawer_sections.dart';
import '../../screen_arguments/ScreenArgumentsUser.dart';
import 'menu_item_tile.dart';

class MeuDrawerList extends StatelessWidget {
  final DrawerSections currentPage;
  final ValueChanged<DrawerSections> onSectionSelected;
  final ScreenArgumentsUser? usuario;

  const MeuDrawerList({
    Key? key,
    required this.currentPage,
    required this.onSectionSelected,
    required this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          MenuItemTile(
            id: 0,
            title: "DashBoard",
            icon: Icons.dashboard_outlined,
            selected: currentPage == DrawerSections.dashboard,
            usuario: usuario,
            onSectionSelected: onSectionSelected,
          ),
          MenuItemTile(
            id: 1,
            title: "Clientes",
            icon: Icons.people,
            selected: currentPage == DrawerSections.cliente,
            usuario: usuario,
            onSectionSelected: onSectionSelected,
          ),
          MenuItemTile(
            id: 2,
            title: "Perfil",
            icon: Icons.person,
            selected: currentPage == DrawerSections.perfil,
            usuario: usuario,
            onSectionSelected: onSectionSelected,
          ),
          MenuItemTile(
            id: 3,
            title: "QrCode",
            icon: Icons.qr_code,
            selected: currentPage == DrawerSections.qrcode,
            usuario: usuario,
            onSectionSelected: onSectionSelected,
          ),
          const Divider(),
          MenuItemTile(
            id: 4,
            title: "Sair",
            icon: Icons.exit_to_app,
            selected: currentPage == DrawerSections.exit,
            usuario: usuario,
            onSectionSelected: onSectionSelected,
          ),
        ],
      ),
    );
  }
}
