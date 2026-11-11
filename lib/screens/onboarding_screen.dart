import 'package:flutter/material.dart';

import '../core/app_rotas.dart';
import '../models/pagina_onboarding.dart';
import '../repositories/preferencias_repository.dart';
import '../widgets/pagina_onboarding.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.abertoPelaHome = false,
    this.repositorio,
  });

  
  final bool abertoPelaHome;
  final PreferenciasRepository? repositorio;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const paginas = [
    PaginaOnboardingDados(
      imagem: 'assets/images/onboarding_golpe.png',
      titulo: 'Golpistas fingem ser quem você confia',
      descricao: 'Eles se passam pelo banco, por uma loja ou até por um '
          'parente. A conversa parece verdadeira e sempre tem muita pressa.',
    ),
    PaginaOnboardingDados(
      imagem: 'assets/images/onboarding_confere.png',
      titulo: 'Antes de pagar, confere aí',
      descricao: 'Digite o CNPJ de quem está cobrando e responda perguntas '
          'simples. O ConfereAí mostra o risco com as cores do semáforo.',
    ),
    PaginaOnboardingDados(
      imagem: 'assets/images/onboarding_contato.png',
      titulo: 'Na dúvida, ligue para quem você confia',
      descricao: 'Cadastre um filho, neto ou amigo. Com um toque você liga '
          'para essa pessoa antes de tomar qualquer decisão.',
    ),
  ];

  final _controller = PageController();
  late final PreferenciasRepository _repositorio =
      widget.repositorio ?? PreferenciasRepository();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  bool get _ultimaPagina => _paginaAtual == paginas.length - 1;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  Future<void> _carregarPreferencia() async {
    final visto = await _repositorio.onboardingVisto();
    if (!mounted) return;
    setState(() => _naoMostrarNovamente = visto);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _avancar() {
    if (_ultimaPagina) {
      _finalizar();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _voltar() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizar() async {
    // Respeita a opção marcada pelo usuário.
    await _repositorio.salvarOnboardingVisto(_naoMostrarNovamente);
    if (!mounted) return;

    if (widget.abertoPelaHome) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRotas.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finalizar,
                child: const Text('Pular'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: paginas.length,
                onPageChanged: (pagina) => setState(() => _paginaAtual = pagina),
                itemBuilder: (context, indice) =>
                    PaginaOnboarding(dados: paginas[indice]),
              ),
            ),
            IndicadorPaginas(total: paginas.length, atual: _paginaAtual),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CheckboxListTile(
                value: _naoMostrarNovamente,
                onChanged: (valor) =>
                    setState(() => _naoMostrarNovamente = valor ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Não mostrar novamente',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _paginaAtual == 0 ? null : _voltar,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _avancar,
                      icon: Icon(_ultimaPagina ? Icons.check : Icons.arrow_forward),
                      label: Text(_ultimaPagina ? 'Começar' : 'Avançar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
