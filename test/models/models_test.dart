import 'package:confereai/models/avaliacao.dart';
import 'package:confereai/models/banco.dart';
import 'package:confereai/models/consulta.dart';
import 'package:confereai/models/empresa.dart';
import 'package:confereai/models/nivel_risco.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Empresa.fromJson', () {
    test('deve converter o JSON da BrasilAPI', () {
      final empresa = Empresa.fromJson({
        'cnpj': '19131243000197',
        'razao_social': 'OPEN KNOWLEDGE BRASIL',
        'nome_fantasia': 'REDE PELO CONHECIMENTO LIVRE',
        'descricao_situacao_cadastral': 'ATIVA',
        'data_inicio_atividade': '2013-10-03',
        'municipio': 'SAO PAULO',
        'uf': 'SP',
        'cnae_fiscal_descricao': 'Atividades de associações',
        'ddd_telefone_1': '1123851939',
        'capital_social': 0,
      });

      expect(empresa.razaoSocial, 'OPEN KNOWLEDGE BRASIL');
      expect(empresa.nomeExibicao, 'REDE PELO CONHECIMENTO LIVRE');
      expect(empresa.ativa, isTrue);
      expect(empresa.dataInicioAtividade, DateTime(2013, 10, 3));
      expect(empresa.cidade, 'SAO PAULO - SP');
    });

    test('campos nulos não podem quebrar a conversão', () {
      final empresa = Empresa.fromJson({
        'cnpj': '19131243000197',
        'razao_social': 'EMPRESA X',
        'nome_fantasia': null,
        'descricao_situacao_cadastral': null,
        'data_inicio_atividade': null,
      });

      expect(empresa.nomeExibicao, 'EMPRESA X');
      expect(empresa.situacao, 'DESCONHECIDA');
      expect(empresa.ativa, isFalse);
      expect(empresa.dataInicioAtividade, isNull);
    });
  });

  group('Banco.fromJson', () {
    test('deve converter o JSON da BrasilAPI', () {
      final banco = Banco.fromJson({
        'ispb': '00000000',
        'name': 'BCO DO BRASIL S.A.',
        'code': 1,
        'fullName': 'Banco do Brasil S.A.',
      });

      expect(banco.codigo, 1);
      expect(banco.codigoFormatado, '001');
    });

    test('código nulo deve virar "---"', () {
      final banco = Banco.fromJson({'ispb': '1', 'name': 'X', 'code': null});
      expect(banco.codigoFormatado, '---');
    });
  });

  group('Consulta', () {
    test('toJson e fromJson devem preservar os dados', () {
      final original = Consulta(
        id: '1',
        tipo: TipoConsulta.empresa,
        titulo: 'Loja X',
        documento: '19131243000197',
        nivel: NivelRisco.medio,
        pontuacao: 40,
        motivos: const ['motivo'],
        data: DateTime(2026, 11, 9, 14, 30),
        confiavel: true,
      );

      final copia = Consulta.fromJson(original.toJson());

      expect(copia.id, original.id);
      expect(copia.tipo, TipoConsulta.empresa);
      expect(copia.nivel, NivelRisco.medio);
      expect(copia.motivos, ['motivo']);
      expect(copia.data, original.data);
      expect(copia.confiavel, isTrue);
    });

    test('consulta sem empresa deve ser do tipo golpe', () {
      final consulta = Consulta.criar(
        contexto: ContextoAvaliacao(),
        resultado: const ResultadoAvaliacao(
          nivel: NivelRisco.baixo,
          pontuacao: 0,
          motivos: [],
        ),
      );

      expect(consulta.tipo, TipoConsulta.golpe);
      expect(consulta.titulo, 'Teste do golpe');
    });

    test('copyWith altera só o campo confiável', () {
      final consulta = Consulta(
        id: '1',
        tipo: TipoConsulta.golpe,
        titulo: 'Teste',
        nivel: NivelRisco.baixo,
        pontuacao: 0,
        data: DateTime(2026),
      );

      final alterada = consulta.copyWith(confiavel: true);

      expect(alterada.confiavel, isTrue);
      expect(alterada.titulo, consulta.titulo);
    });
  });
}
