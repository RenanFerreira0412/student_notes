import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Components/editor.dart';
import 'package:student_notes/Services/auth_service.dart';

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
  late String actionButton;
  late String toggleButton;
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
        titulo = 'Student Notes';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
        formulario = formLogin();
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
        formulario = formCadastro();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Text(actionButton))
          ],
        ),
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
