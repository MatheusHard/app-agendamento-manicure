import 'package:app_agendamento_manicure/ui/enums/drawer_sections.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_colors.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:flutter/material.dart';

import '../models/Login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  final int _currentIndex = 0;
  var currentPage = DrawerSections.dashboard;
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ScreenArgumentsUser? userLogado = ModalRoute.of(context)?.settings.arguments as ScreenArgumentsUser?;

    return PopScope(
      canPop: false, // 👈 Impede o pop automático (se você quiser controlar manualmente)
      onPopInvoked: (didPop) async {
        if (!didPop) {
          _dialogSair();
        }
      },

      child: Scaffold(
        key: key,
        appBar: _appBar(width, userLogado),
        drawer:  Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///Header Drawer
                  MeuHeadDrawer(userLogado),
                  ///Body Drawer
                  _meuDrawerList(userLogado),
                ],
              ),
            )
        ),
     ),);

  }

  _dialogSair() async {

          return await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tem certeza?'),
              content: const Text('Você quer sair da tela?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () =>  Navigator.pushNamed(
                      context, '/login_page', arguments: null),
                  child: const Text('Sim'),
                ),
              ],
            ),
          );
    }

  ///App Bar
  _appBar(double width, ScreenArgumentsUser? usuarioLogado){

    return AppBar(
      toolbarHeight: 70,
      elevation: 0.0,
      flexibleSpace: Container(
        height: width / 3.5,
        decoration:  const BoxDecoration(
          gradient: AppGradients.petMacho,
          color: Colors.orange,
          boxShadow:  [
            BoxShadow(blurRadius: 50.0)
          ],

        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(width: width /10,),
            ///Foto:
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:  Image.asset(
                ///TODO Imagem do usuario
                'assets/images/usuario.png',
                height: MediaQuery.of(context).size.width / 10,
                //   width: MediaQuery.of(context).size.width / 10,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            ///Nome
            SizedBox(
              height: (MediaQuery.of(context).size.width / 10) - 17,
              // width: MediaQuery.of(context).size.width / 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('''Olá ${usuarioLogado?.data.user.username}''' , style: AppTextStyles.titleAppBarUsuario(25, context),),
                ],),
            )
          ],
        ),
        _sizedBox(10)
      ],
      leadingWidth: 220,
      leading: GestureDetector(
        onTap: () => key.currentState!.openDrawer(),
        ///key.currentState?.openEndDrawer();
        child:  Row(
          children:  [
            _sizedBox(10),
            const Icon(Icons.menu, color: Colors.white),
          ],
        ),
      ),
    );
  }
  _sizedBox(double width){
    return SizedBox(
      width: width,
    );
  }
  final tabs = [
    Container(),
    Padding( padding: const EdgeInsets.only( left:8.0, right: 8.0), child: Container(  color:
    AppColors.levelButtonTextFacil,)),
    Container()
  ];

  getBody() {
    return (_currentIndex == 0) ? HomePage() : Container();
  }
  ///MenuDrawer:
  _meuDrawerList(ScreenArgumentsUser? usuario){
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(0, "DashBoard", Icons.dashboard_outlined, currentPage == DrawerSections.dashboard ? true : false, usuario),
          menuItem(1, "Perfil", Icons.person, currentPage == DrawerSections.perfil ? true : false, usuario),
          const Divider(),
          menuItem(2, "Sair", Icons.exit_to_app, currentPage == DrawerSections.exit ? true : false, usuario),
        ],
      ),
    );
  }
  ///Menu Item:
  menuItem(int id, String title, IconData icon, bool selected, ScreenArgumentsUser? usuario){
    return Material(
        color: selected ? Colors.grey[300]: Colors.transparent,
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
            setState(() {
              switch(id){
                case 0:
                  currentPage = DrawerSections.dashboard;
                  break;
                case 1:
                  currentPage = DrawerSections.perfil;
                 /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilPage(usuario)));*/
                  break;
                case 2:
                  currentPage = DrawerSections.exit;
                  _dialogSair();
                  break;
              }

            });
          },
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children:  [
                  Expanded(child: Icon(icon, size: 20, color: Colors.black,),),
                  Expanded(flex: 3, child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16),))
                ],
              )),

        )
    );
  }
}
