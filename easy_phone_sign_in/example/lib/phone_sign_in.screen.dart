import 'package:flutter/material.dart';
import 'package:phone_sign_in/phone_sign_in.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Sign In'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            Image.network('https://picsum.photos/250?image=9')
                                .image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('LOGO'),
                ],
              ),
              const SizedBox(height: 48),
              PhoneSignIn(
                labelCountryPicker: const Text('1. Select your country'),
                labelEmptyCountry: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Tap to select your country...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                countryPickerOptions: const CountryPickerOptions(),
                onSignInSuccess: () => Navigator.of(context).pop(),
                onSignInFailed: (error) => debugPrint('Error: $error'),
                specialAccounts: const SpecialAccounts(
                  emailLogin: true,
                  reviewEmail: 'review123@email.com',
                  reviewPassword: '12345a',
                  reviewPhoneNumber: '+821012345678',
                  reviewSmsCode: '123456',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
