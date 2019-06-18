import 'package:test/test.dart';
import 'package:cuid/cuid.dart';

void main() {
  test('length', () {
    final cuid = newCuid();
    expect(cuid.length, 25);
  });

  test('prefix', () {
    final cuid = newCuid();
    expect(cuid.startsWith('c'), true);
  });

  test('avoiding back-to-back collision', () {
    final cuid1 = newCuid();
    final cuid2 = newCuid();
    if (cuid1 == cuid2) {
      fail('collision:\n\t$cuid1\n\t$cuid2');
    }
  });
}
