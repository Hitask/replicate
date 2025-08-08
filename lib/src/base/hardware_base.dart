import '../models/hardware/hardware.dart';

/// Abstract base class for hardware-related operations.
///
/// This class defines the interface for interacting with Replicate's hardware API,
/// which allows you to retrieve information about available hardware options
/// for running models and deployments.
abstract class HardwareBase {
  /// Get a list of available hardware for models.
  ///
  /// Returns a list of hardware options that can be used when creating
  /// models or deployments. Each hardware option includes a human-readable
  /// name and an SKU identifier.
  ///
  /// Example:
  /// ```dart
  /// final hardwareList = await Replicate.instance.hardware.list();
  /// for (final hardware in hardwareList) {
  ///   print('${hardware.name}: ${hardware.sku}');
  /// }
  /// ```
  ///
  /// Throws [ReplicateException] for API errors.
  Future<List<ReplicateHardware>> list();
}
