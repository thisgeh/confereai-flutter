import 'package:flutter/material.dart';


class CardOpcao extends StatelessWidget {
  const CardOpcao({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.onTap,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
  final Color cor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icone, color: cor, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: textos.titleMedium),
                    const SizedBox(height: 4),
                    Text(descricao, style: textos.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
