import 'package:flutter/material.dart';
import '../../screen_arguments/ScreenArgumentsUser.dart';
import '../../utils/core/app_gradients.dart';
import '../../utils/core/app_text_styles.dart';

class CustomAppBarUsuario extends StatelessWidget implements PreferredSizeWidget {
  final double width;
  final ScreenArgumentsUser? usuarioLogado;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBarUsuario({
    Key? key,
    required this.width,
    required this.usuarioLogado,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 0.0,
      flexibleSpace: Container(
        height: width / 3.5,
        decoration: const BoxDecoration(
          gradient: AppGradients.petMacho,
          color: Colors.orange,
          boxShadow: [BoxShadow(blurRadius: 50.0)],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width / 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/images/usuario.png',
                height: MediaQuery.of(context).size.width / 10,
              ),
            ),
            const SizedBox(width: 25),
            SizedBox(
              height: (MediaQuery.of(context).size.width / 10) - 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Olá ${usuarioLogado?.data.user.username ?? ''}',
                      style: AppTextStyles.titleAppBarUsuario(25, context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
      ],
      leadingWidth: 220,
      leading: GestureDetector(
        onTap: () => scaffoldKey.currentState?.openDrawer(),
        child: Row(
          children: const [
            SizedBox(width: 10),
            Icon(Icons.menu, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
