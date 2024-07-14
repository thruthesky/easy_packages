import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class EasyEngineService {
  static EasyEngineService? _instance;
  static EasyEngineService get instance => _instance ??= EasyEngineService._();

  EasyEngineService._();

  /// [defaultRegion] is the region of the Firebase Cloud Functions.
  ///
  /// If it is null, it will use the default region.
  ///
  /// Each function call may have its own region parameter.
  String? defaultRegion;

  void init({
    String? region,
  }) {
    // init code
    defaultRegion = region;
  }

  /// Claim a user as an admin.
  ///
  /// Calls the OnCall Firebase Cloud Function to claim a user as an admin.
  ///
  /// [region] is the region of the Firebase Cloud Functions.
  Future<String> claimAdmin({
    String? region,
  }) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;

    functions = FirebaseFunctions.instanceFor(
      region: region ?? defaultRegion,
    );

    final HttpsCallable callable =
        functions.httpsCallable('ext-easy-extensions-claimAdmin');
    try {
      final result = await callable.call();
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      log("e.code: ${e.code}, e.message: ${e.message}, e.details: ${e.details}");
      rethrow;
    }
  }
}
