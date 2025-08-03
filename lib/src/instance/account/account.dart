import '../../base/account_base.dart';
import '../../models/account/account.dart';
import '../../network/builder/endpoint_url.dart';
import '../../network/http_client.dart';

/// Implementation of account-related operations for the Replicate API.
///
/// This class handles retrieving information about the authenticated
/// user or organization associated with the provided API token.
class ReplicateAccountAPI extends AccountBase {
  /// Get information about the authenticated user or organization.
  ///
  /// Returns a [ReplicateAccount] object containing account details
  /// for the user or organization associated with the provided API token.
  ///
  /// The response includes:
  /// - Account type ("user" or "organization")
  /// - Username
  /// - Display name
  /// - Optional GitHub URL
  ///
  /// Example:
  /// ```dart
  /// final account = await Replicate.instance.account.get();
  /// print('Logged in as: ${account.username} (${account.type})');
  /// print('Display name: ${account.name}');
  ///
  /// if (account.githubUrl != null) {
  ///   print('GitHub profile: ${account.githubUrl}');
  /// }
  /// ```
  ///
  /// Throws an exception if the API request fails or if the API key is invalid.
  @override
  Future<ReplicateAccount> get() async {
    return await ReplicateHttpClient.get<ReplicateAccount>(
      from: EndpointUrlBuilder.build(['account']),
      onSuccess: (Map<String, dynamic> response) {
        return ReplicateAccount.fromJson(response);
      },
    );
  }
}
