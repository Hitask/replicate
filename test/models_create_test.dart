import 'package:test/test.dart';
import 'package:replicate/src/instance/models/models.dart';

void main() {
  group('ReplicateModels create method', () {
    test('create method exists and has correct signature', () {
      final models = ReplicateModels();

      // Test that the method exists and can be called with required parameters
      expect(
        () => models.create(
          owner: 'test-owner',
          name: 'test-model',
          description: 'A test model',
          visibility: 'public',
          hardware: 'cpu',
        ),
        throwsA(isA<
            Exception>()), // Will throw due to no API key, but method exists
      );
    });

    test('create method accepts optional parameters', () {
      final models = ReplicateModels();

      // Test that the method accepts optional parameters
      expect(
        () => models.create(
          owner: 'test-owner',
          name: 'test-model',
          description: 'A test model',
          visibility: 'public',
          hardware: 'cpu',
          coverImageUrl: 'https://example.com/image.jpg',
          githubUrl: 'https://github.com/user/repo',
          licenseUrl: 'https://example.com/license',
          paperUrl: 'https://example.com/paper',
        ),
        throwsA(isA<
            Exception>()), // Will throw due to no API key, but method exists
      );
    });
  });
}
