import 'package:flutter/material.dart';

import '../core/nivel_risco_visual.dart';
import '../models/nivel_risco.dart';

/// Semáforo que mostra o nível de risco com cores e texto grande.
class SemaforoRisco extends StatelessWidget {
  const SemaforoRisco({
    super.key,
    required this.nivel,
    this.compacto = false,
  });

  final NivelRisco nivel;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    if (compacto) return _SeloRisco(nivel: nivel);

    final textos = Theme.of(context).textTheme;

    return Card(
      color: nivel.corFundo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: nivel.cor, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF263238),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: NivelRisco.values.reversed
                    .map((n) => _Luz(nivel: n, acesa: n == nivel))
                    .toList(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(nivel.icone, color: nivel.cor, size: 44),
                  const SizedBox(height: 8),
                  Text(
                    nivel.titulo,
                    style: textos.headlineSmall?.copyWith(color: nivel.cor),
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

class _Luz extends StatelessWidget {
  const _Luz({required this.nivel, required this.acesa});

  final NivelRisco nivel;
  final bool acesa;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: acesa ? nivel.cor : nivel.cor.withValues(alpha: 0.2),
        boxShadow: acesa
            ? [BoxShadow(color: nivel.cor, blurRadius: 12)]
            : const [],
      ),
    );
  }
}

class _SeloRisco extends StatelessWidget {
  const _SeloRisco({required this.nivel});

  final NivelRisco nivel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: nivel.corFundo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: nivel.cor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(nivel.icone, color: nivel.cor, size: 20),
          const SizedBox(width: 6),
          Text(
            nivel.titulo,
            style: TextStyle(
              color: nivel.cor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
