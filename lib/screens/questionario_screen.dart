import 'package:flutter/material.dart';

import '../core/app_rotas.dart';
import '../models/argumentos.dart';
import '../models/avaliacao.dart';
import '../models/pergunta_golpe.dart';
import '../widgets/card_pergunta.dart';


class QuestionarioScreen extends StatefulWidget {
  const QuestionarioScreen({
    super.key,
    this.argumentos = const QuestionarioArgumentos(),
  });

  final QuestionarioArgumentos argumentos;

  @override
  State<QuestionarioScreen> createState() => _QuestionarioScreenState();
}

class _QuestionarioScreenState extends State<QuestionarioScreen> {
  final List<PerguntaGolpe> _perguntas = PerguntasGolpe.todas;
  final Map<String, bool> _respostas = {};

  void _responder(String id, bool resposta) {
    setState(() => _respostas[id] = resposta);
  }

  void _verResultado() {
    final respostasSim = _respostas.entries
        .where((resposta) => resposta.value)
        .map((resposta) => resposta.key)
        .toSet();

    Navigator.pushNamed(
      context,
      AppRotas.resultado,
      arguments: ContextoAvaliacao(
        empresa: widget.argumentos.empresa,
        nomeInformado: widget.argumentos.nomeInformado,
        respostasSim: respostasSim,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final empresa = widget.argumentos.empresa;

    return Scaffold(
      appBar: AppBar(title: const Text('Teste do golpe')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _perguntas.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, indice) {
            if (indice == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (empresa != null) ...[
                    Text('Conferindo: ${empresa.nomeExibicao}',
                        style: textos.titleMedium),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    'Pense na mensagem, ligação ou cobrança que você recebeu '
                    'e responda com calma:',
                    style: textos.bodyLarge,
                  ),
                ],
              );
            }

            final pergunta = _perguntas[indice - 1];
            return CardPergunta(
              numero: indice,
              pergunta: pergunta,
              resposta: _respostas[pergunta.id],
              onResponder: (resposta) => _responder(pergunta.id, resposta),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_respostas.length} de ${_perguntas.length} respondidas',
                style: textos.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _verResultado,
                icon: const Icon(Icons.traffic),
                label: const Text('Ver o resultado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
