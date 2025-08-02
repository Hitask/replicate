import 'package:test/test.dart';
import 'package:replicate/replicate.dart';
import 'package:replicate/src/instance/files/files.dart';

void main() {
  group('Files API', () {
    test('ReplicateFile model should serialize correctly', () {
      final json = {
        'id': 'test-file-id',
        'name': 'test-file.txt',
        'content_type': 'text/plain',
        'size': 1024,
        'metadata': {'description': 'Test file'},
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T01:00:00Z',
        'url': 'https://example.com/file.txt',
        'download_url': 'https://example.com/download/file.txt',
        'expires_at': '2023-01-01T02:00:00Z',
      };

      final file = ReplicateFile.fromJson(json);

      expect(file.id, equals('test-file-id'));
      expect(file.name, equals('test-file.txt'));
      expect(file.contentType, equals('text/plain'));
      expect(file.size, equals(1024));
      expect(file.metadata, equals({'description': 'Test file'}));
      expect(file.createdAt, equals(DateTime.parse('2023-01-01T00:00:00Z')));
      expect(file.updatedAt, equals(DateTime.parse('2023-01-01T01:00:00Z')));
      expect(file.url, equals('https://example.com/file.txt'));
      expect(file.downloadUrl, equals('https://example.com/download/file.txt'));
      expect(file.expiresAt, equals(DateTime.parse('2023-01-01T02:00:00Z')));
    });

    test('ReplicateFile model should handle null values correctly', () {
      final json = {
        'id': 'test-file-id',
        'name': 'test-file.txt',
        'content_type': 'text/plain',
        'size': 1024,
        'created_at': '2023-01-01T00:00:00Z',
      };

      final file = ReplicateFile.fromJson(json);

      expect(file.id, equals('test-file-id'));
      expect(file.name, equals('test-file.txt'));
      expect(file.contentType, equals('text/plain'));
      expect(file.size, equals(1024));
      expect(file.metadata, isNull);
      expect(file.updatedAt, isNull);
      expect(file.url, isNull);
      expect(file.downloadUrl, isNull);
      expect(file.expiresAt, isNull);
    });

    test('PaginatedFiles model should deserialize correctly', () {
      final json = {
        'results': [
          {
            'id': 'file1',
            'name': 'file1.txt',
            'content_type': 'text/plain',
            'size': 100,
            'created_at': '2023-01-01T00:00:00Z',
          },
          {
            'id': 'file2',
            'name': 'file2.txt',
            'content_type': 'text/plain',
            'size': 200,
            'created_at': '2023-01-01T00:00:00Z',
          },
        ],
        'next': 'https://api.replicate.com/v1/files?cursor=next',
        'previous': null,
      };

      final paginatedFiles = PaginatedFiles.fromJson(json);

      expect(paginatedFiles.results.length, equals(2));
      expect(paginatedFiles.results[0].id, equals('file1'));
      expect(paginatedFiles.results[1].id, equals('file2'));
      expect(paginatedFiles.next,
          equals('https://api.replicate.com/v1/files?cursor=next'));
      expect(paginatedFiles.previous, isNull);
      expect(paginatedFiles.hasNextPage, isTrue);
      expect(paginatedFiles.hasPreviousPage, isFalse);
    });

    test('ReplicateFile equality should work correctly', () {
      final file1 = ReplicateFile(
        id: 'test-id',
        name: 'test.txt',
        contentType: 'text/plain',
        size: 100,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      final file2 = ReplicateFile(
        id: 'test-id',
        name: 'different.txt',
        contentType: 'text/plain',
        size: 200,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      final file3 = ReplicateFile(
        id: 'different-id',
        name: 'test.txt',
        contentType: 'text/plain',
        size: 100,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      expect(file1, equals(file2)); // Same ID
      expect(file1, isNot(equals(file3))); // Different ID
      expect(file1.hashCode, equals(file2.hashCode));
      expect(file1.hashCode, isNot(equals(file3.hashCode)));
    });

    test('ReplicateFiles API should be accessible from Replicate instance', () {
      // Set a dummy API key for testing the structure
      Replicate.apiKey = 'test-api-key';

      // This test just verifies the API structure is correct
      expect(Replicate.instance, isA<Replicate>());
      expect(Replicate.instance.files, isA<ReplicateFiles>());
      // Note: We can't test the actual API calls without a real API key
      // and network access, but we can verify the interface exists
    });
  });
}
