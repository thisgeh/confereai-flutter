import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/contato_confianca.dart';


class ContatosRepository {
  static const chave = 'contatos_confianca';

  Future<List<ContatoConfianca>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(chave);
    if (texto == null || texto.isEmpty) return [];

    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((item) => ContatoConfianca.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<ContatoConfianca?> principal() async {
    final contatos = await listar();
    return contatos.isEmpty ? null : contatos.first;
  }

  Future<void> adicionar(ContatoConfianca contato) async {
    final contatos = await listar();
    contatos.add(contato);
    await _salvar(contatos);
  }

  Future<void> remover(String id) async {
    final contatos = await listar();
    contatos.removeWhere((c) => c.id == id);
    await _salvar(contatos);
  }

  Future<void> definirPrincipal(String id) async {
    final contatos = await listar();
    final indice = contatos.indexWhere((c) => c.id == id);
    if (indice <= 0) return;

    final contato = contatos.removeAt(indice);
    contatos.insert(0, contato);
    await _salvar(contatos);
  }

  Future<void> _salvar(List<ContatoConfianca> contatos) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(contatos.map((c) => c.toJson()).toList());
    await prefs.setString(chave, texto);
  }
}
