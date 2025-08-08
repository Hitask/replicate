/// Represents a hardware option available for running models on Replicate.
///
/// Hardware options define the computational resources (CPU, GPU types)
/// that can be used when creating models or deployments.
class ReplicateHardware {
  /// The human-readable name of the hardware.
  /// 
  /// Examples: "CPU", "Nvidia T4 GPU", "Nvidia A40 GPU", "Nvidia A40 (Large) GPU"
  final String name;

  /// The SKU (stock keeping unit) identifier for the hardware.
  /// 
  /// This is used when creating models or deployments to specify which hardware to use.
  /// Examples: "cpu", "gpu-t4", "gpu-a40-small", "gpu-a40-large"
  final String sku;

  /// Creates a new [ReplicateHardware] instance.
  const ReplicateHardware({
    required this.name,
    required this.sku,
  });

  /// Creates a [ReplicateHardware] instance from a JSON map.
  ///
  /// The JSON should contain:
  /// - `name`: The human-readable name of the hardware
  /// - `sku`: The SKU identifier for the hardware
  factory ReplicateHardware.fromJson(Map<String, dynamic> json) {
    return ReplicateHardware(
      name: json['name'] as String,
      sku: json['sku'] as String,
    );
  }

  /// Converts this [ReplicateHardware] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
    };
  }

  /// Returns a string representation of this hardware option.
  @override
  String toString() {
    return 'ReplicateHardware(name: $name, sku: $sku)';
  }

  /// Checks if this hardware option is equal to another.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReplicateHardware &&
        other.name == name &&
        other.sku == sku;
  }

  /// Returns the hash code for this hardware option.
  @override
  int get hashCode => Object.hash(name, sku);
}
