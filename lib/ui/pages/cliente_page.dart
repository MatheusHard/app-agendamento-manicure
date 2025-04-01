import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_colors.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/card_cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var currentPage = DrawerSections.cliente;
  bool isLoading = true;
  List<Cliente> listaClientes = [];

  ///DAdos Cliente
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();

  late FocusNode _myFocusNodeName;
  late FocusNode _myFocusNodePhone;
  late FocusNode _myFocusNodeEmail;

  // Máscara para telefone brasileiro com DDD
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Valor puro (sem máscara)
  String _telefoneSemMascara = '';

  @override
  void initState() {
    userLogado = widget.userLogado;
    carregarClientes();
    _initFocusNode();
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
          itemBuilder: (BuildContext context, int index) {
            final Cliente cliente = listaClientes[index];

            return Dismissible(
              key: Key(cliente.id.toString()), // chave única, geralmente o ID do item
              direction: DismissDirection.startToEnd, // arrasta da direita para a esquerda
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                // opcional: exibir um diálogo de confirmação
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('Deseja realmente remover este cliente?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Remover')),
                    ],
                  ),
                );
              },
              onDismissed: (direction) async{
                // remove o cliente da lista
                setState(() {
                  listaClientes.removeAt(index);
                });
                ///Atualizar o Cliente pra Deletado:
                cliente.deletado = true;
                await _atualizarCliente(cliente, userLogado?.data.user.id, context);

              },
              child: CardCliente(
                onTap: () async {
                  _popularClienteEditar(cliente);
                  await _showDialogSaveCliente(context, userLogado!, true, cliente);
                },
                title: cliente.name ?? "",
                subtitle: cliente.telephone ?? "",
                icon: Icons.phone_forwarded,
              ),
            );
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _clearControllers();
            await _showDialogSaveCliente(context, userLogado!, false, null);
            carregarClientes(); // <- atualiza lista após fechar o dialog
          },
        shape: const CircleBorder(),
        backgroundColor: Colors.green, // verde
        tooltip: 'Adicionar Cliente',
          child: const Icon(Icons.add, color: Colors.white,),),

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

  ///Add Cliente
  Future<void> _showDialogSaveCliente(BuildContext context, ScreenArgumentsUser argsUser, bool editar, Cliente? cliente) async {
    bool isLoader = false; // <-- Fora do builder, controlado pelo setState do StatefulBuilder

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(child: Text("Cadastro Cliente")),
              titleTextStyle: AppTextStyles.titleCardVacina,
              contentPadding: const EdgeInsets.only(left: 5, bottom: 0, right: 5, top: 0),
              content: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                width: 400,
                height: 350,
                child: Scaffold(
                  body: Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0, top: 10.0, right: 0, bottom: 10),
                                    child: Text("", style: AppTextStyles.vacinaNome),
                                  ),
                                  widgetName(),
                                  widgetEmail(),
                                  widgetPhone(),
                                  Utils.sizedBox(10, 20),
                                  widgetContatos(cliente!.telephone ?? ""),
                                  ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _validateCliente()) {
                      setState(() {
                        isLoader = true;
                      });
                      Cliente c = _generateCliente();
                      if(!editar) {
                        await _cadastrarCliente(c, argsUser.data.user.id, context);
                      }else {
                        c.id = cliente?.id;
                        await _atualizarCliente(c, argsUser.data.user.id, context);
                      }
                       setState(() {
                        isLoader = false;
                        Navigator.pop(context);
                        carregarClientes(); ///Relistar Clientes, após add/update
                      });
                    }
                  },
                  child: isLoader
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  ///Input Name
  widgetName(){
    return TextFormField(
      enabled: true,
      keyboardType: TextInputType.text,
      controller: _nameController,
      focusNode: _myFocusNodeName,
      decoration: const InputDecoration(
          hintText: 'Nome',
          icon: Icon(Icons.person, color: Colors.blue,)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nome obrigatório';
        }
        return null;
      },
    );
  }
  ///Input Email
  widgetEmail(){
    return TextFormField(
        enabled: true,
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        focusNode: _myFocusNodeEmail,
        decoration: const InputDecoration(
            hintText: 'E-mail',
            icon: Icon(Icons.alternate_email, color: Colors.blue,)
        )
      ,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email obrigatório';
        }
        return null;
      },);
  }
  ///Input Phone
  widgetPhone(){
    return TextFormField(
        enabled: true,
        keyboardType: TextInputType.phone,
        controller: _phoneController,
        focusNode: _myFocusNodePhone,
        inputFormatters: [maskFormatter],
        decoration: const InputDecoration(
            hintText: 'Telefone',
            icon: Icon(Icons.phone, color: Colors.blue,)
        ),
        onChanged: (value) {
          // Atualiza o número sem máscara sempre que digitar
          _telefoneSemMascara = maskFormatter.getUnmaskedText();
          debugPrint("Telefone limpo: $_telefoneSemMascara");
        },
        validator: (value) {
           if (value == null || value.isEmpty) {
            return 'Telefone obrigatório';
          }
      return null;
    },);
  }
  ///Input Cpf
  /*widgetCpf(){
    return TextFormField(
        enabled: true,
        keyboardType: TextInputType.number,
        controller: _cpfController,
        focusNode: _myFocusNodeCpf,
        decoration: const InputDecoration(
            hintText: 'Cpf',
            icon: Icon(Icons.credit_card, color: Colors.blue,)
        ),
        validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Cpf obrigatório';
        }
      return null;
    },);
  }*/
  ///Focus dos inputs
  _initFocusNode(){
     _myFocusNodeName = FocusNode();
     _myFocusNodePhone = FocusNode();
     _myFocusNodeEmail = FocusNode();
  }
  ///Limpar os inputs
  _clearControllers() {
    _nameController.clear();
    _cpfController.clear();
    _phoneController.clear();
    _emailController.clear();
  }
  ///Validar cadastro
  bool _validateCliente() {
    bool flag = true;
    if(_nameController.text.isEmpty) return false;
    if(_phoneController.text.isEmpty) return false;
    if(_emailController.text.isEmpty) return false;
    return flag;
  }
 ///Retornar um cliente
 Cliente _generateCliente(){
    Cliente cliente = Cliente();
    cliente.name = _nameController.text;
    cliente.telephone = _phoneController.text;
    cliente.cpf = _cpfController.text;
    cliente.email = _emailController.text;
    cliente.createdAt = DateTime.now().toIso8601String();
    cliente.updatedAt = DateTime.now().toIso8601String();
  return cliente;
}
  ///Add Cliente
  Future<bool> _cadastrarCliente(Cliente c, user_id, BuildContext context) async {
      return await ClienteApi(context).addCliente(c, user_id);
  }

  ///Add Cliente
  Future<bool> _atualizarCliente(Cliente c, user_id, BuildContext context) async {
    return await ClienteApi(context).updateCliente(c, user_id);
  }

  void _popularClienteEditar(Cliente cliente) {
    _nameController.text =  cliente.name ?? "";
    _phoneController.text = cliente.telephone ?? "";
    _cpfController.text = cliente.cpf ?? "";
    _emailController.text = cliente.email ?? "";
  }

  Widget widgetContatos(String phone) {
    return Row(
      children: [
        const Text("Contatos: "),
        // Ícone de telefone
        IconButton(
          icon: const Icon(Icons.phone_in_talk),
          onPressed: () async {
            final Uri url = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              debugPrint("Não foi possível abrir o discador.");
            }
          },
        ),
        const SizedBox(width: 10),
        // Ícone do WhatsApp
        IconButton(
          icon: const Icon(Icons.chat),
          onPressed: () async {
            // Remove caracteres inválidos do número
            final String cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
            final Uri url = Uri.parse('https://wa.me/55$cleanedPhone');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              debugPrint("Não foi possível abrir o WhatsApp.");
            }
          },
        ),
      ],
    );
  }
}
