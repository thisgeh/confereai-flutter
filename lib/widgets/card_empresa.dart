import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/formatadores.dart';
import '../models/empresa.dart';
import '../regras/validador_cnpj.dart';
import 'linha_info.dart';


class CardEmpresa extends StatelessWidget {
  const CardEmpresa({super.key, required this.empresa});

  final Empresa empresa;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final abertura = empresa.dataInicioAtividade;
    final corSituacao = empresa.ativa ? AppCores.riscoBaixo : AppCores.riscoAlto;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(empresa.nomeExibicao, style: textos.titleLarge),
            if (empresa.nomeFantasia.isNotEmpty &&
                empresa.nomeFantasia != empresa.razaoSocial) ...[
              const SizedBox(height: 4),
              Text(empresa.razaoSocial, style: textos.bodySmall),
            ],
            const SizedBox(height: 12),
            Chip(
              avatar: Icon(
                empresa.ativa ? Icons.verified : Icons.block,
                color: corSituacao,
              ),
              label: Text(
                'Situação: ${empresa.situacao}',
                style: TextStyle(
                  color: corSituacao,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              backgroundColor: corSituacao.withValues(alpha: 0.1),
              side: BorderSide(color: corSituacao),
            ),
            const Divider(height: 28),
            LinhaInfo(
              icone: Icons.badge_outlined,
              rotulo: 'CNPJ',
              valor: ValidadorCnpj.formatar(empresa.cnpj),
            ),
            LinhaInfo(
              icone: Icons.calendar_month,
              rotulo: 'Aberta em',
              valor: abertura == null
                  ? ''
                  : '${Formatadores.data(abertura)} '
                      '(${Formatadores.tempoDesde(abertura, DateTime.now())})',
            ),
            LinhaInfo(
              icone: Icons.location_on_outlined,
              rotulo: 'Cidade',
              valor: empresa.cidade,
            ),
            LinhaInfo(
              icone: Icons.work_outline,
              rotulo: 'O que a empresa faz',
              valor: empresa.atividadePrincipal,
            ),
            LinhaInfo(
              icone: Icons.phone_outlined,
              rotulo: 'Telefone registrado na Receita',
              valor: empresa.telefone,
            ),
          ],
        ),
      ),
    );
  }
}
