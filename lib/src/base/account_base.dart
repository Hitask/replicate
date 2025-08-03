import '../models/account/account.dart';

/// Abstract base class for account-related operations.
///
/// This class defines the interface for interacting with Replicate's account API,
/// which allows you to retrieve information about the authenticated user or organization.
abstract class AccountBase {
  /// Get information about the authenticated user or organization.
  ///
  /// Returns account details for the user or organization associated
  /// with the provided API token.
  ///
  /// Example:
  /// ```dart
  /// final account = await Replicate.instance.account.get();
  /// print('Account type: ${account.type}');
  /// print('Username: ${account.username}');
  /// print('Name: ${account.name}');
  /// if (account.githubUrl != null) {
  ///   print('GitHub: ${account.githubUrl}');
  /// }
  /// ```
  Future<ReplicateAccount> get();
}
