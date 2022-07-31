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
          mainAxisAlignment: MainAxisAlignment.center,
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
                controller: loginEmail,
                maxLength: 50,
                lines: 1,
                labelText: 'Email',
                dica: 'Seu email',
                isConfirmSenha: false),
            EditorAuthField(
                controller: loginSenha,
                maxLength: 15,
                lines: 1,
                labelText: 'Senha',
                dica: 'Sua senha',
                isConfirmSenha: false)
          ],
        ));
  }

  Widget formCadastro() {
    return Form(
        key: _formCadastroKey,
        child: Column(
          children: [
            EditorAuthField(
                controller: registrarNome,
                maxLength: 50,
                lines: 1,
                labelText: 'Nome',
                dica: 'Seu nome',
                isConfirmSenha: false),
            EditorAuthField(
                controller: registrarEmail,
                maxLength: 50,
                lines: 1,
                labelText: 'Email',
                dica: 'Seu email',
                isConfirmSenha: false),
            EditorAuthField(
              controller: registrarSenha,
              maxLength: 15,
              lines: 1,
              labelText: 'Senha',
              dica: 'Sua senha',
              isConfirmSenha: false,
            ),
            EditorAuthField(
                controller: registrarConfirmaSenha,
                maxLength: 15,
                lines: 1,
                labelText: 'Confirmar senha',
                dica: 'Repita a senha digitada',
                isConfirmSenha: true,
                registrarSenha: registrarSenha)
          ],
        ));
  }
}
