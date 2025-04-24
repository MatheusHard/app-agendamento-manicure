import 'package:flutter/material.dart';
import '../../../enums/drawer_sections.dart';
import '../../cliente_page.dart';
import '../../home_page.dart';
import '../../pix_page.dart';
import '../../screen_arguments/ScreenArgumentsUser.dart';

class MenuItemTile extends StatelessWidget {
  final int id;
  final String title;
  final IconData icon;
  final bool selected;
  final ScreenArgumentsUser? usuario;
  final ValueChanged<DrawerSections> onSectionSelected;

  const MenuItemTile({
    Key? key,
    required this.id,
    required this.title,
    required this.icon,
    required this.selected,
    required this.usuario,
    required this.onSectionSelected,
  }) : super(key: key);

  void _handleTap(BuildContext context) {
    Navigator.pop(context);

    switch (id) {
      case 0:
        onSectionSelected(DrawerSections.dashboard);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(usuario)),
        );
        break;
      case 1:
        onSectionSelected(DrawerSections.cliente);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientePage(usuario)),
        );
        break;
      case 2:
        onSectionSelected(DrawerSections.perfil);
        // Futuro: PerfilPage(usuario)
        break;
      case 3:
        onSectionSelected(DrawerSections.qrcode);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PixPage()),
        );
        break;
      case 4:
        onSectionSelected(DrawerSections.exit);
        // Ex: mostrar diálogo de confirmação
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(child: Icon(icon, size: 20, color: Colors.black)),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
