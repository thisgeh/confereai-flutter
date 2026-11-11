import 'package:flutter/material.dart';

import '../core/app_rotas.dart';
import '../models/consulta.dart';
import '../regras/filtros.dart';
import '../repositories/historico_repository.dart';
import '../widgets/card_consulta.dart';
import '../widgets/estados.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key, this.repositorio});

  final HistoricoRepository? repositorio;

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  late final HistoricoRepository _repositorio =
      widget.repositorio ?? HistoricoRepository();

  bool _carregando = true;
  List<Consulta> _consultas = [];
  FiltroConsulta _filtro = FiltroConsulta.todas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final consultas = await _repositorio.listar();
    if (!mounted) return;
    setState(() {
      _consultas = consultas;
      _carregando = false;
    });
  }

  Future<void> _alternarConfiavel(Consulta consulta) async {
    final atualizada = consulta.copyWith(confiavel: !consulta.confiavel);
    await _repositorio.atualizar(atualizada);
    await _carregar();
  }

  Future<void> _abrirDetalhe(Consulta consulta) async {
    await Navigator.pushNamed(
      context,
      AppRotas.consultaDetalhe,
      arguments: consulta,
    );
    await _carregar();
  }

  Future<void> _limparHistorico() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar tudo?'),
        content: const Text(
          'Todas as consultas serão apagadas deste celular.',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;
    await _repositorio.limpar();
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final consultas = FiltroHistorico.filtrar(_consultas, _filtro);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas consultas'),
        actions: [
          if (_consultas.isNotEmpty)
            IconButton(
              tooltip: 'Apagar histórico',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _limparHistorico,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: FiltroConsulta.values.map((filtro) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filtro.rotulo,
                          style: const TextStyle(fontSize: 17)),
                      selected: _filtro == filtro,
                      onSelected: (_) => setState(() => _filtro = filtro),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(child: _construirLista(consultas)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(List<Consulta> consultas) {
    if (_carregando) {
      return const Center(child: EstadoCarregando());
    }

    if (consultas.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: EstadoMensagem(
            icone: Icons.history,
            titulo: _consultas.isEmpty
                ? 'Nenhuma consulta ainda'
                : 'Nada neste filtro',
            mensagem: _consultas.isEmpty
                ? 'Tudo o que você conferir vai aparecer aqui.'
                : 'Escolha outro filtro acima.',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: consultas.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, indice) {
          final consulta = consultas[indice];
          return CardConsulta(
            consulta: consulta,
            onTap: () => _abrirDetalhe(consulta),
            onAlternarConfiavel: () => _alternarConfiavel(consulta),
          );
        },
      ),
    );
  }
}
