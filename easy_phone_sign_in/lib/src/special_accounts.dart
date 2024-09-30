/// Special accounts for review and testing purposes.
///
/// When you submit your app for review, you can provide special accounts for
/// the reviewer to use. You can provide [reviewPhoneNumber] and
/// [reviewSmsCode] to simulate the phone sign in process. You can also provide
/// [reviewEmail] and [reviewPassword] to simulate the email sign in process.
///
/// Refer README.md for more information and refer to the example app for
/// implementation.
class SpecialAccounts {
  final String reviewEmail;
  final String reviewPassword;
  final String reviewPhoneNumber;
  final String reviewSmsCode;
  final bool emailLogin;

  const SpecialAccounts({
    this.reviewEmail = 'review@email.com',
    this.reviewPassword = '',
    this.reviewPhoneNumber = '123456789',
    this.reviewSmsCode = '',
    this.emailLogin = false,
  });
}
