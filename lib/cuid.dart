import 'dart:io' show Platform, pid;
import 'dart:math';

final String prefix = 'c';
final int base = 36; // size of the alphabet
final int blockSize = 4; // length of each segment
final discreteValues = pow(base, blockSize);

String _timeBlock () {
  final now = DateTime.now().toUtc().millisecondsSinceEpoch;
  return now.toRadixString(base);
}

int _counter = 0;
String _counterBlock () {
  _counter = _counter < discreteValues ? _counter : 0;
  _counter++;
  return _pad((_counter - 1).toRadixString(base), 4);
}

final String _fingerprint = _pidFingerprint() + _hostFingerprint();

String _pidFingerprint() {
  return _pad(pid.toRadixString(base), 2);
}

String _hostFingerprint() {
  final int hostId = Platform.localHostname.runes.reduce((acc, r) => acc + r);
  return _pad(hostId.toRadixString(base), 2);
}

final _secureRandom = Random.secure();
String _secureRandomBlock () {
  const max = 1<<32;
  return _pad(_secureRandom.nextInt(max).toRadixString(base), 4);
}

String _pad(String s, int l) {
  s = s.padLeft(l, '0');
  return s.substring(s.length - l);
}

String newCuid() {
  // time block (exposes exactly when id was generated, on purpose)
  final tblock = _timeBlock();

  // counter block
  final cblock = _counterBlock();

  // fingerprint block
  final fblock = _fingerprint;

  // random block
  final rblock = _secureRandomBlock() + _secureRandomBlock();

  return prefix + tblock + cblock + fblock + rblock;
}

bool isCuid(String s) {
  s = s ?? '';
  return s.startsWith(prefix);
}
