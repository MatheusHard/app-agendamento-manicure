import 'package:app_agendamento_manicure/ui/api/agendamentoapi.dart';
import 'package:app_agendamento_manicure/ui/api/clienteapi.dart';
import 'package:app_agendamento_manicure/ui/dto/agendamento_dto.dart';
import 'package:app_agendamento_manicure/ui/enums/drawer_sections.dart';
import 'package:app_agendamento_manicure/ui/models/agendamento.dart';
import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:app_agendamento_manicure/ui/pages/pix_page.dart';
import 'package:app_agendamento_manicure/ui/pages/screen_arguments/ScreenArgumentsUser.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_colors.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_images.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/appbar/app_bar.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/card/card_agendamento.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/drawer_sections.dart';
import 'package:app_agendamento_manicure/ui/pages/widgets/drawer/header_drawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../api/configurations/dio/configs.dart';
import '../models/user.dart';
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
  final Configs _customDio = Configs();

  bool isLoading = true;
  final _observacaoController = TextEditingController();
  final _horaController = TextEditingController();
  final _minutoController = TextEditingController();
  final _dataController = TextEditingController();
  var _mensagemErroCliente;
  bool _finalizado = false;
  late FocusNode _myFocusNodeHora;
  late FocusNode _myFocusNodeMinuto;

  @override
  void initState() {

    carregarClientes();
    userLogado = widget.userLogado;
    carregarAgendamentos(userLogado);
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
        appBar: CustomAppBarUsuario(
            width: width,
            usuarioLogado: userLogado,
            scaffoldKey: key),
        drawer:  Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///Header Drawer
                  MeuHeadDrawer(userLogado),
                  ///Body Drawer
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
                onDismissed: (direction) async {
                  // remove o agendamento da lista
                  setState(() {
                    listaAgendamentos.removeAt(index);
                  });
                  //TODO
                  ///Atualizar o Agendamento pra Deletado:
                  //agendamento.deletado = true;
                 // await _atualizarAgendamento(agendamento, context);

                },
                child: CardAgendamento(
                  title: agendamento.cliente?.name ?? "Sem nome",
                  subtitle: agendamento.updatedAt ?? "Sem data",
                  urlFotoCliente: agendamento.cliente?.photoName,
                  icon: agendamento.finalizado == true
                      ? Icons.check_circle
                      : Icons.schedule,
                  onTap: () async {
                    await _showDialogSaveAgendamento(context, userLogado!, true, agendamento);
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
            carregarAgendamentos(userLogado); // <- atualiza lista após fechar o dialog
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

  getBody() {
    return (_currentIndex == 0) ? HomePage(userLogado) : Container();
  }

  Future<void> carregarAgendamentos(ScreenArgumentsUser? userLogado) async {

    try {
      ///Filters
      AgendamentoDTO a = AgendamentoDTO(cliente: Cliente(), user: User(id: userLogado?.data.user.id));
      a.user = User(id: userLogado?.data.user.id);
      a.cliente = Cliente();
      //a.dataInicial = Utils.getDataHora();
      //a.dataFinal = Utils.getDataHora();
      a.finalizado = false;

      final dados = await AgendamentoApi(context).getListByFilter(a);
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
  ///Limpar os campos
  _clearControllers() {
    _dataController.clear();
    _horaController.clear();
    _minutoController.clear();
    _observacaoController.clear();
    clienteSelected = null;
   }

   ///Dialog Cadastro/Edição Agendamento
  _showDialogSaveAgendamento(BuildContext context, ScreenArgumentsUser screenArgumentsUser, bool editar, Agendamento? agendamento) async {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if(editar) _initEditar(agendamento);

    var isLoader = false; // <-- Fora do builder, controlado pelo setState do StatefulBuilder
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(child: Text("Cadastro Agendamento", style: AppTextStyles.textoSentimentoNegritoWhite(16,  context),)),
              titleTextStyle: AppTextStyles.titleCardVacina,
              contentPadding: const EdgeInsets.only(left: 5, bottom: 0, right: 5, top: 25),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widgetClientes(), ///Input Clientes
                                  widgetDataCompleta(), ///Input Data Completa
                                  widgetObservacao(), ///Input Observação
                                  widgetFinalizado(setState) ///Check Finalizado
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

                      String? created = editar ? agendamento?.createdAt : null;
                      int? id = agendamento?.id;

                      Agendamento a = _generateAgendamento(editar, created, id);
                      if(!editar) {
                        await _cadastrarAgendamento(a, context);
                      }else {
                        await _atualizarAgendamento(a, context);
                      }
                      setState(() {
                        isLoader = false;
                        Navigator.pop(context);
                        carregarAgendamentos(userLogado); ///Relistar Agendamentos, após add/update
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
  ///Add Cliente
  Future<bool> _cadastrarAgendamento(Agendamento a, BuildContext context) async {
    return await AgendamentoApi(context).addAgendamento(a);
  }
  ///Add Cliente
  Future<bool> _atualizarAgendamento(Agendamento a, BuildContext context) async {
    return await AgendamentoApi(context).updateAgendamento(a);
  }
  ///Input Clientes
  widgetClientes() {
    return SizedBox(
      width: 250,
      child: FormField<Cliente>(
        initialValue: clienteSelected, // <- aqui seta o valor inicial
        validator: (value) {
          if (value == null) {
            return 'Selecione um cliente';
          }
          return null;
        },
        builder: (FormFieldState<Cliente> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownSearch<Cliente>(
                asyncItems: (String filtro) async {
                  return listaClientes
                      .where((c) => c.name!.toLowerCase().contains(filtro.toLowerCase()))
                      .toList();
                },
                selectedItem: field.value, // <-- usa o valor controlado pelo FormField
                itemAsString: (Cliente? cliente) => cliente?.name ?? 'Sem Nome',
                onChanged: (Cliente? clienteSelecionado) {
                  clienteSelected = clienteSelecionado;
                  field.didChange(clienteSelecionado); // notifica mudança
                },
                dropdownBuilder: (context, clienteSelecionado) {
                  return Text(
                    clienteSelecionado?.name ?? 'Selecione',
                    style: const TextStyle(fontSize: 16),
                  );
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Cliente',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 16), // ← Aqui
                    errorText: field.errorText,
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  ///Input Name
  widgetObservacao(){
    return Padding(
      padding: const EdgeInsets.only(left: 15, ),
      child: TextFormField(
        enabled: true,
        keyboardType: TextInputType.text,
        controller: _observacaoController,
        decoration: const InputDecoration(
            hintText: 'Observação',
            icon: Icon(Icons.textsms, color: Colors.blue,)
        ),

      ),
    );
  }
  ///Input Name
  widgetHora(){
    return SizedBox(
      width: 35, // ajuste aqui o tamanho
      child: TextFormField(
        maxLength: 2,
        enabled: true,
        keyboardType: TextInputType.number,
        controller: _horaController,
        focusNode: _myFocusNodeHora,
        decoration: const InputDecoration(
            hintText: 'HH',
            //icon: Icon(Icons.alarm, color: Colors.green,)
        ),
        validator: (value) {
          if (value == null || value.isEmpty)  return 'Erro Obrigatória!!!';
          if(int.parse(_horaController.text) < 0 || int.parse(_horaController.text) > 24) return 'Hora deve ser entre 0 e 24';
          return null;
        },
      ),
    );
  }
  ///Input Name
  widgetMinuto(){
    return SizedBox(
      width: 35, // ajuste aqui o tamanho
      child: TextFormField(
        maxLength: 2,
        enabled: true,
        keyboardType: TextInputType.number,
        controller: _minutoController,
        focusNode: _myFocusNodeMinuto,
        decoration: const InputDecoration(
            hintText: 'mm',
        ),
        validator: (value) {
          if (value == null || value.isEmpty)  return 'Minuto obrigatório!!!';
          if(int.parse(_minutoController.text) < 0 || int.parse(_minutoController.text) > 60) return 'Minutos devem ser entre 0 e 60!!!';

          return null;
        },
      ),
    );
  }
  ///Widget Data
  widgetData(){
    return  Padding(
      padding: const EdgeInsets.only(left: 15, top: 8, right: 16),
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
            hintText: "Data",
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
  ///Widget Finalizado
  widgetFinalizado(StateSetter setDialogState) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 16, top: 5),
      child: CheckboxListTile(
        title: const Text("Finalizado"),
        //subtitle: const Text("Clique para aceitar."),
        value: _finalizado,
        onChanged: (bool? newValue) {
          setDialogState(() {
            _finalizado = newValue!;
            print(_finalizado);
          });
        },
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  ///Validar cadastro
  bool _validateAgendamento() {
    bool flag = true;

    String? erroCliente;

    // Validações
    if (_horaController.text.isEmpty) flag = false;
    if (_minutoController.text.isEmpty) flag = false;
    if (_dataController.text.isEmpty) flag = false;

    if (clienteSelected == null) {
      erroCliente = 'Selecione um cliente';
      flag = false;
    }

    // Atualiza os estados de erro depois de validar tudo
    setState(() {
      _mensagemErroCliente = erroCliente;
      print('Erro cliente: $_mensagemErroCliente');

    });

    return flag;
  }

  ///Inputs de Data, Hora e Min
  widgetDataCompleta(){
    return Row(
      children: [
        widgetData(),
        widgetHora(),
        Text(" : "),
        widgetMinuto()
      ],
    );
}

  ///Gerar objeto Agendamento:
  Agendamento _generateAgendamento(bool editar, String? created, int? id_agendamento) {

      User user = User();
      Cliente cliente = Cliente();
      user.id = userLogado?.data.user.id;
      cliente.id = clienteSelected?.id;
      String dataFormatada = Utils.generateDataHora(date, int.parse(_horaController.text), int.parse(_minutoController.text));

      Agendamento a = Agendamento();
      if(editar) a.id = id_agendamento;
      a.observacao = _observacaoController.text;
      a.createdAt = editar ? created : Utils.generateDataHoraSpring();
      a.updatedAt = dataFormatada;
      a.user = user;
      a.cliente = cliente;
      a.finalizado = editar ? _finalizado : false;

    return a;
  }

  ///Focus dos inputs
  _initFocusNode(){
    _myFocusNodeHora = FocusNode();
    _myFocusNodeMinuto = FocusNode();
    }

  void _initEditar(Agendamento? agendamento) {
    _observacaoController.text = agendamento?.observacao ?? "";
    _minutoController.text = Utils.generateMinutesOfDate(agendamento?.createdAt).toString();
    _horaController.text = Utils.generateHourOfDate(agendamento?.createdAt).toString();
    setState(() {
      clienteSelected = agendamento?.cliente;
      date = DateTime.parse(agendamento!.updatedAt!);
      _dataController.text = Utils.formatarData(date.toString(), true);
    });
  }
}
