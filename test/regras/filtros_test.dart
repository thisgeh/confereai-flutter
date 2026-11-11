import 'package:confereai/models/banco.dart';
import 'package:confereai/models/consulta.dart';
import 'package:confereai/models/nivel_risco.dart';
import 'package:confereai/regras/filtros.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiltroBancos', () {
    const bancos = [
      Banco(ispb: '0', nome: 'BCO DO BRASIL S.A.', nomeCompleto: 'Banco do Brasil S.A.', codigo: 1),
      Banco(ispb: '1', nome: 'CAIXA ECONOMICA FEDERAL', nomeCompleto: 'Caixa Econômica Federal', codigo: 104),
      Banco(ispb: '2', nome: 'ITAÚ UNIBANCO S.A.', nomeCompleto: 'Itaú Unibanco S.A.', codigo: 341),
      Banco(ispb: '3', nome: 'SEM CODIGO', nomeCompleto: 'Sem código', codigo: null),
    ];

    test('busca vazia devolve todos', () {
      expect(FiltroBancos.filtrar(bancos, '').length, 4);
    });

    test('busca pelo código encontra o banco', () {
      expect(FiltroBancos.filtrar(bancos, '104').single.codigo, 104);
    });

    test('busca pelos números do boleto usa só os 3 primeiros', () {
      expect(FiltroBancos.filtrar(bancos, '34191790').single.codigo, 341);
    });

    test('busca por nome ignora acentos e maiúsculas', () {
      expect(FiltroBancos.filtrar(bancos, 'itau').single.codigo, 341);
      expect(FiltroBancos.filtrar(bancos, 'econômica').single.codigo, 104);
    });

    test('código inexistente não encontra nada', () {
      expect(FiltroBancos.filtrar(bancos, '999'), isEmpty);
    });

    test('ordenar coloca bancos sem código no final', () {
      final ordenados = FiltroBancos.ordenar(bancos.reversed.toList());
      expect(ordenados.map((b) => b.codigo), [1, 104, 341, null]);
    });
  });

  group('FiltroHistorico', () {
    Consulta criar(String id, NivelRisco nivel, {bool confiavel = false}) {
      return Consulta(
        id: id,
        tipo: TipoConsulta.empresa,
        titulo: id,
        nivel: nivel,
        pontuacao: 0,
        data: DateTime(2026),
        confiavel: confiavel,
      );
    }

    final consultas = [
      criar('a', NivelRisco.alto),
      criar('b', NivelRisco.baixo, confiavel: true),
      criar('c', NivelRisco.medio),
    ];

    test('todas devolve a lista completa', () {
      expect(FiltroHistorico.filtrar(consultas, FiltroConsulta.todas).length, 3);
    });

    test('filtro de perigo devolve só risco alto', () {
      final resultado = FiltroHistorico.filtrar(consultas, FiltroConsulta.alto);
      expect(resultado.single.id, 'a');
    });

    test('filtro de confiáveis devolve só as marcadas', () {
      final resultado =
          FiltroHistorico.filtrar(consultas, FiltroConsulta.confiaveis);
      expect(resultado.single.id, 'b');
    });
  });
}
