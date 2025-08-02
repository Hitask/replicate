import 'dart:io';
import 'package:replicate/src/network/builder/endpoint_url.dart';
import 'package:replicate/src/network/http_client.dart';

import '../../base/files_base.dart';
import '../../models/files/file.dart';
import '../../models/files/paginated_files.dart';

/// This is the responsible member of the Replicate's files API, where you can call the methods to list, create, get and delete files.
class ReplicateFiles implements ReplicateFilesBase {
  /// Get a paginated list of all files created by the user or organization.
  ///
  /// Example:
  /// ```dart
  /// PaginatedFiles files = await Replicate.instance.files.list();
  /// print(files.results);
  /// ```
  @override
  Future<PaginatedFiles> list() async {
    return await ReplicateHttpClient.get<PaginatedFiles>(
      from: EndpointUrlBuilder.build(['files']),
      onSuccess: (Map<String, dynamic> response) {
        return PaginatedFiles.fromJson(response);
      },
    );
  }

  /// Create a file by uploading its content and optional metadata.
  ///
  /// [file] is the file to upload
  /// [filename] is the name for the file (required, ≤ 255 bytes, valid UTF-8)
  /// [contentType] is the MIME type for the file (defaults to application/octet-stream)
  /// [metadata] is user-provided metadata associated with the file (defaults to {}, must be valid JSON)
  ///
  /// Example:
  /// ```dart
  /// File file = File('/path/to/image.jpg');
  /// ReplicateFile uploadedFile = await Replicate.instance.files.create(
  ///   file: file,
  ///   filename: 'my-image.jpg',
  ///   contentType: 'image/jpeg',
  ///   metadata: {'description': 'A beautiful landscape'},
  /// );
  /// print(uploadedFile.id);
  /// ```
  @override
  Future<ReplicateFile> create({
    required File file,
    required String filename,
    String? contentType,
    Map<String, dynamic>? metadata,
  }) async {
    return await ReplicateHttpClient.postMultipart<ReplicateFile>(
      to: EndpointUrlBuilder.build(['files']),
      file: file,
      filename: filename,
      contentType: contentType,
      metadata: metadata,
      onSuccess: (Map<String, dynamic> response) {
        return ReplicateFile.fromJson(response);
      },
    );
  }

  /// Delete a file by its ID. Once a file has been deleted, subsequent requests
  /// to the file resource return 404 Not found.
  ///
  /// [fileId] is the ID of the file to delete
  ///
  /// Example:
  /// ```dart
  /// await Replicate.instance.files.delete(fileId: 'file-id');
  /// ```
  @override
  Future<void> delete({
    required String fileId,
  }) async {
    return await ReplicateHttpClient.delete(
      from: EndpointUrlBuilder.build(['files', fileId]),
      onSuccess: () {},
    );
  }

  /// Get the details of a file by its ID.
  ///
  /// [fileId] is the ID of the file to get
  ///
  /// Example:
  /// ```dart
  /// ReplicateFile file = await Replicate.instance.files.get(fileId: 'file-id');
  /// print(file.name);
  /// ```
  @override
  Future<ReplicateFile> get({
    required String fileId,
  }) async {
    return await ReplicateHttpClient.get<ReplicateFile>(
      from: EndpointUrlBuilder.build(['files', fileId]),
      onSuccess: (Map<String, dynamic> response) {
        return ReplicateFile.fromJson(response);
      },
    );
  }
}
