
class PerguntaGolpe {
  final String id;
  final String texto;
  final int pontos;
  final String motivo;

  const PerguntaGolpe({
    required this.id,
    required this.texto,
    required this.pontos,
    required this.motivo,
  });
}


class PerguntasGolpe {
  PerguntasGolpe._();

  static const List<PerguntaGolpe> todas = [
    PerguntaGolpe(
      id: 'senha',
      texto: 'Pediram a sua senha do banco ou do cartão?',
      pontos: 60,
      motivo: 'Nenhum banco ou empresa pede a sua senha. Quem pede é golpista.',
    ),
    PerguntaGolpe(
      id: 'codigo',
      texto: 'Pediram um código que chegou por SMS ou WhatsApp?',
      pontos: 40,
      motivo: 'Pedir o código do SMS é a forma mais comum de roubar o '
          'WhatsApp ou a conta do banco.',
    ),
    PerguntaGolpe(
      id: 'parente',
      texto: 'É um parente ou amigo dizendo que trocou de número?',
      pontos: 35,
      motivo: 'O golpe do "parente com número novo" é muito comum. Ligue '
          'para o número antigo da pessoa antes de qualquer coisa.',
    ),
    PerguntaGolpe(
      id: 'segredo',
      texto: 'Pediram para você não contar nada para a família?',
      pontos: 40,
      motivo: 'Golpistas pedem segredo para que ninguém avise que é golpe.',
    ),
    PerguntaGolpe(
      id: 'urgencia',
      texto: 'Disseram que é urgente ou que você vai perder algo se não '
          'agir agora?',
      pontos: 25,
      motivo: 'A pressa é uma armadilha: ela impede você de pensar e de '
          'pedir ajuda.',
    ),
    PerguntaGolpe(
      id: 'pix_pessoa',
      texto: 'Pediram um Pix para o nome de uma pessoa, e não da empresa?',
      pontos: 30,
      motivo: 'Empresas de verdade recebem no nome da própria empresa, '
          'não no nome de uma pessoa.',
    ),
    PerguntaGolpe(
      id: 'link',
      texto: 'Mandaram um link para clicar ou um aplicativo para instalar?',
      pontos: 30,
      motivo: 'Links e aplicativos enviados por mensagem podem roubar seus '
          'dados ou controlar o seu celular.',
    ),
    PerguntaGolpe(
      id: 'premio',
      texto: 'Falaram de prêmio, sorteio, dinheiro esquecido ou investimento '
          'que rende muito?',
      pontos: 30,
      motivo: 'Promessa de dinheiro fácil, que exige um pagamento antes, '
          'é golpe.',
    ),
  ];
}
