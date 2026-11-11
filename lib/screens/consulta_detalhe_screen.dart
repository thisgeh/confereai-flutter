import 'package:flutter/material.dart';

import '../core/formatadores.dart';
import '../core/nivel_risco_visual.dart';
import '../models/consulta.dart';
import '../regras/validador_cnpj.dart';
import '../repositories/historico_repository.dart';
import '../widgets/botao_ligar_contato.dart';
import '../widgets/linha_info.dart';
import '../widgets/semaforo_risco.dart';


class ConsultaDetalheScreen extends StatefulWidget {
  const ConsultaDetalheScreen({
    super.key,
    required this.consulta,
    this.repositorio,
  });

  final Consulta consulta;
  final HistoricoRepository? repositorio;

  @override
  State<ConsultaDetalheScreen> createState() => _ConsultaDetalheScreenState();
}

class _ConsultaDetalheScreenState extends State<ConsultaDetalheScreen> {
  late final HistoricoRepository _repositorio =
      widget.repositorio ?? HistoricoRepository();
  late Consulta _consulta = widget.consulta;

  Future<void> _alternarConfiavel() async {
    final atualizada = _consulta.copyWith(confiavel: !_consulta.confiavel);
    await _repositorio.atualizar(atualizada);
    if (!mounted) return;
    setState(() => _consulta = atualizada);
  }

  Future<void> _apagar() async {
    await _repositorio.remover(_consulta.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe da consulta'),
        actions: [
          IconButton(
            tooltip: _consulta.confiavel
                ? 'Remover dos confiáveis'
                : 'Marcar como confiável',
            icon: Icon(_consulta.confiavel ? Icons.star : Icons.star_border),
            onPressed: _alternarConfiavel,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SemaforoRisco(nivel: _consulta.nivel),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    LinhaInfo(
                      icone: _consulta.tipo == TipoConsulta.empresa
                          ? Icons.business
                          : Icons.quiz_outlined,
                      rotulo: 'O que foi conferido',
                      valor: _consulta.titulo,
                    ),
                    if (_consulta.documento.isNotEmpty)
                      LinhaInfo(
                        icone: Icons.badge_outlined,
                        rotulo: 'CNPJ',
                        valor: ValidadorCnpj.formatar(_consulta.documento),
                      ),
                    LinhaInfo(
                      icone: Icons.event,
                      rotulo: 'Quando',
                      valor: Formatadores.dataHora(_consulta.data),
                    ),
                    LinhaInfo(
                      icone: Icons.star_outline,
                      rotulo: 'Marcado como confiável',
                      valor: _consulta.confiavel ? 'Sim' : 'Não',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Sinais encontrados', style: textos.titleLarge),
            const SizedBox(height: 8),
            if (_consulta.motivos.isEmpty)
              Text('Nenhum sinal de golpe encontrado.', style: textos.bodyMedium)
            else
              ..._consulta.motivos.map(
                (m) => LinhaMotivo(texto: m, cor: _consulta.nivel.cor),
              ),
            const SizedBox(height: 28),
            const BotaoLigarContato(),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _apagar,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Apagar esta consulta'),
            ),
          ],
        ),
      ),
    );
  }
}
