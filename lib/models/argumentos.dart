import 'empresa.dart';


class QuestionarioArgumentos {
  final Empresa? empresa;
  final String nomeInformado;

  const QuestionarioArgumentos({
    this.empresa,
    this.nomeInformado = '',
  });
}
