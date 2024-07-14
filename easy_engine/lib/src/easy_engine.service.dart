import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EasyEngineService {
  static EasyEngineService? _instance;
  static EasyEngineService get instance => _instance ??= EasyEngineService._();

  EasyEngineService._();

  /// [region] is the region of the Firebase Cloud Functions.
  ///
  /// If it is null, it will use the default region.
  ///
  /// Each function call may have its own region parameter.
  String? region;

  void init({
    String? region,
  }) {
    // init code
    this.region = region;
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
    if (region != null) {
      functions = FirebaseFunctions.instanceFor(region: region);
    }
    final HttpsCallable callable = functions.httpsCallable('claimAdmin');
    final result = await callable.call({
      'uid': FirebaseAuth.instance.currentUser?.uid,
    });
    return result.data;
  }
}
