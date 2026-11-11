import 'package:confereai/regras/validador_cnpj.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidadorCnpj.valido', () {
    test('CNPJ numérico válido com máscara deve ser aceito', () {
      expect(ValidadorCnpj.valido('19.131.243/0001-97'), isTrue);
    });

    test('CNPJ numérico válido sem máscara deve ser aceito', () {
      expect(ValidadorCnpj.valido('00000000000191'), isTrue);
    });

    test('CNPJ alfanumérico (novo modelo de 2026) deve ser aceito', () {
      // Exemplo oficial publicado pela Receita Federal.
      expect(ValidadorCnpj.valido('12.ABC.345/01DE-35'), isTrue);
    });

    test('CNPJ alfanumérico em letras minúsculas deve ser aceito', () {
      expect(ValidadorCnpj.valido('12abc34501de35'), isTrue);
    });

    test('dígito verificador errado deve ser recusado', () {
      expect(ValidadorCnpj.valido('19.131.243/0001-98'), isFalse);
    });

    test('CNPJ com todos os números iguais deve ser recusado', () {
      expect(ValidadorCnpj.valido('11.111.111/1111-11'), isFalse);
    });

    test('CNPJ com menos de 14 caracteres deve ser recusado', () {
      expect(ValidadorCnpj.valido('1913124300019'), isFalse);
    });

    test('texto vazio deve ser recusado', () {
      expect(ValidadorCnpj.valido(''), isFalse);
    });

    test('letra nos dígitos verificadores deve ser recusada', () {
      expect(ValidadorCnpj.valido('12ABC34501DEAB'), isFalse);
    });
  });

  group('ValidadorCnpj.formatar', () {
    test('deve aplicar a máscara', () {
      expect(ValidadorCnpj.formatar('19131243000197'), '19.131.243/0001-97');
    });

    test('valor incompleto deve ser devolvido sem alteração', () {
      expect(ValidadorCnpj.formatar('1913'), '1913');
    });
  });

  test('limpar deve remover pontuação e deixar letras maiúsculas', () {
    expect(ValidadorCnpj.limpar('12.abc.345/01de-35'), '12ABC34501DE35');
  });
}
