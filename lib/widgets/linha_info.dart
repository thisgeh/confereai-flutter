import 'package:flutter/material.dart';

import '../core/app_cores.dart';


class LinhaInfo extends StatelessWidget {
  const LinhaInfo({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: AppCores.primaria, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo, style: textos.bodySmall),
                Text(
                  valor.isEmpty ? 'Não informado' : valor,
                  style: textos.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class LinhaMotivo extends StatelessWidget {
  const LinhaMotivo({super.key, required this.texto, required this.cor});

  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.report, color: cor, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
