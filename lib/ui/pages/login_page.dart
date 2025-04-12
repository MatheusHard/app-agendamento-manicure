import 'package:app_agendamento_manicure/ui/api/loginapi.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_gradients.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/core/app_text_styles.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import '../models/user.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email;
  late String _senha;
  bool isChecked = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _myFocusNode;
  final textFieldFocusNode = FocusNode();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  bool obscured = true;
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void initState (){
    carregarUser();
    _myFocusNode = FocusNode();
    super.initState();
  }

  carregarUser() async {
    User? user = await Utils.recuperarUser();
    if(user != null){
      _email = user.username ?? ""; // agora ok
      _senha = user.password ?? "";
      _controllerEmail.text = _email;
      _controllerPassword.text = _senha;
    }
    _loadConectado();
  }
  ///Exibir, caso manter conectado ja tenha sido marcado:
  Future<void> _loadConectado() async {
    isChecked = await Utils.recuperarManterConectado();
    setState(() {
      isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {

    double tamanho = kIsWeb ? 4 : 2; // Por exemplo: menor na web, maior no mobile

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print('widt $width');

    ///Mudar cor do CheckBOx:
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    final logo = Hero(
        tag: 'hero',
        child:

        Padding(
          padding: EdgeInsets.all(50),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width / 8),
                boxShadow:const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  )]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/images/esmalte_logo.jpg',
                fit: BoxFit.cover,
                width: width / tamanho,
              ),
            ),
          ),
        ));

    final email = TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),         // No border
          borderRadius: BorderRadius.circular(12),  // Apply corner radius
        ),
        prefixIcon: const Icon(Icons.alternate_email, color: Colors.blue,),

        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator:  (value){
        if(value!.isEmpty || value == ""){
          _myFocusNode.requestFocus();
          return "Digite o Email";
        }
        return null;
      },    );

    final senha = TextFormField(
      autofocus: false,
      controller: _controllerPassword,
      obscureText: obscured,
      focusNode: textFieldFocusNode,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) {
        setState(() {
          _senha = value;
        });
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never, //Hides label on focus or if filled
        labelText: "Senha",
        filled: true, // Needed for adding a fill color
        fillColor: Colors.white60,
        isDense: true,  // Reduces height a bit
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),         // No border
          borderRadius: BorderRadius.circular(12),  // Apply corner radius
        ),
        prefixIcon: const Icon(Icons.lock_rounded, size: 24),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon( obscured ? Icons.visibility_rounded :Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
      ),
      validator:  (value){
        if(value!.isEmpty || value == ""){
          _myFocusNode.requestFocus();
          return "Digite a Senha";
        }
        return null;
      },
    );

    final botao = GestureDetector(

      onTap: ()  {
          if(_formKey.currentState!.validate()) {
            _isLoading.value = !_isLoading.value;
            _logar();
          }
      },
      child:   Container(
       height: 60,
        decoration: BoxDecoration(
            gradient: AppGradients.petMacho,
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ]
        ),

        child: AnimatedBuilder(
            animation: _isLoading,
            builder: (context, _) {
              return _isLoading.value
                  ?
              ///Loading:
              const Center(
                child: CircularProgressIndicator(
                  valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              ///Botão de Logar:
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(Icons.account_circle_rounded, color: Colors.white, size: 20),
                  Utils.sizedBox(15, 0),
                  Text("Log In", textAlign: TextAlign.left,
                      style:  AppTextStyles.textLogin
                  ),
                ],
              );}
        ),
      ),
    );

    final manterConectado = Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),

        TextButton(
          child: const Text(
            'Manter Conectado',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onPressed: () {
          },
        )
      ],);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 24, right: 24),
              children: [
                logo,
                _sizedBox(48.0),
                email,
                _sizedBox(15.0),
                senha,
                _sizedBox(24.0),
                botao,
                manterConectado,
              ],
            ),
          ),
        )
    );

  }
  void _toggleObscured() {
    setState(() {
      obscured = !obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }
  ///Loading Icon and Text:
  void _logar() async {
   _isLoading.value = await LoginApi(context).login(_email, _senha, isChecked);
  }

  _sizedBox(double height){
    return SizedBox(
      height: height,
    );
  }

  /**Future<void> _dialogAceiteosTermos(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Termo de Consentimento')),
          content: const SingleChildScrollView(
            child: Text(''''|. O atendimento a distância é limitado por não permitir a realização do exame físico presencial.
          Poderão ser executadas algumas manobras de tele propedêutica, que é o exame físico à distância. Por isso é ainda mais importante informar todos os dados e informações possíveis, não omitindo nenhuma informação referente ao problema de saúde, colaborando assim para o bom aproveitamento desta consulta;

          Il. Poderá ser necessário, a critério do médico, a realização de exames complementares para auxiliar no diagnóstico;
. O atendimento a distância é limitado por não permitir a realização do exame físico presencial.
          Poderão ser executadas algumas manobras de tele propedêutica, que é o exame físico à distância. Por isso é ainda mais importante informar todos os dados e informações possíveis, não omitindo nenhuma informação referente ao problema de saúde, colaborando assim para o bom aproveitamento desta consulta;

          Il. Poderá ser necessário, a critério do médico, a re
          . O atendimento a distância é limitado por não permitir a realização do exame físico presencial.
          Poderão ser executadas algumas manobras de tele propedêutica, que é o exame físico à distância. Por isso é ainda mais importante informar todos os dados e informações possíveis, não omitindo nenhuma informação referente ao problema de saúde, colaborando assim para o bom aproveitamento desta consulta;

          Il. Poderá ser necessário, a critério do médico, a re
          . O atendimento a distância é limitado por não permitir a realização do exame físico presencial.
          Poderão ser executadas algumas manobras de tele propedêutica, que é o exame físico à distância. Por isso é ainda mais importante informar todos os dados e informações possíveis, não omitindo nenhuma informação referente ao problema de saúde, colaborando assim para o bom aproveitamento desta consulta;

          Il. Poderá ser necessário, a critério do médico, a re
        '''),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final termosConsentimento = Row(

    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),

      TextButton(

        child: const Text(

          'Manter Conectado',

          style: TextStyle(color: Colors.blue, fontSize: 16),

        ),

        onPressed: () {
          _dialogAceiteosTermos(context);

        },
      )
    ],
  );*/


}
