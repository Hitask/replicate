import 'dart:io';
import '../models/files/file.dart';
import '../models/files/paginated_files.dart';

abstract class ReplicateFilesBase
    implements ListFiles, CreateFile, DeleteFile, GetFile {}

abstract class ListFiles {
  /// Get a paginated list of all files created by the user or organization
  Future<PaginatedFiles> list();
}

abstract class CreateFile {
  /// Create a file by uploading its content
  Future<ReplicateFile> create({
    required File file,
    required String filename,
    String? contentType,
    Map<String, dynamic>? metadata,
  });
}

abstract class DeleteFile {
  /// Delete a file by its ID
  Future<void> delete({
    required String fileId,
  });
}

abstract class GetFile {
  /// Get the details of a file by its ID
  Future<ReplicateFile> get({
    required String fileId,
  });
}
