/// Represents a file uploaded to Replicate
class ReplicateFile {
  /// The unique identifier for the file
  final String id;

  /// The filename
  final String name;

  /// The content type (MIME type) of the file
  final String contentType;

  /// The size of the file in bytes
  final int size;

  /// User-provided metadata associated with the file
  final Map<String, dynamic>? metadata;

  /// The date and time the file was created
  final DateTime createdAt;

  /// The date and time the file was last updated
  final DateTime? updatedAt;

  /// URL to access the file
  final String? url;

  /// Download URL for the file (temporary, signed URL)
  final String? downloadUrl;

  /// The expiry timestamp for the download URL
  final DateTime? expiresAt;

  const ReplicateFile({
    required this.id,
    required this.name,
    required this.contentType,
    required this.size,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
    this.url,
    this.downloadUrl,
    this.expiresAt,
  });

  factory ReplicateFile.fromJson(Map<String, dynamic> json) {
    return ReplicateFile(
      id: json['id'] as String,
      name: json['name'] as String,
      contentType: json['content_type'] as String,
      size: json['size'] as int,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      url: json['url'] as String?,
      downloadUrl: json['download_url'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content_type': contentType,
      'size': size,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'url': url,
      'download_url': downloadUrl,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ReplicateFile(id: $id, name: $name, contentType: $contentType, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReplicateFile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
