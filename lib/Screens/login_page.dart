import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Components/editor.dart';
import 'package:student_notes/Services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:student_notes/Theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormState>();
  final _formCadastroKey = GlobalKey<FormState>();

  //Controladores dos campos do formulário de login
  final loginEmail = TextEditingController();
  final loginSenha = TextEditingController();

  //Controladores dos campos do formulário de cadastro
  final registrarNome = TextEditingController();
  final registrarEmail = TextEditingController();
  final registrarSenha = TextEditingController();
  final registrarConfirmaSenha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late bool esqueceuSenha;
  late String actionButton;
  late String toggleButton;
  late String tituloLogin;
  late double alturaDoCard;
  late Widget formulario;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Entre na sua conta';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
        tituloLogin = 'Bem vindo de volta! Acesse sua conta para acompanhar suas atividades.';
        esqueceuSenha = true;
        formulario = formLogin();
        alturaDoCard = 450;
      } else {
        titulo = 'Crie uma conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
        tituloLogin =
            'Você está quase lá! Cadastre-se para ter registrado suas atividades escolares.';
        esqueceuSenha = false;
        formulario = formCadastro();
        alturaDoCard = 600;
      }
    });
  }

  login() async {
    try {
      await context.read<AuthService>().login(loginEmail.text, loginSenha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    try {
      await context.read<AuthService>().registrar(
          registrarEmail.text, registrarSenha.text, registrarNome.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var size = MediaQuery.of(context).size;
          return buildLayout(constraints, size);
        },
      )),
    );
  }

  Widget buildLayout(BoxConstraints constraints, Size size) {
    if (constraints.maxWidth > 991) {
      return Row(
        children: <Widget>[
          appLogo(size.height, constraints.maxWidth / 2),
          forms(size.height, constraints.maxWidth / 2)
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          appLogo(size.height / 3, constraints.maxWidth),
          forms(size.height, constraints.maxWidth)
        ],
      );
    }
  }

  Widget appLogo(double size, double constraints) {
    return Container(
      height: size,
      width: constraints,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/Assets/Svg/logo-light.svg',
            width: 400,
          ),
          const SizedBox(height: 15),
          Text(
            tituloLogin,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget forms(double size, double constraints) {
    return Container(
      height: size,
      width: constraints,
      decoration: BoxDecoration(color: AppColors.flexSchemeDark.surface),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.5,
            ),
          ),
          TextButton(
            onPressed: () => setFormAction(!isLogin),
            child: Text(toggleButton),
          ),
          formulario,
          ElevatedButton(
              onPressed: () {
                if (isLogin) {
                  if (_formLoginKey.currentState!.validate()) {
                    debugPrint('login');
                    login(); // Chama o método de login
                  }
                } else {
                  if (_formCadastroKey.currentState!.validate()) {
                    debugPrint('cadastro');
                    registrar(); // Chama o método de cadastro
                  }
                }
              },
              child: Text(actionButton)),
          if (esqueceuSenha)
            TextButton(
              onPressed: () {},
              child: const Text('Esqueceu sua senha? Recuperar minha senha.'),
            ),
        ],
      ),
    );
  }

  Widget formLogin() {
    return Form(
        key: _formLoginKey,
        child: Column(
          children: [
            EditorAuthField(
                controlador: loginEmail,
                rotulo: 'Email',
                dica: 'Seu email',
                errorText: 'Campo Obrigatório!',
                icon: const Icon(Icons.email_rounded),
                verSenha: false,
                confirmPasswordField: false),
            EditorAuthField(
                controlador: loginSenha,
                rotulo: 'Senha',
                dica: 'Sua senha',
                errorText: 'Campo Obrigatório!',
                icon: const Icon(Icons.lock_rounded),
                verSenha: true,
                confirmPasswordField: false),
          ],
        ));
  }

  Widget formCadastro() {
    return Form(
        key: _formCadastroKey,
        child: Column(
          children: [
            EditorAuthField(
                controlador: registrarNome,
                rotulo: 'Nome',
                dica: 'Seu nome',
                errorText: 'Campo Obrigatório!',
                icon: const Icon(Icons.person),
                verSenha: false,
                confirmPasswordField: false),
            EditorAuthField(
                controlador: registrarEmail,
                rotulo: 'Email',
                dica: 'Seu email',
                errorText: 'Campo Obrigatório!',
                icon: const Icon(Icons.email_rounded),
                verSenha: false,
                confirmPasswordField: false),
            EditorAuthField(
                controlador: registrarSenha,
                rotulo: 'Senha',
                dica: 'Sua senha',
                errorText: 'Campo Obrigatório!',
                icon: const Icon(Icons.lock_rounded),
                verSenha: true,
                confirmPasswordField: false),
            EditorAuthField(
                controlador: registrarConfirmaSenha,
                rotulo: 'Confirmar senha',
                dica: 'Repita sua senha',
                errorText:
                    'Por favor, verifique se este campo possui a mesma senha digitada!',
                icon: const Icon(Icons.lock_rounded),
                verSenha: true,
                controllerSenha: registrarSenha,
                confirmPasswordField: true),
          ],
        ));
  }
}
