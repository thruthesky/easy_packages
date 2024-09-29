# Phone Sign In

This Flutter package is designed to streamline the integration of Google's phone sign-in functionality into your application, making the process seamless and efficient.

## Features

- Easy integration with Google Sign-In
- Supports both Android and iOS platforms
- Provides a streamlined UI for phone number input and verification

## Installation

- To use this package, add `phone_sign_in` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

- And do the setup as stated in [Firebase Phone Authentication Setup](https://firebase.google.com/docs/auth/flutter/phone-auth#setup)


## Phone number input

If the user's phone number starts with '+', the phone number entered by the user is recognized as an international phone number format. And the app will ignore the selected country information, and the user will log in with the phone number they entered.

For example, if the user selects the country as 'Philippines' and then enters a US phone number like '+1 1111 1111 11' at the beginning, although the country selection is set to 'Philippines', it ignores this and attempts to log in to Firebase with the phone number '+1 1111 1111 11' entered by the user.

If the phone number begins with '0', then it will be removed. So, when you make the review phone number, don't make it begin with '0'.



## countryPickerOptions

- `countryPickerOptions`: allows you to select a country.

- Add this option to display country picker widget.

- If this option is omitted, the widget does not display the country selection on the screen.
  - If there is no country selection? then?
    - You may not need a country selection widget because you will only use your country code in your app.
    - Or, user may input the coutry code like `+82` along with the phone number.

- `moveAlongWithKeyboard`: by default, the search result may be hidden below the keypad. Set this to true, and the result will not be hidden beneath the keyboard.





## countryCode

When this option is enabled, the button for selecting the country code is hidden and the country code is set to a fixed value. Consequently, users are unable to modify the country selection.


## firebaseAuthLanguageCode

`firebaseAuthLanguageCode` is the default language used in Firebase phone number login. This is the same option used in Firebase Auth.


## onCompletePhoneNumber

The `PhoneSignIn` widget automatically formats the phone number entered by the user into an international number, based on the country selected.

However, if you wish to customize the international phone number, you can utilize the `onCompletePhoneNumber` callback. This function is invoked when the widget requires the phone number in an international format. It will only pass the phone number entered by the user, excluding the country code. Therefore, if you want to use the country code selected by the user, you should avoid setting this callback function and allow the widget to automatically construct the international phone number.

You might want to simplify the process for users by automatically adding the country code to their phone number. For example, in Korea, phone numbers always start with "010", and in the Philippines, they start with "09". So, if a user enters their phone number as "01012345678", you can programmatically update it to "+821012345678" to convert it into an international format. Similarly, if a user enters their phone number as "091212345678", you can update it to "+6391212345678".

This function is primarily used when `countryPickerOptions` and `countryCode` are not specified. In this case, since the user cannot select the country code on the screen, it is used to programmatically add the country code.

Note, if the phone number entered by the user starts with '+', the `onCompletePhoneNumber` function is not called. In other words, the widget recognizes the user's input as a complete international phone number and does not call the `onCompletePhoneNumber` function to convert it into an international format.

So, if `countryPickerOptions` and `countryCode` are not specified, and the user does not enter a phone number starting with '+', the `onCompletePhoneNumber` will be called and return the phone number in international format.

The `onCompletePhoneNumber` function receives the phone number entered by the user, stripped of unnecessary special characters. If the phone number starts with '0', it is removed. For example, if the user enters '010-1111-2222', '1011112222' is passed as a parameter.


## linkCurrentUser

if `linkCurrentUser` is set to true, it will attempts to link the current user account to the provided phone sign in credential, and if the provided phone sign account is already in used it will just perform a normal sign with the existing account. And if the user didn't signed in, it will just perform a normal sign in.


Note that, when the user signed as a phone number, he cannot link with another phone number credential. To know more about it, refer Firebase Auth documents.


## isPhoneNumberRegistered

When `linkCurrentUser` is set to true, this callback function must be set and return true if the phone number is already in use.



## onDisplayPhoneNumber

The `onDisplayPhoneNumber` function is a callback function that returns the phone number to be displayed on the screen. The value returned by the `onCompletePhoneNumber` function is used for Firebase phone sign-in, but the phone number this function returns is just for displaying on the screen in a user-friendly format.

For example, if only Korean people are signing up, you can fix the phone number code to `+82` through the `countryCode` option. In this case, it's more user-friendly to display the number as "010-1234-5678" instead of "+821012345678". That's what this function is for.

Especially after entering the phone number and sending the SMS code, you need to display the phone number on the screen. You can use this function to display the phone number in a user-friendly format.

The `onDisplayPhoneNumber` function receives the international phone number. More precisely, it receives the value returned by `onCompletePhoneNumber`.



## no country code picker

- If the app does not set `countryCode` and `countryPickerOption`, then the widget cannot make an international phone number. And the user cannot choose a country. But the user may input the international phone number by himself.


## countryCode

- For this option, specify a two-letter uppercase country code as a string value, such as 'KR' or 'PH'.

- If this option is set, the corresponding country code is fixed and the user cannot change the country.



## onSignInFailed

- If the phone number sign-in fails for various reasons, the `onSignInFailed` callback function is called. This function receives `FirebaseAuthException` as a parameter.


## specialAccount

The `specialAccount` option allows you to log in using methods other than phone number login, and it can simulate temporary phone number login for review. For example, if there is an error in phone number login during iOS review, or if you are asked to show the entire process of phone number login, you can use a review account.

- `reviewPhoneNumber` and `reviewSmsCode` are temporary phone numbers and SMS codes. `reviewPhoneNumber` must be stored in international phone number format like `+11234567890`. After the user's input phone number, the phone number is converted into an international phone number format, it is compared with `reviewPhoneNumber`. If they match, a review (temporary) login is performed. By setting this option, you can simulate the entire process of actual phone number login. These options can be used for review when submitting to the iOS Appstore.

- Don't make the review number begins with '0' since it will be removed.
  - For instance, If the developer set the review phone number as `+10123456789` and the user may choose the country code as `+1` and input the review number as `0123456789`, then the beginning `0` will be removed. And it will become `+1123456789` which is incorrect number.

- `reviewEmail` and `reviewPassword` are the email address and password for review that will be used to log in when a temporary phone number and SMS code are entered. If you log in with the above `reviewPhoneNumber` and `reviewSmsCode`, you do not actually log in with this phone number, but instead log in with this `reviewEmail`.

- If `emailLogin` is true, you can log in (auto-signup) with an email and password like `test@test.com:12345a` instead of a phone number.
  - If this option is set to true and the phone number entered by the user contains `@`, it signs up or logs in with email. Even if the user has selected a country, it ignores it and logs in with email. If it has not been registered before, it registers.
  - Note that if you only enter an email address without a password (for example, only `test@test.com` is entered), the password is set to be the same as the email address.

## Labels and Hints


### labelEmptyCountry

- `labelEmptyCountry` is a widget that will be displayed on the screen when no country is selected. When a country is selected, this widget disappears and the country information appears.


### labelPhoneNumber

- `labelPhoneNumber`: Displays a text on phone number


### labelPhoneNumberSelected

- `labelPhoneNumberSelected`: Display a text on phone number if the phone is selected.



### labelUnderPhoneNumberTextField

### labelVerifyPhoneNumberButton


### labelOnSmsCodeTextField

### labelRetry

### labelVerifySmsCodeButton

### labelCountryPicker

- `labelCountryPicker`: Displays a text (or any widget) on the country picker. This is used to dipslay the label on the phone number. The user will press on this label to open the country picker. See the example below to understand better.

### labelCountryPickerSelected

- `labelCountryPickerSelected`: Displays a text on the country picker. If this is given, it will be used instead of `labelCountryPicker` when the country is selected.
- Purpose of this parameter is to display different design when the country is selected.


### labelChangeCountry

### labelEmptyCountry

### hintTextPhoneNumberTextField

### hintTextSmsCodeTextField



## Error handling

If an error occurs, the `onSignInFailed` callback function is called and `FirebaseAuthException` is passed as an argument. You can use this error argument to appropriately notify the user of the error message.


```dart
PhoneSignIn(
  onSignInFailed: (FirebaseAuthException e) {
  if (e.code == 'web-context-cancelled') {
    print('The interaction was cancelled by the user.');
  } else if (e.code == 'missing-client-identifier') {
    print("We couldn't verify your phone number at the moment. Please ensure you entered a valid phone number and try again.");
  } else if (e.code == 'too-many-requests') {
    print('We have blocked all requests from this device due to unsual activity. Please try again later');
  } else if (e.code == 'invalid-verification-code') {
    print('Oops! Incorrect code, Please double-check the code sent to your phone and try again.');
  } else {
    dog(
      'FirebaseAuthException : $e',
    );
    throw e;
  }
}
```



## Examples

- For more detailed examples and usage, please refer to the `main.dart` file in the `example` directory.


### Display number in large font size

To adjust the font size of the phone number and hint texts, you can utilize `Theme.of(context).textTheme.copyWith()`. Here's an example of how to do it:

```dart
Theme(
  data: Theme.of(context).copyWith(
    textTheme: Theme.of(context).textTheme.copyWith(
          titleLarge: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 28,
          ),
        ),
  ),
  child: PhoneSignIn( /* ... */ ),
)
```

### Customize user input phone number with onCompletePhoneNumber

If a user enters a Korean phone number like "01012345678" and you want to convert it to an international phone number like "+821012345678", you can refer to the example code in the `phone_sign_in/example/lib/main.dart` source file.





### Example of complete phone sign in

Here's a comprehensive example code that includes country selection. Feel free to copy, paste, and tailor it to your application's needs.

```dart
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
          )


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
```



## Exceptions

- `Exception: @phone_sign_in/malformed-phone-number Phone number is empty or malformed.` will be thrown when the user input a invlaid phone number. You would meet this exception especially when the `emailLogin` is set to true, and you input email.

