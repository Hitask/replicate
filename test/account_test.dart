import 'package:test/test.dart';
import 'package:replicate/src/instance/account/account.dart';
import 'package:replicate/src/models/account/account.dart';

void main() {
  group('Account API Models', () {
    test('ReplicateAccount.fromJson should parse account data correctly', () {
      final json = {
        'type': 'organization',
        'username': 'acme',
        'name': 'Acme Corp, Inc.',
        'github_url': 'https://github.com/acme',
      };

      final account = ReplicateAccount.fromJson(json);

      expect(account.type, 'organization');
      expect(account.username, 'acme');
      expect(account.name, 'Acme Corp, Inc.');
      expect(account.githubUrl, 'https://github.com/acme');
    });

    test('ReplicateAccount.fromJson should handle null github_url', () {
      final json = {
        'type': 'user',
        'username': 'john_doe',
        'name': 'John Doe',
        'github_url': null,
      };

      final account = ReplicateAccount.fromJson(json);

      expect(account.type, 'user');
      expect(account.username, 'john_doe');
      expect(account.name, 'John Doe');
      expect(account.githubUrl, isNull);
    });

    test('ReplicateAccount.toJson should serialize correctly', () {
      final account = ReplicateAccount(
        type: 'organization',
        username: 'acme',
        name: 'Acme Corp, Inc.',
        githubUrl: 'https://github.com/acme',
      );

      final json = account.toJson();

      expect(json['type'], 'organization');
      expect(json['username'], 'acme');
      expect(json['name'], 'Acme Corp, Inc.');
      expect(json['github_url'], 'https://github.com/acme');
    });

    test('ReplicateAccount should support equality comparison', () {
      final account1 = ReplicateAccount(
        type: 'user',
        username: 'john_doe',
        name: 'John Doe',
        githubUrl: 'https://github.com/john_doe',
      );

      final account2 = ReplicateAccount(
        type: 'user',
        username: 'john_doe',
        name: 'John Doe',
        githubUrl: 'https://github.com/john_doe',
      );

      final account3 = ReplicateAccount(
        type: 'user',
        username: 'jane_doe',
        name: 'Jane Doe',
        githubUrl: 'https://github.com/jane_doe',
      );

      expect(account1, equals(account2));
      expect(account1, isNot(equals(account3)));
    });

    test('ReplicateAccount toString should return readable format', () {
      final account = ReplicateAccount(
        type: 'organization',
        username: 'acme',
        name: 'Acme Corp, Inc.',
        githubUrl: 'https://github.com/acme',
      );

      final stringRepresentation = account.toString();

      expect(stringRepresentation, contains('ReplicateAccount'));
      expect(stringRepresentation, contains('organization'));
      expect(stringRepresentation, contains('acme'));
      expect(stringRepresentation, contains('Acme Corp, Inc.'));
      expect(stringRepresentation, contains('https://github.com/acme'));
    });
  });

  group('Account API Implementation', () {
    test('ReplicateAccountAPI should have get method', () {
      final accountAPI = ReplicateAccountAPI();

      // Test that the method exists and can be called
      // Note: This will throw due to no API key, but method exists
      expect(
        () => accountAPI.get(),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
