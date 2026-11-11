import 'package:flutter/material.dart';

import '../core/app_cores.dart';


class EstadoMensagem extends StatelessWidget {
  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
  });

  final IconData icone;
  final String titulo;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 72, color: AppCores.primaria.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(titulo, style: textos.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(mensagem, style: textos.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}


class EstadoCarregando extends StatelessWidget {
  const EstadoCarregando({super.key, this.mensagem = 'Carregando...'});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
          const SizedBox(height: 20),
          Text(
            mensagem,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class EstadoErro extends StatelessWidget {
  const EstadoErro({
    super.key,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  final String mensagem;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Card(
      color: AppCores.fundoRiscoAlto,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: AppCores.riscoAlto),
            const SizedBox(height: 12),
            Text('Algo deu errado', style: textos.titleLarge),
            const SizedBox(height: 8),
            Text(mensagem, style: textos.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
