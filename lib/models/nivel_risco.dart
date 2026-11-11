
enum NivelRisco {
  baixo(
    titulo: 'Parece seguro',
    orientacao: 'Não encontramos sinais de golpe. Mesmo assim, confira o '
        'valor e o nome de quem vai receber antes de pagar.',
  ),
  medio(
    titulo: 'Atenção!',
    orientacao: 'Encontramos sinais suspeitos. Não pague agora. Ligue para '
        'uma pessoa de confiança ou para o número oficial da empresa.',
  ),
  alto(
    titulo: 'Pare! Pode ser golpe',
    orientacao: 'Não pague, não clique em links e não passe nenhum código. '
        'Desligue e converse com alguém de confiança.',
  );

  const NivelRisco({
    required this.titulo,
    required this.orientacao,
  });

  final String titulo;
  final String orientacao;
}
