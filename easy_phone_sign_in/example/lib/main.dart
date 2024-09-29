import 'package:country_picker/country_picker.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/phone_sign_in.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_sign_in/phone_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Phone Sign In Demo'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '1) connect Firebase\n2) Enable Phone Sign-In',
                ),
                StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Text(
                          'User: ${snapshot.data?.uid}, ${snapshot.data?.phoneNumber}, ${snapshot.data?.email}');
                    }),

                Wrap(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PhoneSignInScreen(),
                        ),
                      ),
                      child: const Text('Phone sign-in screen'),
                    ),

                    /// Sign out button
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Signed out'),
                          ),
                        );
                      },
                      child: const Text('Sign out'),
                    ),
                  ],
                ),

                /// 한국전화번호 또는 필리핀 전화번호를 입력받는 경우,
                Box(
                  child: PhoneSignIn(
                    labelPhoneNumber: const Text(
                      ' 한국 또는 필리핀 전화번호를 입력하세요.',
                    ),
                    labelUnderPhoneNumberTextField: Text(
                      ' 예) 010 1234 5678 또는 0917 1111 2222',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    labelVerifyPhoneNumberButton: const Text('전화번호 인증'),
                    labelPhoneNumberSelected: const Text('전화번호'),
                    labelOnSmsCodeTextField: const Text('SMS 코드를 입력하세요'),
                    labelRetry: const Text('재시도'),
                    labelVerifySmsCodeButton: const Text('SMS 코드 인증'),
                    hintTextPhoneNumberTextField: '전화번호',
                    hintTextSmsCodeTextField: 'SMS 코드',
                    onCompletePhoneNumber: onCompletePhoneNumber,
                    onDisplayPhoneNumber: (phoneNumber) {
                      debugPrint('Got -> display phone number: $phoneNumber');

                      if (phoneNumber.startsWith('+8210')) {
                        phoneNumber = phoneNumber.replaceFirst('+82', '0');
                        phoneNumber =
                            '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
                      } else if (phoneNumber.startsWith('+639')) {
                        phoneNumber = phoneNumber.replaceFirst('+63', '0');
                        phoneNumber =
                            '${phoneNumber.substring(0, 4)}-${phoneNumber.substring(4, 7)}-${phoneNumber.substring(7)}';
                      }

                      debugPrint(
                          'Return -> display phone number: $phoneNumber');
                      return phoneNumber;
                    },
                    onSignInSuccess: onSignInSuccess,
                    onSignInFailed: onSignInFailed,
                    specialAccounts: const SpecialAccounts(
                      emailLogin: true,
                    ),
                  ),
                ),
                Box(
                  child: PhoneSignIn(
                    countryCode: 'KR',
                    onSignInSuccess: onSignInSuccess,
                    onSignInFailed: onSignInFailed,
                    linkCurrentUser: true,
                    specialAccounts: const SpecialAccounts(
                      emailLogin: true,
                      reviewEmail: 'review123@email.com',
                      reviewPassword: '12345a',
                      reviewPhoneNumber: '+821012345678',
                      reviewSmsCode: '123456',
                    ),
                  ),
                ),
                Box(
                  child: PhoneSignIn(
                    linkCurrentUser: true,
                    labelCountryPicker: const Text('국가 선택'),
                    labelChangeCountry: const Text('변경'),

                    /// You can add country picker on the phone sign in by adding the countryPickerOptions parameter.
                    countryPickerOptions: CountryPickerOptions(
                      /// You can add your own custom country list like below. Or remove the countryFilter parameter to show all countries.
                      // countryFilter: ['KR', 'VN', 'TH', 'LA', 'MM', 'PH'],
                      showSearch: true,
                      countryListTheme: const CountryListThemeData(
                        bottomSheetHeight: 400,
                      ),
                      onSelect: (country) {
                        debugPrint('Country: ${country.name}');
                      },
                    ),
                    onSignInSuccess: onSignInSuccess,
                    onSignInFailed: onSignInFailed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String onCompletePhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('10')) {
      phoneNumber = '+82$phoneNumber';
    } else if (phoneNumber.startsWith('9')) {
      phoneNumber = '+63$phoneNumber';
    }
    debugPrint('Phone number: $phoneNumber');
    return phoneNumber;
  }

  void onSignInSuccess() {
    debugPrint('Sign in success');
  }

  void onSignInFailed(e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed:  ${e.message}'),
        ),
      );
}

class Box extends StatelessWidget {
  const Box({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        child:
            child // This is the child widget that will be displayed inside the box
        );
  }
}
