import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/formatadores.dart';
import '../models/consulta.dart';
import '../regras/validador_cnpj.dart';
import 'semaforo_risco.dart';


class CardConsulta extends StatelessWidget {
  const CardConsulta({
    super.key,
    required this.consulta,
    required this.onTap,
    required this.onAlternarConfiavel,
  });

  final Consulta consulta;
  final VoidCallback onTap;
  final VoidCallback onAlternarConfiavel;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
          child: Row(
            children: [
              Icon(
                consulta.tipo == TipoConsulta.empresa
                    ? Icons.business
                    : Icons.quiz_outlined,
                size: 34,
                color: AppCores.primaria,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(consulta.titulo, style: textos.titleMedium),
                    if (consulta.documento.isNotEmpty)
                      Text(
                        ValidadorCnpj.formatar(consulta.documento),
                        style: textos.bodySmall,
                      ),
                    Text(
                      Formatadores.dataHora(consulta.data),
                      style: textos.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    SemaforoRisco(nivel: consulta.nivel, compacto: true),
                  ],
                ),
              ),
              IconButton(
                iconSize: 32,
                tooltip: consulta.confiavel
                    ? 'Remover dos confiáveis'
                    : 'Marcar como confiável',
                onPressed: onAlternarConfiavel,
                icon: Icon(
                  consulta.confiavel ? Icons.star : Icons.star_border,
                  color: consulta.confiavel ? AppCores.riscoMedio : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
