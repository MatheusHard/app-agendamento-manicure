import 'package:app_agendamento_manicure/ui/api/agendamentoapi.dart';
import 'package:app_agendamento_manicure/ui/api/clienteapi.dart';
import 'package:app_agendamento_manicure/ui/enums/drawer_sections.dart';
import 'package:app_agendamento_manicure/ui/models/agendamento.dart';
import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_colors.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/card_agendamento.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'cliente_page.dart';

class HomePage extends StatefulWidget {
  final ScreenArgumentsUser? userLogado;
  const HomePage(this.userLogado, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScreenArgumentsUser? userLogado;
  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState>();
  final int _currentIndex = 0;
  var currentPage = DrawerSections.dashboard;
  List<Agendamento> listaAgendamentos = [];
  List<Cliente> listaClientes = [];
  Cliente? clienteSelected;
  DateTime date = DateTime.now();

  bool isLoading = true;
  final _observacaoController = TextEditingController();
  final _horaController = TextEditingController();
  final _minutoController = TextEditingController();
  final _dataController = TextEditingController();
  late FocusNode _myFocusNodeHora;
  late FocusNode _myFocusNodeMinuto;

  @override
  void initState() {

    carregarClientes();
    userLogado = widget.userLogado;
    carregarAgendamentos();
    _initFocusNode();
    testeAdd();
    super.initState();
  }

  // TODO
  testeAdd() async {
  /*  Cliente c = Cliente();
    c.telephone = "83 999888";
    c.cpf = "05697455521";
    c.email = "chocho@gmail.com";
    c.updatedAt = "2025-03-30T09:33:17.693631";
    c.createdAt =  "2025-03-30T09:33:17.693631";
    c.name = "Pit Bitoca";
    ClienteApi(context).addCliente(c, 1);
    */
    var lista = await ClienteApi(context).getList(1, 1);
    print(lista);
  }
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //ScreenArgumentsUser? userLogado = ModalRoute.of(context)?.settings.arguments as ScreenArgumentsUser?;

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
        body: Container(
          padding: EdgeInsets.all(8),
          child:  isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: listaAgendamentos.length,
            itemBuilder: (BuildContext context, int index) {
              final Agendamento agendamento = listaAgendamentos[index];

              return Dismissible(
                key: (Key(agendamento.id.toString())), // chave única, geralmente o ID do item
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
                    listaAgendamentos.removeAt(index);
                  });
                  ///Atualizar o Cliente pra Deletado:
                  //await _atualizarA(cliente, userLogado?.data.user.id, context);

                },
                child: CardAgendamento(
                  title: agendamento.cliente?.name ?? "Sem nome",
                  subtitle: agendamento.createdAt ?? "Sem data",
                  icon: agendamento.finalizado == true
                      ? Icons.check_circle
                      : Icons.schedule,
                  onTap: () {
                    print(agendamento.cliente?.name ?? "");
                  },
                ),
              );
            },
          )
        ),
        ///Botão Add
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _clearControllers();
            await _showDialogSaveAgendamento(context, userLogado!, false, null);
            carregarAgendamentos(); // <- atualiza lista após fechar o dialog
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.green, // verde
          tooltip: 'Adicionar Cliente',
          child: const Icon(Icons.add, color: Colors.white,),),
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
  /*final tabs = [
    Container(child: Text("HOme"),),
    Padding( padding: const EdgeInsets.only( left:8.0, right: 8.0), child: Container(  color:
    AppColors.levelButtonTextFacil,)),
    Container()
  ];*/

  getBody() {
    return (_currentIndex == 0) ? HomePage(userLogado) : Container();
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
                  break;
                case 1:
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

  Future<void> carregarAgendamentos() async {
    try {
      final dados = await AgendamentoApi(context).getList(1, 1, true);
      setState(() {
        listaAgendamentos = dados;
        isLoading = false;
      });
    } catch (e) {
      // Lida com erro, se quiser
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> carregarClientes() async {
    try {
      final dados = await ClienteApi(context).getList(1, 1);
      setState(() {
        listaClientes = dados;
        print("Crientes");
        print(listaClientes);
        //isLoading = false;
      });
    } catch (e) {
      // Lida com erro, se quiser
      setState(() {
        //isLoading = false;
      });
    }

  }

  _clearControllers() {
    _observacaoController.clear();
   }

  _showDialogSaveAgendamento(BuildContext context, ScreenArgumentsUser screenArgumentsUser, bool editar, Agendamento? agendamento) async {

    var isLoader = false; // <-- Fora do builder, controlado pelo setState do StatefulBuilder

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(child: Text("Cadastro Agendamento")),
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

                                  widgetClientes(),
                                  widgetDataCompleta(),
                                  widgetObservacao(), ///Input Observação

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
                    if (_formKey.currentState!.validate() && _validateAgendamento()) {
                      setState(() {
                        isLoader = true;
                      });
                      Agendamento a = _generateAgendamento();
                      if(!editar) {
                        //await _cadastrarCliente(c, argsUser.data.user.id, context);
                      }else {

                        //await _atualizarCliente(c, argsUser.data.user.id, context);
                      }
                      setState(() {
                        isLoader = false;
                        Navigator.pop(context);
                        carregarAgendamentos(); ///Relistar Agendamentos, após add/update
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

Future<List<Cliente>>  carregarTESTE() async{
    List<Cliente> listaComp =[];

    return listaComp;

  }
  ///Input Clientes
  widgetClientes() {
    return  SizedBox(
        width: 300,
        child: DropdownSearch<Cliente>(
          asyncItems: (String filtro) async {
            //final dados = await ClienteApi(context).getList(1, 1);
            return listaClientes.where((c) => c.name!.toLowerCase().contains(filtro.toLowerCase())).toList();
          },
          itemAsString: (Cliente? cliente) => cliente?.name ?? 'Sem Nome',
          onChanged: (Cliente? clienteSelecionado) {
            clienteSelected = clienteSelecionado;
            setState(() {});
            },
          dropdownBuilder: (context, clienteSelecionado) {
            return Text(
              clienteSelecionado?.name ?? 'Selecione',
              style: const TextStyle(fontSize: 16),
            );
          },
          dropdownDecoratorProps:  DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: 'Cliente',
              border: OutlineInputBorder(),
              icon: Icon(Icons.person)
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
          ),
        ));

  }
  ///Input Name
  widgetObservacao(){
    return TextFormField(
      enabled: true,
      keyboardType: TextInputType.text,
      controller: _observacaoController,
      decoration: const InputDecoration(
          hintText: 'Observação',
          icon: Icon(Icons.textsms, color: Colors.blue,)
      ),

    );
  }
  ///Input Name
  widgetHora(){
    return SizedBox(
      width: 80, // ajuste aqui o tamanho
      child: TextFormField(
        maxLength: 2,
        enabled: true,
        keyboardType: TextInputType.number,
        controller: _horaController,
        focusNode: _myFocusNodeHora,
        decoration: const InputDecoration(
            hintText: 'Hora',
            icon: Icon(Icons.alarm, color: Colors.green,)
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Hora obrigatória';
          }
          return null;
        },
      ),
    );
  }
  ///Input Name
  widgetMinuto(){
    return SizedBox(
      width: 40, // ajuste aqui o tamanho
      child: TextFormField(
        maxLength: 2,
        enabled: true,
        keyboardType: TextInputType.text,
        controller: _minutoController,
        focusNode: _myFocusNodeMinuto,
        decoration: const InputDecoration(
            hintText: 'Min',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Minuto obrigatório';
          }
          return null;
        },
      ),
    );
  }
  ///Widget Data
  widgegData(){
    return  Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8),
      child: SizedBox(
        width: 150,
        child: TextFormField(
          maxLength: 10,
          readOnly: true,
          onTap: () async {
            DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2040));
            if (newDate == null) return;
            setState(() {
              date = newDate;
              _dataController.value = TextEditingValue(
                  text: Utils.formatarDateTime(date));
            });
          },
          keyboardType: TextInputType.datetime,
          controller: _dataController,
          decoration: const InputDecoration(
            icon: Icon(Icons.date_range, color: Colors.green),
            hintText: "Data da Aplicação",
          ),

          validator: (value) {
            if (value == null || value == "") {
              return "Data de Aplicação Obrigatória!!!";
            }
            return null;
          },
        ),
      ),

    );
}
  ///Validar cadastro
  bool _validateAgendamento() {
    bool flag = true;
    //Validações aqui
    if(_horaController.text.isEmpty) return false;
    if(_minutoController.text.isEmpty) return false;
    return flag;
  }
widgetDataCompleta(){
    return Row(
      children: [
        widgegData(),
        widgetHora(),
        Text(" : "),
        widgetMinuto()
      ],
    );
}
  Agendamento _generateAgendamento() {
      Agendamento a = Agendamento();
      a.observacao = _observacaoController.text;
      a.createdAt = Utils.generateDataHora(10, 25);
      a.updatedAt = DateTime.now().toIso8601String();
      print("DAta ${a.createdAt!}");
    return a;
  }
  ///Focus dos inputs
  _initFocusNode(){
    _myFocusNodeHora = FocusNode();
    _myFocusNodeMinuto = FocusNode();
    }
}
