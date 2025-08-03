import 'package:equatable/equatable.dart';

/// Represents account information for the authenticated user or organization.
///
/// This model contains the account details returned by the Account API,
/// including the account type, username, display name, and optional GitHub URL.
class ReplicateAccount extends Equatable {
  /// The type of account. Can be "user" or "organization".
  final String type;

  /// The username of the user or organization.
  final String username;

  /// The display name of the user or organization.
  final String name;

  /// The GitHub URL of the user or organization (optional).
  final String? githubUrl;

  const ReplicateAccount({
    required this.type,
    required this.username,
    required this.name,
    this.githubUrl,
  });

  /// Creates a [ReplicateAccount] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize the API response
  /// into a [ReplicateAccount] object.
  factory ReplicateAccount.fromJson(Map<String, dynamic> json) {
    return ReplicateAccount(
      type: json['type'],
      username: json['username'],
      name: json['name'],
      githubUrl: json['github_url'],
    );
  }

  /// Converts this [ReplicateAccount] instance to a JSON map.
  ///
  /// This method is useful for serializing the account data.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'username': username,
      'name': name,
      'github_url': githubUrl,
    };
  }

  @override
  List<Object?> get props => [
        type,
        username,
        name,
        githubUrl,
      ];

  @override
  String toString() {
    return 'ReplicateAccount(type: $type, username: $username, name: $name, githubUrl: $githubUrl)';
  }
}
