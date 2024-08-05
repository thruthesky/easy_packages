import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_sign_in/phone_sign_in.dart';

const sm = 16.0;
const xxs = 4.0;

class SignInScreen extends StatefulWidget {
  static const String routeName = '/SignIn';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignIn'),
      ),
      body: Column(
        children: [
          const Text("SignIn"),
          EmailPasswordLogin(
            onLogin: () => context.pop(),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: sm,
            ),
            child: PhoneSignIn(
              //
              labelCountryPicker: Padding(
                padding: const EdgeInsets.only(bottom: xxs),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                  child: Text(
                    '1. ${'Choose country'.t}',
                    style: context.titleLarge,
                  ),
                ),
              ),
              labelCountryPickerSelected: Padding(
                padding: const EdgeInsets.only(bottom: xxs),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                  child: Text(
                    '1. ${'Choose country'.t}',
                  ),
                ),
              ),
              labelEmptyCountry: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colorScheme.onSurface,
                    width: 1.8,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Choose country desc'.t),
                ),
              ),
              labelChangeCountry: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text('Change country'.t),
              ),
              labelPhoneNumber: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 48, 0, 8.0),
                child: Text(
                  '2. ${'Enter your phone number'.t}',
                  style: context.titleLarge,
                ),
              ),
              labelPhoneNumberSelected: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text('2. ${'Phone Number'.t}'),
              ),
              hintTextPhoneNumberTextField: 'Phone Number'.t,
              labelOnSmsCodeTextField: Padding(
                padding: const EdgeInsets.fromLTRB(0, 48, 0, 8),
                child: Text(
                  '3. ${'Enter SMS code'.t}',
                  style: context.titleLarge,
                ),
              ),
              hintTextSmsCodeTextField: 'SMS code'.t,
              labelVerifyPhoneNumberButton: Text('Verify phone number'.t),
              labelVerifySmsCodeButton: Text('Verify SMS code'.t),

              labelRetry: Text('Retry'.t),
              linkCurrentUser: true,
              onSignInSuccess: afterSignIn,
              onSignInFailed: onSignInFailed,
              countryPickerOptions: const CountryPickerOptions(
                favorite: ['US', 'KR'],
              ),
              specialAccounts: const SpecialAccounts(
                reviewEmail: 'review@email.com',
                reviewPassword: '12345zB,*c',
                reviewPhoneNumber: '+11234567890',
                reviewSmsCode: '123456',
                emailLogin: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// clean previous anonnymouse user after login in into existing account.
  ///
  afterSignIn() async {
    if (context.mounted) {
      context.pop();
    }
  }

  onSignInFailed(FirebaseAuthException e) {
    dog('onSignInFailed() -> FirebaseAuthException : $e');
    if (e.code == 'web-context-cancelled') {
      // The interaction was cancelled by the user
      error(
        context: context,
        message: Text('Login in canceled'.t),
      );
    } else if (e.code == 'missing-client-identifier') {
      error(
        context: context,
        message: Text(
            'Your phone number cannot be verified. Please make sure you entered the correct phone number and try again.'
                .t),
      );
    } else if (e.code == 'too-many-requests') {
      error(
        context: context,
        message: Text(
            'All requests from this device have been blocked due to too many attempts. Please try again later'
                .t),
      );
    } else if (e.code == 'invalid-verification-code') {
      error(
        context: context,
        message: Text(
            'oh! This is incorrect code. Please check the code sent to your phone and try again'
                .t),
      );
    } else if (e.code == 'invalid-phone-number') {
      error(
        context: context,
        message: const Text('Invalid phone number'),
      );
    } else {
      dog(
        'FirebaseAuthException : $e',
      );
      throw e;
    }
  }
}
