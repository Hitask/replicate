import 'package:replicate/src/network/builder/endpoint_url.dart';
import 'package:replicate/src/network/http_client.dart';

import '../../base/hardware_base.dart';
import '../../models/hardware/hardware.dart';

/// Implementation of the hardware API for Replicate.
///
/// This class provides methods to interact with Replicate's hardware API,
/// allowing you to retrieve information about available hardware options.
class ReplicateHardwareAPI implements HardwareBase {
  /// Gets a list of available hardware for models.
  ///
  /// Returns a list of hardware options that can be used when creating
  /// models or deployments. Each hardware option includes a human-readable
  /// name and an SKU identifier.
  ///
  /// Example:
  /// ```dart
  /// final hardwareList = await Replicate.instance.hardware.list();
  /// for (final hardware in hardwareList) {
  ///   print('Hardware: ${hardware.name}');
  ///   print('SKU: ${hardware.sku}');
  /// }
  /// ```
  ///
  /// The response will include hardware options like:
  /// - CPU
  /// - Nvidia T4 GPU  
  /// - Nvidia A40 GPU
  /// - Nvidia A40 (Large) GPU
  ///
  /// Throws [ReplicateException] for API errors.
  @override
  Future<List<ReplicateHardware>> list() async {
    final List<dynamic> response = await ReplicateHttpClient.getArray<List<dynamic>>(
      from: EndpointUrlBuilder.build(["hardware"]),
      onSuccess: (List<dynamic> jsonArray) {
        return jsonArray;
      },
    );

    return response
        .map((json) => ReplicateHardware.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
