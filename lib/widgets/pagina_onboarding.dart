import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../models/pagina_onboarding.dart';


class PaginaOnboarding extends StatelessWidget {
  const PaginaOnboarding({super.key, required this.dados});

  final PaginaOnboardingDados dados;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        children: [
          Image.asset(
            dados.imagem,
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 28),
          Text(
            dados.titulo,
            style: textos.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            dados.descricao,
            style: textos.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class IndicadorPaginas extends StatelessWidget {
  const IndicadorPaginas({
    super.key,
    required this.total,
    required this.atual,
  });

  final int total;
  final int atual;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final ativa = i == atual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: ativa ? 28 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: ativa ? AppCores.primaria : AppCores.primaria.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
