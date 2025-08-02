import '../files/file.dart';

/// Represents a paginated list of files from the Replicate API
class PaginatedFiles {
  /// List of files in this page
  final List<ReplicateFile> results;

  /// URL for the next page, if available
  final String? next;

  /// URL for the previous page, if available
  final String? previous;

  const PaginatedFiles({
    required this.results,
    this.next,
    this.previous,
  });

  factory PaginatedFiles.fromJson(Map<String, dynamic> json) {
    return PaginatedFiles(
      results: (json['results'] as List<dynamic>)
          .map((item) => ReplicateFile.fromJson(item as Map<String, dynamic>))
          .toList(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );
  }

  /// Returns true if there is a next page available
  bool get hasNextPage => next != null;

  /// Returns true if there is a previous page available
  bool get hasPreviousPage => previous != null;

  @override
  String toString() {
    return 'PaginatedFiles(results: ${results.length} files, hasNext: $hasNextPage, hasPrevious: $hasPreviousPage)';
  }
}
