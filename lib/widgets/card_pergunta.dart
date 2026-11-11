import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../models/pergunta_golpe.dart';


class CardPergunta extends StatelessWidget {
  const CardPergunta({
    super.key,
    required this.numero,
    required this.pergunta,
    required this.resposta,
    required this.onResponder,
  });

  final int numero;
  final PerguntaGolpe pergunta;

 
  final bool? resposta;
  final ValueChanged<bool> onResponder;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    final Color fundo;
    final Color borda;
    if (resposta == true) {
      fundo = AppCores.fundoRiscoAlto;
      borda = AppCores.riscoAlto;
    } else if (resposta == false) {
      fundo = AppCores.fundoRiscoBaixo;
      borda = AppCores.riscoBaixo;
    } else {
      fundo = Colors.white;
      borda = Colors.transparent;
    }

    return Card(
      color: fundo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borda, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pergunta $numero', style: textos.bodySmall),
            const SizedBox(height: 4),
            Text(pergunta.texto, style: textos.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BotaoResposta(
                    texto: 'Sim',
                    icone: Icons.thumb_up_alt_outlined,
                    selecionado: resposta == true,
                    cor: AppCores.riscoAlto,
                    onPressed: () => onResponder(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BotaoResposta(
                    texto: 'Não',
                    icone: Icons.thumb_down_alt_outlined,
                    selecionado: resposta == false,
                    cor: AppCores.riscoBaixo,
                    onPressed: () => onResponder(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoResposta extends StatelessWidget {
  const _BotaoResposta({
    required this.texto,
    required this.icone,
    required this.selecionado,
    required this.cor,
    required this.onPressed,
  });

  final String texto;
  final IconData icone;
  final bool selecionado;
  final Color cor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (selecionado) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: cor),
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: Text(texto),
      );
    }

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: cor,
        side: BorderSide(color: cor, width: 2),
      ),
      onPressed: onPressed,
      icon: Icon(icone),
      label: Text(texto),
    );
  }
}
