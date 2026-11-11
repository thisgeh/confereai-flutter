import 'dart:convert';

import 'package:confereai/services/api_exception.dart';
import 'package:confereai/services/brasil_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';


http.Client clienteFake(Object corpo, int status) {
  return MockClient((requisicao) async {
    return http.Response.bytes(
      utf8.encode(corpo is String ? corpo : jsonEncode(corpo)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

void main() {
  group('buscarEmpresa', () {
    test('deve chamar a URL correta sem a máscara do CNPJ', () async {
      // Arrange
      Uri? urlChamada;
      final cliente = MockClient((requisicao) async {
        urlChamada = requisicao.url;
        return http.Response(
          jsonEncode({'cnpj': '19131243000197', 'razao_social': 'X'}),
          200,
        );
      });
      final service = BrasilApiService(client: cliente);

     
      await service.buscarEmpresa('19.131.243/0001-97');

     
      expect(
        urlChamada.toString(),
        'https://brasilapi.com.br/api/cnpj/v1/19131243000197',
      );
    });

    test('status 200 deve devolver a empresa', () async {
      final service = BrasilApiService(
        client: clienteFake({
          'cnpj': '19131243000197',
          'razao_social': 'OPEN KNOWLEDGE BRASIL',
          'descricao_situacao_cadastral': 'ATIVA',
        }, 200),
      );

      final empresa = await service.buscarEmpresa('19131243000197');

      expect(empresa.razaoSocial, 'OPEN KNOWLEDGE BRASIL');
      expect(empresa.ativa, isTrue);
    });

    test('status 404 deve gerar ApiException com status 404', () async {
      final service = BrasilApiService(
        client: clienteFake({'message': 'não encontrado'}, 404),
      );

      expect(
        () => service.buscarEmpresa('19131243000197'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });

    test('status 503 deve gerar ApiException', () async {
      final service = BrasilApiService(client: clienteFake('erro', 503));

      expect(
        () => service.buscarEmpresa('19131243000197'),
        throwsA(isA<ApiException>()),
      );
    });

    test('falha de conexão deve gerar ApiException amigável', () async {
      final service = BrasilApiService(
        client: MockClient((_) async => throw http.ClientException('offline')),
      );

      expect(
        () => service.buscarEmpresa('19131243000197'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.mensagem,
            'mensagem',
            contains('internet'),
          ),
        ),
      );
    });
  });

  group('listarBancos', () {
    test('status 200 deve devolver a lista de bancos', () async {
      final service = BrasilApiService(
        client: clienteFake([
          {'ispb': '00000000', 'name': 'BCO DO BRASIL S.A.', 'code': 1, 'fullName': 'Banco do Brasil S.A.'},
          {'ispb': '00360305', 'name': 'CAIXA ECONOMICA FEDERAL', 'code': 104, 'fullName': 'Caixa Econômica Federal'},
        ], 200),
      );

      final bancos = await service.listarBancos();

      expect(bancos.length, 2);
      expect(bancos[1].nomeCompleto, 'Caixa Econômica Federal');
    });

    test('status diferente de 200 deve gerar ApiException', () async {
      final service = BrasilApiService(client: clienteFake('erro', 500));

      expect(() => service.listarBancos(), throwsA(isA<ApiException>()));
    });
  });
}
