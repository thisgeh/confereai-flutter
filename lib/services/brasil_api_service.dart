import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/banco.dart';
import '../models/empresa.dart';
import '../regras/validador_cnpj.dart';
import 'api_exception.dart';


class BrasilApiService {
  BrasilApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String urlBase = 'https://brasilapi.com.br/api';
  static const Duration tempoLimite = Duration(seconds: 15);

  final http.Client _client;

  
  Future<Empresa> buscarEmpresa(String cnpj) async {
    final cnpjLimpo = ValidadorCnpj.limpar(cnpj);
    final resposta = await _get(Uri.parse('$urlBase/cnpj/v1/$cnpjLimpo'));

    switch (resposta.statusCode) {
      case 200:
        final json = jsonDecode(utf8.decode(resposta.bodyBytes));
        return Empresa.fromJson(json as Map<String, dynamic>);
      case 404:
        throw const ApiException(
          'Não existe nenhuma empresa com esse CNPJ na Receita Federal. '
          'Isso já é um sinal de alerta: não pague!',
          statusCode: 404,
        );
      case 400:
        throw const ApiException(
          'Esse CNPJ não é válido. Confira os números e tente de novo.',
          statusCode: 400,
        );
      case 429:
        throw const ApiException(
          'Muitas consultas seguidas. Espere um minutinho e tente de novo.',
          statusCode: 429,
        );
      default:
        throw ApiException(
          'O serviço da Receita Federal não respondeu agora. '
          'Tente de novo em alguns instantes.',
          statusCode: resposta.statusCode,
        );
    }
  }

  /// GET /banks/v1
  Future<List<Banco>> listarBancos() async {
    final resposta = await _get(Uri.parse('$urlBase/banks/v1'));

    if (resposta.statusCode != 200) {
      throw ApiException(
        'Não foi possível carregar a lista de bancos agora. '
        'Tente de novo em alguns instantes.',
        statusCode: resposta.statusCode,
      );
    }

    final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;

    return lista
        .map((item) => Banco.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      return await _client.get(uri).timeout(tempoLimite);
    } on TimeoutException {
      throw const ApiException(
        'A consulta demorou demais. Verifique a sua internet e tente de novo.',
      );
    } catch (_) {
      throw const ApiException(
        'Sem conexão com a internet. Verifique o Wi-Fi ou os dados móveis '
        'e tente de novo.',
      );
    }
  }
}
