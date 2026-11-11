import 'package:flutter/material.dart';

import '../app.dart';
import '../core/app_cores.dart';
import '../core/app_rotas.dart';
import '../models/argumentos.dart';
import '../widgets/botao_ligar_contato.dart';
import '../widgets/card_opcao.dart';
import '../widgets/logo_confereai.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  int _versao = 0;

  Future<void> _abrir(String rota, {Object? argumentos}) async {
    await Navigator.pushNamed(context, rota, arguments: argumentos);
    if (!mounted) return;
    setState(() => _versao++);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final app = ConfereAiApp.of(context);
    final letraGrande = app?.letraGrande ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ConfereAí'),
        actions: [
          IconButton(
            tooltip: letraGrande ? 'Diminuir letras' : 'Aumentar letras',
            icon: Icon(letraGrande ? Icons.text_decrease : Icons.text_increase),
            onPressed: () async {
              await app?.alternarTamanhoLetra();
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            tooltip: 'Como funciona',
            icon: const Icon(Icons.help_outline),
            onPressed: () => _abrir(AppRotas.onboarding, argumentos: true),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const LogoConfereAi(tamanho: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Olá!', style: textos.headlineSmall),
                      Text(
                        'O que você quer conferir hoje?',
                        style: textos.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CardOpcao(
              icone: Icons.business,
              cor: AppCores.primaria,
              titulo: 'Conferir quem está cobrando',
              descricao: 'Digite o CNPJ do boleto, do Pix ou da empresa '
                  'que ligou para você.',
              onTap: () => _abrir(AppRotas.conferirEmpresa),
            ),
            const SizedBox(height: 12),
            CardOpcao(
              icone: Icons.quiz_outlined,
              cor: AppCores.riscoAlto,
              titulo: 'Fazer o teste do golpe',
              descricao: 'Responda perguntas simples sobre a mensagem ou '
                  'ligação que você recebeu.',
              onTap: () => _abrir(
                AppRotas.questionario,
                argumentos: const QuestionarioArgumentos(),
              ),
            ),
            const SizedBox(height: 12),
            CardOpcao(
              icone: Icons.account_balance,
              cor: AppCores.secundaria,
              titulo: 'Conferir o banco do boleto',
              descricao: 'Veja se os 3 primeiros números do boleto são '
                  'de um banco de verdade.',
              onTap: () => _abrir(AppRotas.bancos),
            ),
            const SizedBox(height: 12),
            CardOpcao(
              icone: Icons.history,
              cor: AppCores.riscoMedio,
              titulo: 'Minhas consultas',
              descricao: 'Veja tudo o que você já conferiu.',
              onTap: () => _abrir(AppRotas.historico),
            ),
            const SizedBox(height: 12),
            CardOpcao(
              icone: Icons.contacts,
              cor: AppCores.ligar,
              titulo: 'Pessoas de confiança',
              descricao: 'Cadastre quem você quer chamar quando estiver '
                  'em dúvida.',
              onTap: () => _abrir(AppRotas.contatos),
            ),
            const SizedBox(height: 28),
            Text(
              'Está em dúvida agora?',
              style: textos.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            BotaoLigarContato(key: ValueKey(_versao)),
          ],
        ),
      ),
    );
  }
}
