import 'training.dart';

/// Represents a paginated response of training objects from the Replicate API.
class PaginatedTrainings {
  /// The list of training objects in this page.
  final List<ReplicateTraining> results;

  /// URL to get the next page of results, if any.
  final String? next;

  /// URL to get the previous page of results, if any.
  final String? previous;

  const PaginatedTrainings({
    required this.results,
    this.next,
    this.previous,
  });

  /// Creates a [PaginatedTrainings] from a JSON object.
  factory PaginatedTrainings.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>;
    final trainings = resultsJson
        .map((trainingJson) =>
            ReplicateTraining.fromJson(trainingJson as Map<String, dynamic>))
        .toList();

    return PaginatedTrainings(
      results: trainings,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );
  }

  /// Whether there are more results available (next page exists).
  bool get hasNextPage => next != null;

  /// Whether there are previous results available (previous page exists).
  bool get hasPreviousPage => previous != null;

  /// The total number of trainings in this page.
  int get count => results.length;

  /// Whether this page is empty.
  bool get isEmpty => results.isEmpty;

  /// Whether this page contains results.
  bool get isNotEmpty => results.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedTrainings &&
          runtimeType == other.runtimeType &&
          results == other.results &&
          next == other.next &&
          previous == other.previous;

  @override
  int get hashCode => results.hashCode ^ next.hashCode ^ previous.hashCode;

  @override
  String toString() {
    return 'PaginatedTrainings{count: $count, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage}';
  }
}
