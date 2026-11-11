import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../models/banco.dart';
import '../widgets/botao_ligar_contato.dart';
import '../widgets/linha_info.dart';


class BancoDetalheScreen extends StatelessWidget {
  const BancoDetalheScreen({super.key, required this.banco});

  final Banco banco;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do banco')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: AppCores.primaria,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Código do banco',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    Text(
                      banco.codigoFormatado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      banco.nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    LinhaInfo(
                      icone: Icons.account_balance,
                      rotulo: 'Nome completo',
                      valor: banco.nomeCompleto,
                    ),
                    LinhaInfo(
                      icone: Icons.numbers,
                      rotulo: 'ISPB (identificação no Banco Central)',
                      valor: banco.ispb,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: AppCores.fundoRiscoMedio,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long, color: AppCores.primaria),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Como conferir o boleto',
                              style: textos.titleMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Os 3 primeiros números da linha do boleto mostram o '
                      'banco. Se começar com ${banco.codigoFormatado}, o '
                      'boleto é do ${banco.nome}.',
                      style: textos.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Se disseram que o boleto é de um banco, mas o código é '
                      'de outro, desconfie e não pague.',
                      style: textos.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const BotaoLigarContato(),
          ],
        ),
      ),
    );
  }
}
