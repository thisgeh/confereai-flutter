import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/app_rotas.dart';
import '../models/banco.dart';
import '../models/estado_requisicao.dart';
import '../regras/filtros.dart';
import '../services/api_exception.dart';
import '../services/brasil_api_service.dart';
import '../widgets/estados.dart';


class BancosScreen extends StatefulWidget {
  const BancosScreen({super.key, this.api});

  final BrasilApiService? api;

  @override
  State<BancosScreen> createState() => _BancosScreenState();
}

class _BancosScreenState extends State<BancosScreen> {
  late final BrasilApiService _api = widget.api ?? BrasilApiService();
  final _buscaController = TextEditingController();

  EstadoRequisicao _estado = EstadoRequisicao.inicial;
  List<Banco> _bancos = [];
  String _mensagemErro = '';
  String _termo = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() => _estado = EstadoRequisicao.carregando);

    try {
      final bancos = await _api.listarBancos();
      if (!mounted) return;
      setState(() {
        _bancos = FiltroBancos.ordenar(bancos);
        _estado = EstadoRequisicao.sucesso;
      });
    } on ApiException catch (erro) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = erro.mensagem;
        _estado = EstadoRequisicao.erro;
      });
    }
  }

  void _limparBusca() {
    _buscaController.clear();
    setState(() => _termo = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar lista',
            icon: const Icon(Icons.refresh),
            onPressed:
                _estado == EstadoRequisicao.carregando ? null : _carregar,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: TextField(
                key: const Key('campo_busca_banco'),
                controller: _buscaController,
                onChanged: (valor) => setState(() => _termo = valor),
                decoration: InputDecoration(
                  labelText: 'Nome do banco ou números do boleto',
                  hintText: 'Ex.: 001 ou Caixa',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _termo.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpar busca',
                          icon: const Icon(Icons.clear),
                          onPressed: _limparBusca,
                        ),
                ),
              ),
            ),
            Expanded(child: _construirConteudo()),
          ],
        ),
      ),
    );
  }

  Widget _construirConteudo() {
    switch (_estado) {
      case EstadoRequisicao.inicial:
        return const Center(
          child: EstadoMensagem(
            icone: Icons.account_balance,
            titulo: 'Bancos do Brasil',
            mensagem: 'A lista oficial de bancos será carregada.',
          ),
        );
      case EstadoRequisicao.carregando:
        return const Center(
          child: EstadoCarregando(mensagem: 'Buscando bancos no Banco Central...'),
        );
      case EstadoRequisicao.erro:
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: EstadoErro(mensagem: _mensagemErro, onTentarNovamente: _carregar),
          ),
        );
      case EstadoRequisicao.sucesso:
        return _construirLista();
    }
  }

  Widget _construirLista() {
    final bancos = FiltroBancos.filtrar(_bancos, _termo);

    if (bancos.isEmpty) {
      return const Center(
        child: SingleChildScrollView(
          child: EstadoMensagem(
            icone: Icons.gpp_maybe_outlined,
            titulo: 'Nenhum banco encontrado',
            mensagem: 'Se esses são os primeiros números do seu boleto, '
                'desconfie: não existe banco com esse código.',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: bancos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, indice) {
          final banco = bancos[indice];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppCores.primaria,
                foregroundColor: Colors.white,
                child: Text(
                  banco.codigoFormatado,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              title: Text(
                banco.nome,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                banco.nomeCompleto,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right, size: 30),
              onTap: () => Navigator.pushNamed(
                context,
                AppRotas.bancoDetalhe,
                arguments: banco,
              ),
            ),
          );
        },
      ),
    );
  }
}
