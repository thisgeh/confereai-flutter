import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/consulta.dart';


class HistoricoRepository {
  static const chave = 'historico_consultas';
  static const limite = 50;

  Future<List<Consulta>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(chave);
    if (texto == null || texto.isEmpty) return [];

    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((item) => Consulta.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      
      return [];
    }
  }

  Future<void> adicionar(Consulta consulta) async {
    final consultas = await listar();
    consultas.insert(0, consulta);
    await _salvar(consultas.take(limite).toList());
  }

  Future<void> atualizar(Consulta consulta) async {
    final consultas = await listar();
    final indice = consultas.indexWhere((c) => c.id == consulta.id);
    if (indice == -1) return;

    consultas[indice] = consulta;
    await _salvar(consultas);
  }

  Future<void> remover(String id) async {
    final consultas = await listar();
    consultas.removeWhere((c) => c.id == id);
    await _salvar(consultas);
  }

  Future<void> limpar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(chave);
  }

  Future<void> _salvar(List<Consulta> consultas) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(consultas.map((c) => c.toJson()).toList());
    await prefs.setString(chave, texto);
  }
}
