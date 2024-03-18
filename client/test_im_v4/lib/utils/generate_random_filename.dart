import 'dart:math';

String generateRandomFileName() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      50, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
