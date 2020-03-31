class Session {
  final String email;
  final String password;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  Session({
    this.email,
    this.password,
    this.accessToken,
    this.tokenType,
    this.refreshToken,
  });

  bool hasExpired() => false;
}
