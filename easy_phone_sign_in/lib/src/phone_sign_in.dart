import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_sign_in/phone_sign_in.dart';

/// A widget that allows users to sign in with their phone number.
///
/// This widget is a wrapper around the Firebase phone authentication API.
///
/// If the phone number from user start with '+', then the phone number will be used as it is (without any formatting).
///
///
///
class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({
    super.key,
    this.countryCode,
    this.countryPickerOptions,
    this.firebaseAuthLanguageCode = 'en',
    this.onCompletePhoneNumber,
    this.onDisplayPhoneNumber,
    required this.onSignInSuccess,
    required this.onSignInFailed,
    this.labelPhoneNumber,
    this.labelUnderPhoneNumberTextField,
    this.labelVerifyPhoneNumberButton,
    this.labelPhoneNumberSelected,
    this.labelOnSmsCodeTextField,
    this.labelRetry,
    this.labelVerifySmsCodeButton,
    this.labelCountryPicker,
    this.labelCountryPickerSelected,
    this.labelChangeCountry,
    this.labelEmptyCountry,
    this.hintTextPhoneNumberTextField,
    this.hintTextSmsCodeTextField,
    this.linkCurrentUser = false,
    this.specialAccounts,
    this.isPhoneNumberRegistered,
  });

  final String? countryCode;
  final CountryPickerOptions? countryPickerOptions;
  final String firebaseAuthLanguageCode;
  final String Function(String)? onCompletePhoneNumber;
  final String Function(String)? onDisplayPhoneNumber;

  final VoidCallback onSignInSuccess;

  /// When the sign-in fails, this function will be called with the
  /// [FirebaseAuthException] error.
  final void Function(FirebaseAuthException) onSignInFailed;

  final Widget? labelPhoneNumber;
  final Widget? labelUnderPhoneNumberTextField;
  final Widget? labelVerifyPhoneNumberButton;
  final Widget? labelPhoneNumberSelected;
  final Widget? labelOnSmsCodeTextField;
  final Widget? labelRetry;
  final Widget? labelVerifySmsCodeButton;
  final Widget? labelCountryPicker;
  final Widget? labelCountryPickerSelected;
  final Widget? labelChangeCountry;
  final Widget? labelEmptyCountry;

  final String? hintTextPhoneNumberTextField;
  final String? hintTextSmsCodeTextField;

  final bool linkCurrentUser;

  final SpecialAccounts? specialAccounts;

  final Future<bool> Function(String)? isPhoneNumberRegistered;

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  bool progress = false;
  Country? country;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController smsCodeController = TextEditingController();
  bool get countryPicker => widget.countryPickerOptions != null;

  String? verificationId;

  bool showSmsCodeInput = false;

  @override
  void initState() {
    super.initState();

    /// If the country code is provided, then parse the country code.
    if (widget.countryCode != null) {
      country = Country.parse(widget.countryCode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (countryPicker)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showCountryPicker(
                context: context,
                onClosed: widget.countryPickerOptions?.onClosed,
                favorite: widget.countryPickerOptions?.favorite,
                exclude: widget.countryPickerOptions?.exclude,
                countryFilter: widget.countryPickerOptions?.countryFilter,
                showPhoneCode:
                    widget.countryPickerOptions?.showPhoneCode ?? true,
                customFlagBuilder:
                    widget.countryPickerOptions?.customFlagBuilder,
                countryListTheme:
                    widget.countryPickerOptions?.countryListTheme ??
                        CountryListThemeData(
                          bottomSheetHeight:
                              MediaQuery.of(context).size.height * 0.5,
                          borderRadius: BorderRadius.circular(16.8),
                        ),
                searchAutofocus:
                    widget.countryPickerOptions?.searchAutofocus ?? false,
                showWorldWide:
                    widget.countryPickerOptions?.showWorldWide ?? false,
                showSearch: widget.countryPickerOptions?.showSearch ?? true,
                useSafeArea: widget.countryPickerOptions?.useSafeArea ?? true,
                onSelect: (Country country) {
                  setState(() {
                    this.country = country;
                    widget.countryPickerOptions?.onSelect?.call(country);
                  });
                },
                useRootNavigator:
                    widget.countryPickerOptions?.useRootNavigator ?? false,
                moveAlongWithKeyboard:
                    widget.countryPickerOptions?.moveAlongWithKeyboard ?? false,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (country == null)
                  widget.labelCountryPicker ??
                      const Text('Select your country'),
                if (country != null)
                  widget.labelCountryPickerSelected ??
                      widget.labelCountryPicker ??
                      const Text('Select your country'),
                if (country == null)
                  widget.labelEmptyCountry ?? const SizedBox.shrink()
                else ...[
                  Text('(+${country!.phoneCode}) ${country!.name}',
                      style: Theme.of(context).textTheme.titleLarge),
                  widget.labelChangeCountry ??
                      Text('Change',
                          style: Theme.of(context).textTheme.labelSmall),
                ]
              ],
            ),
          ),
        if (showSmsCodeInput == false &&
            (countryPicker == false || country != null)) ...[
          const SizedBox(height: 16),
          widget.labelPhoneNumber ?? const Text('Enter your phone number'),
          TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              prefixIcon: country != null
                  ? SizedBox(
                      width: country!.phoneCode.length <= 2 ? 60 : 80,
                      child: Center(
                        child: Text(
                          '+${country!.phoneCode}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    )
                  : null,
              hintText: widget.hintTextPhoneNumberTextField ?? 'Phone number',
              hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          if (widget.labelUnderPhoneNumberTextField != null)
            widget.labelUnderPhoneNumberTextField!,
          if (phoneNumberController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            progress
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ElevatedButton(
                    onPressed: () async {
                      final completePhoneNumber = onCompletePhoneNumber();
                      if (widget.specialAccounts?.emailLogin == true &&
                          phoneNumberController.text.contains('@')) {
                        return doEmailLogin();
                      } else if (completePhoneNumber ==
                          widget.specialAccounts?.reviewPhoneNumber) {
                        return doReviewPhoneNumberSubmit();
                      } else if (completePhoneNumber.isEmpty) {
                        throw Exception(
                          '@phone_sign_in/malformed-phone-number Phone number is empty or malformed.',
                        );
                      }

                      showProgress();
                      FirebaseAuth.instance
                          .setLanguageCode(widget.firebaseAuthLanguageCode);

                      await FirebaseAuth.instance.verifyPhoneNumber(
                        timeout: const Duration(seconds: 60),
                        phoneNumber: completePhoneNumber,
                        // Android Only. Automatic SMS code resolved. Just go home.
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          log('--> PhoneSignIn::build() -> verificationCompleted: $credential');
                          // Note that, the app logs in automatically in Anroid, the app may throw time-expire or invalid sms code.
                          // You can ignore this erorrs.
                          // Sign the user in (or link) with the auto-generated credential

                          /// Sign in with the credential from Phone number and Sms code.
                          try {
                            /// Is if for linking the current user with the phone number.
                            if (widget.linkCurrentUser) {
                              log('Linking current user account with phone number ');
                              await linkOrSignInWithCredential(credential);
                            } else {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                            }

                            onSignInSuccess();
                          } on FirebaseAuthException catch (e) {
                            onSignInFailed(e);
                          }
                        },
                        // Phone number verification failed or there is an error on Firebase like quota exceeded.
                        // This is not for the failures of SMS code verification!
                        verificationFailed: (FirebaseAuthException e) {
                          log('---> PhoneSignIn::build() -> verificationFailed: $e');
                          onSignInFailed(e);
                        },
                        // Phone number verfied and SMS code sent to user.
                        // Show SMS code input UI.
                        codeSent: (String verificationId, int? resendToken) {
                          log('---> PhoneSignIn::build() -> codeSent: $verificationId');
                          this.verificationId = verificationId;
                          setState(() {
                            showSmsCodeInput = true;
                            hideProgress();
                          });
                        },

                        /// This is for Android only.
                        /// This timeout may happens when the Phone Signal is not stable.
                        codeAutoRetrievalTimeout: (String verificationId) {
                          // Auto-resolution timed out...
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'SMS code auto-resolution timed out. Please retry.',
                                ),
                              ),
                            );
                            setState(() {
                              showSmsCodeInput = false;
                            });
                            hideProgress();
                          }
                        },
                      );
                    },
                    child: widget.labelVerifyPhoneNumberButton ??
                        const Text('Verify phone number'),
                  ),
          ],
        ],
        if (showSmsCodeInput) ...[
          const SizedBox(height: 16),
          widget.labelPhoneNumberSelected ?? const Text('Phone number'),
          Text(
            onDisplayPhoneNumber(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          widget.labelOnSmsCodeTextField ?? const Text('Enter the SMS code'),
          TextField(
            controller: smsCodeController,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: widget.hintTextSmsCodeTextField ?? 'SMS code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              /// 2024. 06. 26. by @thruthesky: ElevatedButton is replaced with TextButton since it gives too much focus.
              TextButton(
                onPressed: retry,
                child: widget.labelRetry ?? const Text('Retry'),
              ),
              const Spacer(),
              if (smsCodeController.text.isNotEmpty)
                progress
                    ? const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: CircularProgressIndicator.adaptive())
                    : ElevatedButton(
                        onPressed: () async {
                          if (onCompletePhoneNumber() ==
                              widget.specialAccounts?.reviewPhoneNumber) {
                            return doReviewSmsCodeSubmit();
                          }
                          showProgress();

                          /// Get the credential from the SMS code and the verification ID.
                          final credential = PhoneAuthProvider.credential(
                            verificationId: verificationId!,
                            smsCode: smsCodeController.text.trim(),
                          );

                          /// Sign in with the credential from Phone number and Sms code.
                          try {
                            /// Is if for linking the current user with the phone number.
                            if (widget.linkCurrentUser) {
                              log('Linking current user account with phone number ');
                              await linkOrSignInWithCredential(credential);
                            } else {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                            }
                            onSignInSuccess();
                          } on FirebaseAuthException catch (e) {
                            onSignInFailed(e);
                          }
                        },
                        child: widget.labelVerifySmsCodeButton ??
                            const Text('Verify SMS code'),
                      ),
            ],
          )
        ],
      ],
    );
  }

  /// Attempts to link the current user with the given credential.
  ///
  /// If linking fails due to the PhoneSignIn credential already being in use,
  /// it will try to sign in with the given credential instead.
  ///
  /// if the linking fails due to current user does not exist or there is no
  /// current user login (anonymous) it will try to sign in with the given
  /// credentials instead
  ///
  ///
  /// 처음 한번 전화번호 로그인 할 때 잘 되는데, 이미 존재하는 전화번호로 로그인하면, sms expired 에러가 난다.
  /// 왜냐하면, 이미 존재하는 전화번호의 경우, linkWithCredential() 이 실패하면, signInWithCredential 을 사용하는데,
  /// 이 때, linkWithCredentail() 에서 사용된, credential 을 signInWithCredential 에서 사용해서 그런 것 같다.
  /// 그래서, 상단에서 전화번호가 이미 존재하는지 하지 않는지 파악해서, 전화번호가 존재하면 그냥 signInWithCredential() 을
  /// 바로 호출하도록 한다.
  /// 이 것은 전화번호로 로그인을 할 때에만 SMS 로 얻는 credential 이, 두번 사용되면 안되는 것 같다. 다른 로그인은 괜찮은 것 같다.
  /// 그래서, phoneNumbers 컬렉션에, 전화번호를 문서 id 로 해서 저장한다. 이 때, uid 를 같이 저장하지 않는다. 그래서 해킹당해도
  /// 누구의 전화번호인지 알 수 없도록 한다. 용도는 전화번호가 가입되어져 있는지 아닌지만 확인하기 위해서 기록을 한다.
  ///
  Future<void> linkOrSignInWithCredential(AuthCredential credential) async {
    log('linkOrSignInWithCredential()');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      log('Currently user is not signed in. Not even as anonymous. So, it will sign in with the phone number.');
      await FirebaseAuth.instance.signInWithCredential(credential);
      return;
    }

    /// 전화 번호가 이미 사용되었는지 확인하는 콜백 함수
    ///
    /// 만약, 전화번호가 이미 사용되었으면, link 하지 말고 그냥 로그인한다.
    final re = await widget.isPhoneNumberRegistered!(onCompletePhoneNumber());
    if (re) {
      log('--> linkOrSignInWithCredential() -> Phone number already in use!! So, it will sign-in with phone number without linking.');
      await FirebaseAuth.instance.signInWithCredential(credential);
      return;
    }

    /// 현재 사용자가 로그인 되어 있는 경우, 전화번호로 로그인을 시도한다.
    log('--> linkOrSignInWithCredential() -> The phone number is not in use. Currently user is signed in (maybe as an anonymous). Try to link with the phone number sign-in credential.');
    await currentUser.linkWithCredential(credential);
  }

  /// Format the phone number to display
  ///
  /// This function returns the phone number that will be displayed to the user.
  /// The phone number may be in any form that is suitable for the user interface.
  ///
  /// 이 함수는 [onCompletePhoneNumber] 함수와는 다르게 Firebase sign-in 에 사용되는 전화번호가 아닌,
  /// 사용자에 보여줄 친숙한 형태로 전화번호를 반환하면 된다.
  ///
  /// 예를 들면, 전화번호가 한국 전화번호로 "+82" 로 고정되어져 있다면, 화면에 표시할 전화번호는 "010-1234-5678" 과 같이
  /// 국제 전화번호로 표시 할 필요가 없다.
  ///
  String onDisplayPhoneNumber() {
    final phoneNumber = onCompletePhoneNumber();
    return widget.onDisplayPhoneNumber?.call(phoneNumber) ?? phoneNumber;
  }

  /// Format the phone number before sending it to Firebase.
  ///
  /// This function should return the phone number in the international phone number format.
  ///
  /// 이 함수가 리턴하는 전화번호는 Firebase Phone Sign-in 에 사용되므로, 국제 전화번호 형식으로 반환해야 한다.
  ///
  /// 로직:
  /// - 전화번호에서 플러스(+)와 숫자가 아닌 모든 것 (예: 콤마, 하이픈, 괄호, 공백) 등을 제거한다.
  /// - 숫자 0으로 시작하면 제거한다.
  /// - 플러스(+) 로 시작하면 그대로 리턴한다.
  /// - 그렇지 않으면, [onCompletePhoneNumber] 함수를 호출하거나, 국제 전화번호 형식으로 리턴한다.
  String onCompletePhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    String number = phoneNumber.trim();

    number = number.replaceAll(RegExp(r'[^\+0-9]'), '');
    number = number.replaceFirst(RegExp(r'^0'), '');

    if (number.startsWith('+')) {
      log('--> onCompletePhoneNumber: $number starts with +. No formatting needed.');
      return number;
    }

    if (widget.onCompletePhoneNumber != null) {
      return widget.onCompletePhoneNumber?.call(number) ?? number;
    } else if (country != null) {
      return '+${country!.phoneCode}$number';
    } else {
      return number;
    }
  }

  onSignInSuccess() {
    hideProgress();
    widget.onSignInSuccess.call();
  }

  onSignInFailed(FirebaseAuthException e) {
    hideProgress();
    widget.onSignInFailed.call(e);
  }

  void showProgress() {
    setState(() => progress = true);
  }

  void hideProgress() {
    setState(() => progress = false);
  }

  void retry() {
    setState(() {
      showSmsCodeInput = false;
      verificationId = null;
      phoneNumberController.clear();
      smsCodeController.clear();
    });
  }

  doEmailLogin([String? emailPassword]) async {
    log('BEGIN: doEmailLogin()');

    emailPassword ??= phoneNumberController.text;

    showProgress();
    try {
      // 전화번호 중간에 @ 이 있으면 : 로 분리해서, 이메일과 비밀번호로 로그인을 한다.
      // 예) test9@email.com:12345a
      final email = emailPassword.split(':').first;
      final password = emailPassword.split(':').last;
      await loginOrRegister(
        email: email,
        password: password,
        photoUrl: '',
        displayName: '',
      );
      onSignInSuccess();
    } on FirebaseAuthException catch (e) {
      log('ERROR: doEmailLogin error: $e');
      onSignInFailed(e);
      if (context.mounted) {
        hideProgress();
      }
      rethrow;
    }
  }

  /// Login or register
  ///
  /// Creates a user account if it's not existing.
  ///
  /// [email] is the email of the user.
  ///
  /// [password] is the password of the user.
  ///
  /// [photoUrl] is the photo url of the user. If it's null, then it will be the default photo url.
  ///
  /// [displayName] is the display name of the user. If it's null, then it will be the same as the email.
  /// You can put empty string if you want to save it an empty stirng.
  ///
  /// Logic:
  /// Try to login with email and password.
  ///    -> If it's successful, return the user.
  ///    -> If it fails, create a new user with email and password.
  ///        -> If a new account is created, then update the user's display name and photo url.
  ///        -> And return the user.
  ///        -> If it's failed (to create a new user), throw an error.
  ///
  /// ```dart
  /// final email = "${randomString()}@gmail.com";
  /// final randomUser = await Test.loginOrRegister(
  ///   TestUser(
  ///     displayName: email,
  ///     email: email,
  ///     photoUrl: 'https://picsum.photos/id/1/200/200'
  ///   ),
  /// );
  /// ```
  ///
  /// Return the user object of firebase auth and whether the user is registered or not.
  Future loginOrRegister({
    required String email,
    required String password,
    String? photoUrl,
    String? displayName,
  }) async {
    try {
      // login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // create
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    }
  }

  /// test2@email.com:12345a
  doReviewPhoneNumberSubmit() {
    if (context.mounted) {
      setState(() {
        showSmsCodeInput = true;
        progress = false;
      });
    }
  }

  doReviewSmsCodeSubmit() {
    if (smsCodeController.text == widget.specialAccounts?.reviewSmsCode) {
      return doEmailLogin(
          "${widget.specialAccounts!.reviewEmail}:${widget.specialAccounts!.reviewPassword}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid SMS code. Please retry.'),
        ),
      );
    }
  }
}
