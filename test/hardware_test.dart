import 'package:test/test.dart';
import 'package:replicate/replicate.dart';

void main() {
  group('Hardware API Implementation', () {
    test('ReplicateHardware model should create from JSON', () {
      final json = {
        'name': 'Nvidia T4 GPU',
        'sku': 'gpu-t4',
      };

      final hardware = ReplicateHardware.fromJson(json);

      expect(hardware.name, equals('Nvidia T4 GPU'));
      expect(hardware.sku, equals('gpu-t4'));
    });

    test('ReplicateHardware model should convert to JSON', () {
      final hardware = ReplicateHardware(
        name: 'CPU',
        sku: 'cpu',
      );

      final json = hardware.toJson();

      expect(json['name'], equals('CPU'));
      expect(json['sku'], equals('cpu'));
    });

    test('ReplicateHardware model should implement equality', () {
      final hardware1 = ReplicateHardware(name: 'CPU', sku: 'cpu');
      final hardware2 = ReplicateHardware(name: 'CPU', sku: 'cpu');
      final hardware3 = ReplicateHardware(name: 'GPU', sku: 'gpu-t4');

      expect(hardware1, equals(hardware2));
      expect(hardware1, isNot(equals(hardware3)));
    });

    test('ReplicateHardware model should have proper toString', () {
      final hardware = ReplicateHardware(name: 'CPU', sku: 'cpu');
      final str = hardware.toString();

      expect(str, contains('ReplicateHardware'));
      expect(str, contains('CPU'));
      expect(str, contains('cpu'));
    });

    test('Replicate instance should have hardware property', () {
      // This will throw because no API key is set, but we can verify the hardware getter exists
      expect(() {
        Replicate.apiKey = "test-key";
        return Replicate.instance.hardware;
      }, returnsNormally);
    });

    test('Hardware API should have list method with correct signature', () {
      Replicate.apiKey = "test-key";
      final hardware = Replicate.instance.hardware;
      
      // Verify the list method exists and returns the correct type
      expect(hardware.list, isA<Function>());
      expect(hardware.list(), isA<Future<List<ReplicateHardware>>>());
    });
  });

  group('Hardware API Edge Cases', () {
    test('ReplicateHardware should handle empty JSON gracefully', () {
      expect(() => ReplicateHardware.fromJson({}), throwsA(isA<TypeError>()));
    });

    test('ReplicateHardware should handle null values in JSON', () {
      final json = {
        'name': null,
        'sku': null,
      };

      expect(() => ReplicateHardware.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('ReplicateHardware hashCode should be consistent', () {
      final hardware1 = ReplicateHardware(name: 'CPU', sku: 'cpu');
      final hardware2 = ReplicateHardware(name: 'CPU', sku: 'cpu');

      expect(hardware1.hashCode, equals(hardware2.hashCode));
    });

    test('ReplicateHardware should handle special characters in names', () {
      final hardware = ReplicateHardware(
        name: 'Nvidia A40 (Large) GPU',
        sku: 'gpu-a40-large',
      );

      final json = hardware.toJson();
      final recreated = ReplicateHardware.fromJson(json);

      expect(recreated.name, equals('Nvidia A40 (Large) GPU'));
      expect(recreated.sku, equals('gpu-a40-large'));
      expect(recreated, equals(hardware));
    });
  });
}
