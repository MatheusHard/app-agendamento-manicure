import 'dart:convert';
import 'dart:io';

import 'package:app_agendamento_manicure/ui/dto/cliente_dto.dart';
import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_colors.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_images.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/appbar/app_bar.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/card/card_cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/drawer_sections.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../api/clienteapi.dart';
import '../api/configurations/dio/configs.dart';
import '../enums/drawer_sections.dart';
import '../models/user.dart';
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
  DrawerSections currentPage = DrawerSections.cliente;
  bool isLoading = true;
  List<Cliente> listaClientes = [];
  File? _imagem;
  var bytes;
  final ImagePicker _picker = ImagePicker();

  ///Dados Cliente
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
      //appBar:  _appBar(width, userLogado),
      appBar: CustomAppBarUsuario(
          width: width,
          usuarioLogado: userLogado,
          scaffoldKey: key),
      ///Drawer
      drawer:  Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///Header Drawer
                MeuHeadDrawer(userLogado),
                ///Body Drawer
                //_meuDrawerList(userLogado),
                MeuDrawerList(
                  currentPage: currentPage,
                  onSectionSelected: (section) {
                    setState(() {
                      currentPage = section;
                    });
                  },
                  usuario: userLogado,
                ),
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
                photoname: cliente.photoName,
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
      ///Filters
      ClienteDTO filters = ClienteDTO();
      filters.user = User(id: userLogado?.data.user.id);
      final dados = await ClienteApi(context).getListByFilter(filters);
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
                                  widgetName(), ///Input Nome
                                  widgetEmail(), ///Input Email
                                  widgetPhone(), ///Input Telefone
                                  Utils.sizedBox(10, 20),
                                  widgetFoto(() => _tirarFoto(setState)),
                                  Utils.sizedBox(10, 20),
                                  widgetContatos(cliente != null ? cliente.telephone! : ""), ///Buttons Encaminhar Telefone e Whattzap

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
                      Cliente c = await _generateCliente();
                      if(!editar) {
                        await _cadastrarCliente(c, argsUser.data.user.id, context);
                      }else {
                        c.id = cliente?.id;
                        await _atualizarCliente(c, argsUser.data.user.id, context);
                      }
                       setState(() {
                        isLoader = false;
                        Navigator.pop(context);
                        carregarClientes(); ///Lista novamente Clientes, após add/update
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

  widgetFoto(void Function() tirarFoto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        GestureDetector(
          onTap: tirarFoto,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius
                    .circular(50)),
            height: 70,
            width: 70,
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                const Center(child:
                Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.black,
                  size: 35,),),

                Align(
                    alignment: const Alignment(
                        0, 2.0),
                    child:
                    Padding(
                      padding: const EdgeInsets
                          .only(bottom: 20),
                      child: Text("Camera",
                        style: AppTextStyles
                            .bodyBold,),
                    )
                )
              ],
            ),
          )
        ),
        if (_imagem != null)
          Image.file(
            _imagem!,
            key: ValueKey(_imagem!.path), // força reconstrução
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  widgetContatos(String phone) {
    return Row(
      children: [
        const Text("Contatos: "),
        const SizedBox(width: 15),
        GestureDetector(
            onTap: () async {
              // Remove caracteres inválidos do número
              final String cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
              final Uri url = Uri.parse('https://wa.me/55$cleanedPhone');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("Não foi possível abrir o WhatsApp.");
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image:  DecorationImage(
                      image: AssetImage(
                          AppImages.zap
                      )
                  )
              ),
            )
        ),
        const SizedBox(width: 25),
        ///Zap
        GestureDetector(
            onTap: () async {
              final Uri url = Uri(scheme: 'tel', path: phone);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("Não foi possível abrir o discador.");
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                //color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  image:  DecorationImage(
                      image: AssetImage(
                          AppImages.phone
                      )
                  )
              ),
            )
        ),

      ],
    );
  }

  Future<void> _tirarFoto(StateSetter dialogSetState) async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);

    if (foto != null) {
      dialogSetState(() {
        _imagem = File(foto.path);
        bytes =_imagem?.readAsBytes();
      });
    }
  }

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
    _imagem = null;
  }
  ///Validar cadastro
  bool _validateCliente() {

    bool flag = true;
    if(_nameController.text.isEmpty) return false;
    if(_phoneController.text.isEmpty) return false;
    if(_emailController.text.isEmpty) return false;
    //if(_imagem == null) return false;

    return flag;
  }
 ///Retornar um cliente
 Future<Cliente> _generateCliente() async {

   Cliente cliente = Cliente();
    cliente.name = _nameController.text;
    cliente.telephone = _phoneController.text;
    cliente.cpf = _cpfController.text;
    cliente.email = _emailController.text;
    cliente.createdAt = DateTime.now().toIso8601String();
    cliente.updatedAt = DateTime.now().toIso8601String();
    cliente.imagemBase64 = await Utils.base64String(bytes);
    cliente.photoName =  "foto_${userLogado?.data.user.id}${DateTime.now().millisecondsSinceEpoch}.jpg";

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

}
