import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/card_cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:flutter/material.dart';

import '../api/clienteapi.dart';
import '../enums/drawer_sections.dart';
import 'home_page.dart';

class ClientePage extends StatefulWidget {
  final ScreenArgumentsUser? userLogado;

  const ClientePage(this.userLogado, {super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {

  ScreenArgumentsUser? userLogado;
  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  var currentPage = DrawerSections.cliente;
  bool isLoading = true;
  List<Cliente> listaClientes = [];

  @override
  void initState() {
    userLogado = widget.userLogado;
    carregarClientes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: key,
      ///AppBar
      appBar: _appBar(width, userLogado),
      ///Drawer
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
      ///Body
      body: Container(
          padding: EdgeInsets.all(8),
        child: isLoading ? Center(child: CircularProgressIndicator()): ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: listaClientes.length,
          itemBuilder: (BuildContext context, int index){
            final Cliente cliente = listaClientes[index];

            return CardCliente(
              onTap: (){
                print("clicou cliente");
              },
                title: cliente.name ?? "",
                subtitle: cliente.telephone ?? "",
                icon: Icons.phone_forwarded);
          },
        ),
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
                  Expanded(child: Text('''Olá ${usuarioLogado?.data.user.username}''' , style: AppTextStyles.titleAppBarUsuario(25, context),)),
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

  Future<void> carregarClientes() async {
    try {
      final dados = await ClienteApi(context).getList(1, 1);
      setState(() {
        listaClientes = dados;
        isLoading = false;
      });
    } catch (e) {
      // Lida com erro, se quiser
      setState(() {
        isLoading = false;
      });
    }
  }
  ///MenuDrawer:
  _meuDrawerList(ScreenArgumentsUser? usuario){
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(0, "DashBoard", Icons.dashboard_outlined, currentPage == DrawerSections.dashboard ? true : false, usuario),
          menuItem(1, "Clientes", Icons.people, currentPage == DrawerSections.cliente ? true : false, usuario),
          menuItem(2, "Perfil", Icons.person, currentPage == DrawerSections.perfil ? true : false, usuario),
          const Divider(),
          menuItem(3, "Sair", Icons.exit_to_app, currentPage == DrawerSections.exit ? true : false, usuario),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(usuario)));
                  break;
                case 1:
                  currentPage = DrawerSections.cliente;
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientePage(usuario)));
                  break;
                case 2:
                  currentPage = DrawerSections.perfil;
                  /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilPage(usuario)));*/
                  break;
                case 3:
                  currentPage = DrawerSections.exit;
                  //_dialogSair();
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
