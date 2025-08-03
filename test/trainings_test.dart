import 'package:test/test.dart';
import 'package:replicate/replicate.dart';
import 'package:replicate/src/instance/trainings/trainings.dart';

void main() {
  // Note: These are unit tests for the Training API structure and models.
  // They don't make actual API calls since that would require a valid API key
  // and could incur costs.

  group('Training API Models', () {
    test('ReplicateTraining.fromJson should parse training data correctly', () {
      final json = {
        'id': 'zz4ibbonubfz7carwiefibzgga',
        'model': 'stability-ai/sdxl',
        'version':
            'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf',
        'input': {
          'input_images': 'https://example.com/training-data.zip',
          'caption': 'A photo of a TOK person',
        },
        'logs': 'Training started...',
        'error': null,
        'status': 'processing',
        'created_at': '2023-09-08T16:32:57.018467Z',
        'started_at': '2023-09-08T16:33:00.123456Z',
        'completed_at': null,
        'output': null,
        'metrics': {'predict_time': 502.713876},
        'urls': {
          'get':
              'https://api.replicate.com/v1/trainings/zz4ibbonubfz7carwiefibzgga',
          'cancel':
              'https://api.replicate.com/v1/trainings/zz4ibbonubfz7carwiefibzgga/cancel'
        },
        'source': 'api',
        'data_removed': false,
      };

      final training = ReplicateTraining.fromJson(json);

      expect(training.id, equals('zz4ibbonubfz7carwiefibzgga'));
      expect(training.model, equals('stability-ai/sdxl'));
      expect(
          training.version,
          equals(
              'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf'));
      expect(training.status, equals('processing'));
      expect(training.logs, equals('Training started...'));
      expect(training.error, isNull);
      expect(training.input['input_images'],
          equals('https://example.com/training-data.zip'));
      expect(training.createdAt,
          equals(DateTime.parse('2023-09-08T16:32:57.018467Z')));
      expect(training.startedAt,
          equals(DateTime.parse('2023-09-08T16:33:00.123456Z')));
      expect(training.completedAt, isNull);
      expect(training.output, isNull);
      expect(training.metrics?.predictTime, equals(502.713876));
      expect(training.source, equals('api'));
      expect(training.dataRemoved, equals(false));
    });

    test('ReplicateTraining status helpers should work correctly', () {
      final processingTraining = ReplicateTraining.fromJson({
        'id': 'test-id',
        'model': 'test/model',
        'version': 'test-version',
        'input': {},
        'status': 'processing',
        'created_at': '2023-09-08T16:32:57.018467Z',
        'urls': {
          'get': 'https://example.com/get',
          'cancel': 'https://example.com/cancel'
        },
      });

      expect(processingTraining.isRunning, isTrue);
      expect(processingTraining.isCompleted, isFalse);
      expect(processingTraining.isSucceeded, isFalse);
      expect(processingTraining.isFailed, isFalse);
      expect(processingTraining.isCanceled, isFalse);

      final succeededTraining = ReplicateTraining.fromJson({
        'id': 'test-id',
        'model': 'test/model',
        'version': 'test-version',
        'input': {},
        'status': 'succeeded',
        'created_at': '2023-09-08T16:32:57.018467Z',
        'urls': {
          'get': 'https://example.com/get',
          'cancel': 'https://example.com/cancel'
        },
      });

      expect(succeededTraining.isRunning, isFalse);
      expect(succeededTraining.isCompleted, isTrue);
      expect(succeededTraining.isSucceeded, isTrue);
      expect(succeededTraining.isFailed, isFalse);
      expect(succeededTraining.isCanceled, isFalse);
    });

    test('PaginatedTrainings.fromJson should parse paginated data correctly',
        () {
      final json = {
        'next': 'https://api.replicate.com/v1/trainings?cursor=next-cursor',
        'previous': null,
        'results': [
          {
            'id': 'training-1',
            'model': 'test/model',
            'version': 'version-1',
            'input': {'param': 'value1'},
            'status': 'succeeded',
            'created_at': '2023-09-08T16:32:57.018467Z',
            'urls': {
              'get': 'https://example.com/get1',
              'cancel': 'https://example.com/cancel1'
            },
          },
          {
            'id': 'training-2',
            'model': 'test/model',
            'version': 'version-2',
            'input': {'param': 'value2'},
            'status': 'processing',
            'created_at': '2023-09-08T17:32:57.018467Z',
            'urls': {
              'get': 'https://example.com/get2',
              'cancel': 'https://example.com/cancel2'
            },
          },
        ],
      };

      final paginatedTrainings = PaginatedTrainings.fromJson(json);

      expect(paginatedTrainings.hasNextPage, isTrue);
      expect(paginatedTrainings.hasPreviousPage, isFalse);
      expect(paginatedTrainings.count, equals(2));
      expect(paginatedTrainings.isEmpty, isFalse);
      expect(paginatedTrainings.isNotEmpty, isTrue);

      expect(paginatedTrainings.results[0].id, equals('training-1'));
      expect(paginatedTrainings.results[0].status, equals('succeeded'));
      expect(paginatedTrainings.results[1].id, equals('training-2'));
      expect(paginatedTrainings.results[1].status, equals('processing'));
    });

    test('PaginatedTrainings should handle empty results', () {
      final json = {
        'next': null,
        'previous': null,
        'results': [],
      };

      final paginatedTrainings = PaginatedTrainings.fromJson(json);

      expect(paginatedTrainings.hasNextPage, isFalse);
      expect(paginatedTrainings.hasPreviousPage, isFalse);
      expect(paginatedTrainings.count, equals(0));
      expect(paginatedTrainings.isEmpty, isTrue);
      expect(paginatedTrainings.isNotEmpty, isFalse);
    });
  });

  group('Training API Integration', () {
    test('ReplicateTrainings instance should be accessible', () {
      // This test verifies that the training API is properly integrated
      // into the main Replicate class structure.

      // Note: We can't test with a real API key in unit tests,
      // but we can verify the structure is correct.
      expect(() => ReplicateTrainings(), returnsNormally);
    });

    test('Training API should be accessible through Replicate.instance', () {
      // Set a dummy API key to bypass the validation
      Replicate.apiKey = 'test-api-key';

      // Test that we can access the trainings API
      expect(Replicate.instance.trainings, isA<ReplicateTrainings>());
    });
  });
}
