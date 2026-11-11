import 'package:flutter/material.dart';

import '../core/app_rotas.dart';
import '../core/nivel_risco_visual.dart';
import '../models/avaliacao.dart';
import '../models/consulta.dart';
import '../models/nivel_risco.dart';
import '../regras/avaliador_risco.dart';
import '../repositories/historico_repository.dart';
import '../widgets/botao_ligar_contato.dart';
import '../widgets/card_empresa.dart';
import '../widgets/linha_info.dart';
import '../widgets/semaforo_risco.dart';


class ResultadoScreen extends StatefulWidget {
  const ResultadoScreen({
    super.key,
    required this.contexto,
    this.avaliador,
    this.historico,
  });

  final ContextoAvaliacao contexto;
  final AvaliadorRisco? avaliador;
  final HistoricoRepository? historico;

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  late final HistoricoRepository _historico =
      widget.historico ?? HistoricoRepository();
  late final ResultadoAvaliacao _resultado;
  Consulta? _consulta;

  @override
  void initState() {
    super.initState();
    _resultado = (widget.avaliador ?? AvaliadorRisco.padrao())
        .avaliar(widget.contexto);
    _salvarNoHistorico();
  }

  Future<void> _salvarNoHistorico() async {
    final consulta = Consulta.criar(
      contexto: widget.contexto,
      resultado: _resultado,
    );
    await _historico.adicionar(consulta);
    if (!mounted) return;
    setState(() => _consulta = consulta);
  }

  Future<void> _alternarConfiavel() async {
    final atual = _consulta;
    if (atual == null) return;

    final atualizada = atual.copyWith(confiavel: !atual.confiavel);
    await _historico.atualizar(atualizada);
    if (!mounted) return;

    setState(() => _consulta = atualizada);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          atualizada.confiavel
              ? 'Marcado como confiável no seu histórico.'
              : 'Removido dos confiáveis.',
        ),
      ),
    );
  }

  void _voltarAoInicio() {
    Navigator.popUntil(
      context,
      (rota) => rota.settings.name == AppRotas.home || rota.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final nivel = _resultado.nivel;
    final empresa = widget.contexto.empresa;
    final consulta = _consulta;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SemaforoRisco(nivel: nivel),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: nivel.cor, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(nivel.orientacao, style: textos.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Por que chegamos nesse resultado', style: textos.titleLarge),
            const SizedBox(height: 8),
            if (_resultado.motivos.isEmpty)
              Text(
                'Não encontramos sinais de golpe nas informações que você deu.',
                style: textos.bodyMedium,
              )
            else
              ..._resultado.motivos.map(
                (motivo) => LinhaMotivo(texto: motivo, cor: nivel.cor),
              ),
            if (empresa != null) ...[
              const SizedBox(height: 24),
              Text('Dados da empresa', style: textos.titleLarge),
              const SizedBox(height: 8),
              CardEmpresa(empresa: empresa),
            ],
            const SizedBox(height: 28),
            const BotaoLigarContato(),
            // Não oferecemos "confiável" quando o risco é alto.
            if (consulta != null && nivel != NivelRisco.alto) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _alternarConfiavel,
                icon: Icon(consulta.confiavel ? Icons.star : Icons.star_border),
                label: Text(
                  consulta.confiavel
                      ? 'Marcado como confiável'
                      : 'Marcar como confiável',
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _voltarAoInicio,
              icon: const Icon(Icons.home_outlined),
              label: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
