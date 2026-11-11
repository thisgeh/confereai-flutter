import 'package:confereai/models/avaliacao.dart';
import 'package:confereai/models/empresa.dart';
import 'package:confereai/models/nivel_risco.dart';
import 'package:confereai/regras/avaliador_risco.dart';
import 'package:confereai/regras/regras_risco/regra_empresa_recente.dart';
import 'package:confereai/regras/regras_risco/regra_nome_divergente.dart';
import 'package:confereai/regras/regras_risco/regra_perguntas_golpe.dart';
import 'package:confereai/regras/regras_risco/regra_risco.dart';
import 'package:confereai/regras/regras_risco/regra_situacao_cadastral.dart';
import 'package:flutter_test/flutter_test.dart';

class RegraFake implements RegraRisco {
  RegraFake(this.pontos);

  final int pontos;

  @override
  List<SinalRisco> avaliar(ContextoAvaliacao contexto) {
    return [SinalRisco(pontos: pontos, motivo: 'motivo $pontos')];
  }
}

void main() {
  final hoje = DateTime(2026, 11, 9);

  Empresa criarEmpresa({
    String situacao = 'ATIVA',
    DateTime? abertura,
    String razaoSocial = 'BANCO DO BRASIL SA',
    String nomeFantasia = 'DIRECAO GERAL',
  }) {
    return Empresa(
      cnpj: '00000000000191',
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      situacao: situacao,
      dataInicioAtividade: abertura ?? DateTime(1966, 8, 1),
    );
  }

  group('AvaliadorRisco.classificar', () {
    test('menos de 30 pontos é risco baixo', () {
      expect(AvaliadorRisco.classificar(29), NivelRisco.baixo);
    });

    test('30 pontos é risco médio', () {
      expect(AvaliadorRisco.classificar(30), NivelRisco.medio);
    });

    test('59 pontos ainda é risco médio', () {
      expect(AvaliadorRisco.classificar(59), NivelRisco.medio);
    });

    test('60 pontos é risco alto', () {
      expect(AvaliadorRisco.classificar(60), NivelRisco.alto);
    });
  });

  group('AvaliadorRisco.avaliar', () {
    test('deve somar os pontos de todas as regras', () {
      // Arrange
      final avaliador = AvaliadorRisco([RegraFake(10), RegraFake(25)]);

      // Act
      final resultado = avaliador.avaliar(ContextoAvaliacao());

      // Assert
      expect(resultado.pontuacao, 35);
      expect(resultado.nivel, NivelRisco.medio);
    });

    test('motivos devem vir do mais grave para o menos grave', () {
      final avaliador = AvaliadorRisco([RegraFake(10), RegraFake(40)]);

      final resultado = avaliador.avaliar(ContextoAvaliacao());

      expect(resultado.motivos, ['motivo 40', 'motivo 10']);
    });

    test('sem regras o risco é baixo', () {
      final resultado = AvaliadorRisco([]).avaliar(ContextoAvaliacao());

      expect(resultado.nivel, NivelRisco.baixo);
      expect(resultado.motivos, isEmpty);
    });

    test('empresa ativa e antiga, sem respostas "Sim", é risco baixo', () {
      final resultado = AvaliadorRisco.padrao().avaliar(
        ContextoAvaliacao(empresa: criarEmpresa(), dataReferencia: hoje),
      );

      expect(resultado.nivel, NivelRisco.baixo);
    });

    test('empresa baixada é sempre risco alto', () {
      final resultado = AvaliadorRisco.padrao().avaliar(
        ContextoAvaliacao(
          empresa: criarEmpresa(situacao: 'BAIXADA'),
          dataReferencia: hoje,
        ),
      );

      expect(resultado.nivel, NivelRisco.alto);
    });

    test('pedir a senha é sempre risco alto', () {
      final resultado = AvaliadorRisco.padrao().avaliar(
        ContextoAvaliacao(respostasSim: {'senha'}),
      );

      expect(resultado.nivel, NivelRisco.alto);
    });
  });

  group('RegraSituacaoCadastral', () {
    late RegraSituacaoCadastral regra;

    setUp(() {
      regra = RegraSituacaoCadastral();
    });

    test('empresa ativa não gera alerta', () {
      final sinais = regra.avaliar(ContextoAvaliacao(empresa: criarEmpresa()));
      expect(sinais, isEmpty);
    });

    test('empresa inapta gera alerta de 100 pontos', () {
      final sinais = regra.avaliar(
        ContextoAvaliacao(empresa: criarEmpresa(situacao: 'INAPTA')),
      );

      expect(sinais.single.pontos, RegraSituacaoCadastral.pontos);
      expect(sinais.single.motivo, contains('INAPTA'));
    });

    test('sem empresa não gera alerta', () {
      expect(regra.avaliar(ContextoAvaliacao()), isEmpty);
    });
  });

  group('RegraEmpresaRecente', () {
    late RegraEmpresaRecente regra;

    setUp(() {
      regra = RegraEmpresaRecente();
    });

    test('empresa aberta há 20 dias gera 40 pontos', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(abertura: hoje.subtract(const Duration(days: 20))),
        dataReferencia: hoje,
      ));

      expect(sinais.single.pontos, RegraEmpresaRecente.pontosMuitoRecente);
    });

    test('empresa aberta há 200 dias gera 20 pontos', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(abertura: hoje.subtract(const Duration(days: 200))),
        dataReferencia: hoje,
      ));

      expect(sinais.single.pontos, RegraEmpresaRecente.pontosRecente);
    });

    test('caso de borda: exatamente 365 dias não gera alerta', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(abertura: hoje.subtract(const Duration(days: 365))),
        dataReferencia: hoje,
      ));

      expect(sinais, isEmpty);
    });
  });

  group('RegraNomeDivergente', () {
    late RegraNomeDivergente regra;

    setUp(() {
      regra = RegraNomeDivergente();
    });

    test('nome igual ao da empresa não gera alerta', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(),
        nomeInformado: 'Banco do Brasil',
      ));

      expect(sinais, isEmpty);
    });

    test('nome com acento e letras minúsculas também é aceito', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(razaoSocial: 'ITAU UNIBANCO S.A.', nomeFantasia: ''),
        nomeInformado: 'itaú',
      ));

      expect(sinais, isEmpty);
    });

    test('nome diferente do dono do CNPJ gera alerta', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(
          razaoSocial: 'JOAO DA SILVA SERVICOS LTDA',
          nomeFantasia: '',
        ),
        nomeInformado: 'Banco do Brasil',
      ));

      expect(sinais.single.pontos, RegraNomeDivergente.pontos);
    });

    test('"Banco do Brasil" não pode ser confundido com outro banco', () {
      final sinais = regra.avaliar(ContextoAvaliacao(
        empresa: criarEmpresa(razaoSocial: 'BANCO BRADESCO S.A.', nomeFantasia: ''),
        nomeInformado: 'Banco do Brasil',
      ));

      expect(sinais, isNotEmpty);
    });

    test('nome não informado não gera alerta', () {
      final sinais = regra.avaliar(ContextoAvaliacao(empresa: criarEmpresa()));
      expect(sinais, isEmpty);
    });
  });

  group('RegraPerguntasGolpe', () {
    test('cada resposta "Sim" gera um alerta', () {
      final sinais = RegraPerguntasGolpe().avaliar(
        ContextoAvaliacao(respostasSim: {'codigo', 'urgencia'}),
      );

      expect(sinais.length, 2);
      expect(sinais.fold<int>(0, (t, s) => t + s.pontos), 65);
    });

    test('sem respostas "Sim" não gera alerta', () {
      expect(RegraPerguntasGolpe().avaliar(ContextoAvaliacao()), isEmpty);
    });
  });
}
