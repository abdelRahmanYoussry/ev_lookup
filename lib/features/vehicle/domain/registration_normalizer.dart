abstract final class RegistrationNormalizer {
  static String normalize(String raw) =>
      raw.replaceAll(RegExp(r'\s+'), '').toUpperCase();
}
