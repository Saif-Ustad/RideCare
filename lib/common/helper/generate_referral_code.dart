String generateReferralCode(String firstName) {
  final random = DateTime.now().millisecondsSinceEpoch.toString();
  return '${firstName.substring(0, 3).toUpperCase()}${random.substring(random.length - 4)}';
}
