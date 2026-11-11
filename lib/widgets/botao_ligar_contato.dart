import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/app_rotas.dart';
import '../models/contato_confianca.dart';
import '../repositories/contatos_repository.dart';
import '../services/ligacao_service.dart';


class BotaoLigarContato extends StatefulWidget {
  const BotaoLigarContato({
    super.key,
    this.repositorio,
    this.ligacaoService,
  });

  final ContatosRepository? repositorio;
  final LigacaoService? ligacaoService;

  @override
  State<BotaoLigarContato> createState() => _BotaoLigarContatoState();
}

class _BotaoLigarContatoState extends State<BotaoLigarContato> {
  late final ContatosRepository _repositorio =
      widget.repositorio ?? ContatosRepository();
  late final LigacaoService _ligacao = widget.ligacaoService ?? LigacaoService();

  ContatoConfianca? _contato;

  @override
  void initState() {
    super.initState();
    _carregarContato();
  }

  Future<void> _carregarContato() async {
    final contato = await _repositorio.principal();
    if (!mounted) return;
    setState(() => _contato = contato);
  }

  Future<void> _aoTocar() async {
    final contato = _contato;

    if (contato == null) {
      await Navigator.pushNamed(context, AppRotas.contatos);
      await _carregarContato();
      return;
    }

    final abriu = await _ligacao.ligar(contato.telefone);
    if (!mounted || abriu) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Não conseguimos abrir o telefone. '
          'Ligue para ${contato.nome}: ${contato.telefone}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contato = _contato;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCores.ligar,
        minimumSize: const Size.fromHeight(72),
      ),
      onPressed: _aoTocar,
      icon: Icon(contato == null ? Icons.person_add_alt_1 : Icons.call, size: 30),
      label: Text(
        contato == null
            ? 'Cadastrar pessoa de confiança'
            : 'Ligar para ${contato.nome}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
