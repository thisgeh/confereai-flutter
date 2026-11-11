import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/formatadores.dart';
import '../models/contato_confianca.dart';
import '../repositories/contatos_repository.dart';
import '../services/ligacao_service.dart';
import '../widgets/estados.dart';

class ContatosScreen extends StatefulWidget {
  const ContatosScreen({
    super.key,
    this.repositorio,
    this.ligacaoService,
  });

  final ContatosRepository? repositorio;
  final LigacaoService? ligacaoService;

  @override
  State<ContatosScreen> createState() => _ContatosScreenState();
}

class _ContatosScreenState extends State<ContatosScreen> {
  late final ContatosRepository _repositorio =
      widget.repositorio ?? ContatosRepository();
  late final LigacaoService _ligacao = widget.ligacaoService ?? LigacaoService();

  bool _carregando = true;
  List<ContatoConfianca> _contatos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final contatos = await _repositorio.listar();
    if (!mounted) return;
    setState(() {
      _contatos = contatos;
      _carregando = false;
    });
  }

  Future<void> _adicionar() async {
    final contato = await showDialog<ContatoConfianca>(
      context: context,
      builder: (_) => const _DialogoNovoContato(),
    );
    if (contato == null) return;

    await _repositorio.adicionar(contato);
    await _carregar();
  }

  Future<void> _remover(ContatoConfianca contato) async {
    await _repositorio.remover(contato.id);
    await _carregar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${contato.nome} foi removido.')),
    );
  }

  Future<void> _definirPrincipal(ContatoConfianca contato) async {
    await _repositorio.definirPrincipal(contato.id);
    await _carregar();
  }

  Future<void> _ligar(ContatoConfianca contato) async {
    final abriu = await _ligacao.ligar(contato.telefone);
    if (!mounted || abriu) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ligue para ${contato.telefone}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pessoas de confiança')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionar,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Adicionar', style: TextStyle(fontSize: 18)),
      ),
      body: SafeArea(child: _construirConteudo()),
    );
  }

  Widget _construirConteudo() {
    if (_carregando) return const Center(child: EstadoCarregando());

    if (_contatos.isEmpty) {
      return const Center(
        child: SingleChildScrollView(
          child: EstadoMensagem(
            icone: Icons.people_outline,
            titulo: 'Ninguém cadastrado ainda',
            mensagem: 'Toque em "Adicionar" e cadastre um filho, neto ou '
                'amigo para ligar quando estiver em dúvida.',
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: _contatos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, indice) {
        final contato = _contatos[indice];
        final principal = indice == 0;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: principal
                ? const BorderSide(color: AppCores.ligar, width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppCores.ligar,
                      foregroundColor: Colors.white,
                      child: Text(
                        contato.inicial,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contato.nome,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(contato.telefone,
                              style: Theme.of(context).textTheme.bodyMedium),
                          if (principal)
                            const Text(
                              'Contato principal',
                              style: TextStyle(
                                color: AppCores.ligar,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!principal)
                      IconButton(
                        tooltip: 'Tornar principal',
                        iconSize: 30,
                        icon: const Icon(Icons.star_border),
                        onPressed: () => _definirPrincipal(contato),
                      ),
                    IconButton(
                      tooltip: 'Remover',
                      iconSize: 30,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _remover(contato),
                    ),
                    IconButton.filled(
                      tooltip: 'Ligar',
                      iconSize: 30,
                      style: IconButton.styleFrom(
                        backgroundColor: AppCores.ligar,
                      ),
                      icon: const Icon(Icons.call),
                      onPressed: () => _ligar(contato),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _DialogoNovoContato extends StatefulWidget {
  const _DialogoNovoContato();

  @override
  State<_DialogoNovoContato> createState() => _DialogoNovoContatoState();
}

class _DialogoNovoContatoState extends State<_DialogoNovoContato> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(
      context,
      ContatoConfianca(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova pessoa de confiança'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Digite o nome.'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone com DDD',
                  hintText: '(11) 91234-5678',
                ),
                validator: (valor) {
                  final numeros = Formatadores.somenteNumeros(valor ?? '');
                  if (numeros.length < 10 || numeros.length > 13) {
                    return 'Digite o telefone com DDD.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
