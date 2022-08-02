class ActivityArguments {
  final String? titulo;
  final String? data;
  final String? topicos;
  final String? docId;
  final String? disciplina;

  ActivityArguments(
      {this.titulo, this.data, this.topicos, this.docId, this.disciplina});
}

class DisciplinaArguments {
  final String nome;
  final String userId;

  DisciplinaArguments(this.nome, this.userId);
}