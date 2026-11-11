import 'package:flutter/material.dart';

import '../core/app_rotas.dart';
import '../models/argumentos.dart';
import '../models/avaliacao.dart';
import '../models/empresa.dart';
import '../models/estado_requisicao.dart';
import '../regras/validador_cnpj.dart';
import '../services/api_exception.dart';
import '../services/brasil_api_service.dart';
import '../widgets/card_empresa.dart';
import '../widgets/cnpj_input_formatter.dart';
import '../widgets/estados.dart';


class ConferirEmpresaScreen extends StatefulWidget {
  const ConferirEmpresaScreen({super.key, this.api});

  final BrasilApiService? api;

  @override
  State<ConferirEmpresaScreen> createState() => _ConferirEmpresaScreenState();
}

class _ConferirEmpresaScreenState extends State<ConferirEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  final _nomeController = TextEditingController();
  late final BrasilApiService _api = widget.api ?? BrasilApiService();

  EstadoRequisicao _estado = EstadoRequisicao.inicial;
  Empresa? _empresa;
  String _mensagemErro = '';

  @override
  void dispose() {
    _cnpjController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _conferir() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _estado = EstadoRequisicao.carregando);

    try {
      final empresa = await _api.buscarEmpresa(_cnpjController.text);
      if (!mounted) return;
      setState(() {
        _empresa = empresa;
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

  void _fazerTeste() {
    Navigator.pushNamed(
      context,
      AppRotas.questionario,
      arguments: QuestionarioArgumentos(
        empresa: _empresa,
        nomeInformado: _nomeController.text,
      ),
    );
  }

  void _verResultado() {
    Navigator.pushNamed(
      context,
      AppRotas.resultado,
      arguments: ContextoAvaliacao(
        empresa: _empresa,
        nomeInformado: _nomeController.text,
      ),
    );
  }

  String? _validarCnpj(String? valor) {
    final texto = valor ?? '';
    if (ValidadorCnpj.limpar(texto).isEmpty) {
      return 'Digite o CNPJ.';
    }
    if (!ValidadorCnpj.valido(texto)) {
      return 'Esse CNPJ não é válido. Confira os números.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Conferir empresa')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const Key('campo_cnpj'),
                    controller: _cnpjController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CnpjInputFormatter()],
                    style: const TextStyle(fontSize: 22, letterSpacing: 1),
                    decoration: const InputDecoration(
                      labelText: 'CNPJ de quem está cobrando',
                      hintText: '00.000.000/0000-00',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: _validarCnpj,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('campo_nome'),
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Quem disseram que era? (opcional)',
                      hintText: 'Ex.: Banco do Brasil',
                      prefixIcon: Icon(Icons.record_voice_over_outlined),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dica: o CNPJ aparece no boleto, no comprovante do Pix '
                    'ou no site da empresa.',
                    style: textos.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed:
                        _estado == EstadoRequisicao.carregando ? null : _conferir,
                    icon: const Icon(Icons.search),
                    label: const Text('Conferir agora'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _construirConteudo(),
          ],
        ),
      ),
    );
  }

  Widget _construirConteudo() {
    switch (_estado) {
      case EstadoRequisicao.inicial:
        return const EstadoMensagem(
          icone: Icons.manage_search,
          titulo: 'Pronto para conferir',
          mensagem: 'Digite o CNPJ acima e toque em "Conferir agora". '
              'Vamos buscar os dados na Receita Federal.',
        );
      case EstadoRequisicao.carregando:
        return const EstadoCarregando(
          mensagem: 'Consultando a Receita Federal...',
        );
      case EstadoRequisicao.erro:
        return EstadoErro(
          mensagem: _mensagemErro,
          onTentarNovamente: _conferir,
        );
      case EstadoRequisicao.sucesso:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardEmpresa(empresa: _empresa!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fazerTeste,
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('Responder o teste do golpe'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _verResultado,
              icon: const Icon(Icons.traffic_outlined),
              label: const Text('Ver o resultado agora'),
            ),
          ],
        );
    }
  }
}
