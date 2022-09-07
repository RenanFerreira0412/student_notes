import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Components/editor.dart';
import 'package:student_notes/Components/form_methods.dart';
import 'package:student_notes/Services/auth_service.dart';

class Formulario extends StatefulWidget {
  final String? titulo;
  final String? data;
  final String? topicos;
  final String? docId;
  final String? disciplina;

  const Formulario(
      {Key? key,
      this.titulo,
      this.data,
      this.topicos,
      this.docId,
      this.disciplina})
      : super(key: key);

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final CollectionReference activityRef =
      FirebaseFirestore.instance.collection('ATIVIDADES');

  final CollectionReference disciplinaRef =
      FirebaseFirestore.instance.collection('DISCIPLINAS');

  late AuthService auth;

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorTopicos = TextEditingController();
  final TextEditingController _controladorData = TextEditingController();
  final TextEditingController _controladorNome = TextEditingController();
  String documentID = '';

  late List vetDisciplinas;

  bool isExpanded = false;

  final _formKey = GlobalKey<FormState>();
  final _formKeyDisciplina = GlobalKey<FormState>();

  String? _disciplinaSelecionada = '';

  final String registrarDisciplina = 'Registrar disciplinas';
  //final String messageValidateChoiceChip = 'Por favor, escolha uma disciplina!';

  @override
  void initState() {
    // Retornando os valores para os campos de texto
    widget.titulo != null ? _controladorTitulo.text = widget.titulo! : '';
    widget.topicos != null ? _controladorTopicos.text = widget.topicos! : '';
    widget.data != null ? _controladorData.text = widget.data! : '';
    widget.disciplina != null ? _disciplinaSelecionada = widget.disciplina : '';
    widget.docId != null ? documentID = widget.docId! : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);

    vetDisciplinas = [];

    final _disciplinaStream = FirebaseFirestore.instance
        .collection('DISCIPLINAS')
        .where('userId', isEqualTo: auth.userId())
        .snapshots();

    final _disciplinasGeraisStream =
        FirebaseFirestore.instance.collection('DISCIPLINAS_GERAIS').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Atividades'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPanel(),
              const SizedBox(height: 13),
              StreamBuilder<QuerySnapshot>(
                stream: _disciplinasGeraisStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Algo deu errado!'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  vetDisciplinas = data.docs;

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 5.0,
                    children: List.generate(
                      data.size,
                      (int index) {
                        return buildChip(index, data);
                      },
                    ).toList(),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _disciplinaStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Algo deu errado!'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  //vetDisciplinas = data.docs;

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 5.0,
                    children: List.generate(
                      data.size,
                      (int index) {
                        return buildChip(index, data);
                      },
                    ).toList(),
                  );
                },
              ),
              const SizedBox(height: 13),
              EditorTextFormField(
                controller: _controladorTitulo,
                maxLength: 70,
                lines: 1,
                labelText: 'Título',
                dica: 'Título da atividade',
                validaCampo: true,
                readOnly: false,
                fieldIcon: const Icon(Icons.title_rounded),
              ),
              EditorTextFormField(
                controller: _controladorTopicos,
                maxLength: 150,
                lines: 4,
                labelText: 'Tópicos',
                dica: 'Tópicos da atividade',
                validaCampo: true,
                readOnly: false,
                fieldIcon: const Icon(Icons.topic_rounded),
              ),
              EditorTextFormField(
                controller: _controladorData,
                maxLength: 10,
                lines: 1,
                labelText: 'Data',
                dica: 'Data de entrega/realização da atividade',
                validaCampo: true,
                readOnly: true,
                fieldIcon: const Icon(Icons.calendar_today),
                action: () {
                  _selecionarData();
                },
              ),
              const SizedBox(height: 13),
              ElevatedButton(
                  onPressed: () {
                    limpaFormulario(_controladorTitulo, _controladorTopicos,
                        _disciplinaSelecionada, _controladorData);
                  },
                  child: const Text('Limpar'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            //Mensagem de validação - SnackBar
            const SnackBar snackBar =
                SnackBar(content: Text("Preencha corretamente os campos! "));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (_disciplinaSelecionada == '') {
            //Mensagem de validação - SnackBar
            const SnackBar snackBar =
                SnackBar(content: Text("Selecione uma disciplina! "));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            if (documentID == '') {
              criarAtividade(activityRef, _controladorTitulo, _controladorData,
                  _disciplinaSelecionada, _controladorTopicos, auth.userId());

              //SnackBar
              const SnackBar snackBar = SnackBar(
                  content: Text("Sua atividade foi criada com sucesso! "));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              editarAtividade(
                  activityRef,
                  documentID,
                  auth.userId(),
                  _controladorTitulo,
                  _controladorData,
                  _disciplinaSelecionada,
                  _controladorTopicos);
              //SnackBar
              const SnackBar snackBar = SnackBar(
                  content: Text("Sua atividade foi alterada com sucesso! "));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            //Limpa o formulário após a edição ou adição da atividade
            limpaFormulario(_controladorTitulo, _controladorTopicos,
                _disciplinaSelecionada, _controladorData);
          }
        },
        tooltip: 'Salvar Atividade',
        child: const Icon(Icons.done),
      ),
    );
  }

  void _selecionarData() async {
    DateTime? novaData = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Selecione uma data',
    );

    if (novaData != null) {
      setState(() {
        _controladorData.text =
            '${novaData.day}/${novaData.month}/${novaData.year}';
        debugPrint(_controladorData.text);
      });
    }
  }

  Widget buildChip(int index, QuerySnapshot data) {
    return ChoiceChip(
      tooltip: data.docs[index]['nome'],
      label: Text(data.docs[index]['nome']),
      selected: _disciplinaSelecionada == data.docs[index]['nome'],
      onSelected: (bool selected) {
        setState(() {
          _disciplinaSelecionada = selected ? data.docs[index]['nome'] : null;
          debugPrint(_disciplinaSelecionada);
        });
      },
    );
  }

  buildPanel() {
    return ExpansionPanelList(
      elevation: 3,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(registrarDisciplina),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyDisciplina,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditorTextFormField(
                      controller: _controladorNome,
                      maxLength: 50,
                      lines: 1,
                      labelText: 'Disciplina',
                      dica: 'Nome da disciplina',
                      validaCampo: true,
                      readOnly: false,
                      fieldIcon: const Icon(Icons.title_rounded)),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKeyDisciplina.currentState!.validate()) {
                          for (var element in vetDisciplinas) {
                            debugPrint('$element');
                          }
                          debugPrint(_controladorNome.text);

                          if (checkDisciplina(_controladorNome.text)) {
                            //SnackBar
                            const SnackBar snackBar = SnackBar(
                                content: Text(
                                    "Essa disciplina já foi cadastrada! "));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await disciplinaRef
                                .add({
                                  'nome': _controladorNome.text,
                                  'userId': auth.userId()
                                })
                                .then((value) =>
                                    debugPrint("Disciplina Adicionada"))
                                .catchError((error) => debugPrint(
                                    "Falha ao adicionar essa disciplina: $error"));

                            //Limpa o campo
                            _controladorNome.text = '';
                          }

                          //addDisciplina(disciplinaRef, _controladorNome, auth.userId());
                        }
                      },
                      child: const Text('Salvar'))
                ],
              ),
            ),
          ),
          isExpanded: isExpanded,
        ),
      ],
      expansionCallback: (int item, bool status) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
    );
  }

  bool checkDisciplina(String disciplinaRegistrada) {
    var log = 0;

    for (var element in vetDisciplinas) {
      if (element['nome'].toLowerCase() == disciplinaRegistrada.toLowerCase()) {
        log = 1;
      }
    }

    if (log == 1) {
      return true; // se existe
    } else {
      return false; // se não existe
    }
  }
}
