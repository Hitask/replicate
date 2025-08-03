import '../predictions/sub_models/metrics.dart';
import '../predictions/sub_models/urls.dart';

/// Represents a training job in Replicate.
///
/// A training creates a new version of a model by fine-tuning it with custom data.
class ReplicateTraining {
  /// The unique ID of the training.
  final String id;

  /// The model identifier in the format `{owner}/{name}`.
  final String model;

  /// The ID of the model version used for training.
  final String version;

  /// The input data and parameters for the training.
  final Map<String, dynamic> input;

  /// The training logs.
  final String? logs;

  /// Any error that occurred during training.
  final String? error;

  /// The current status of the training.
  ///
  /// Possible values:
  /// - `starting`: the training is starting up
  /// - `processing`: the train() method is currently running
  /// - `succeeded`: the training completed successfully
  /// - `failed`: the training encountered an error
  /// - `canceled`: the training was canceled
  final String status;

  /// The time when the training was created.
  final DateTime createdAt;

  /// The time when the training started processing.
  final DateTime? startedAt;

  /// The time when the training completed.
  final DateTime? completedAt;

  /// The output of the training (weights, version info, etc.).
  final Map<String, dynamic>? output;

  /// Performance metrics for the training.
  final PredictionMetrics? metrics;

  /// URLs related to this training (web view, API endpoints).
  final PredictionUrls urls;

  /// How the training was created ('web' or 'api').
  final String? source;

  /// Whether the training data has been removed.
  final bool? dataRemoved;

  const ReplicateTraining({
    required this.id,
    required this.model,
    required this.version,
    required this.input,
    this.logs,
    this.error,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.output,
    this.metrics,
    required this.urls,
    this.source,
    this.dataRemoved,
  });

  /// Creates a [ReplicateTraining] from a JSON object.
  factory ReplicateTraining.fromJson(Map<String, dynamic> json) {
    return ReplicateTraining(
      id: json['id'] as String,
      model: json['model'] as String,
      version: json['version'] as String,
      input: Map<String, dynamic>.from(json['input'] as Map),
      logs: json['logs'] as String?,
      error: json['error'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      output: json['output'] as Map<String, dynamic>?,
      metrics: json['metrics'] != null
          ? PredictionMetrics.fromJson(json['metrics'] as Map<String, dynamic>)
          : null,
      urls: PredictionUrls.fromJson(json['urls'] as Map<String, dynamic>),
      source: json['source'] as String?,
      dataRemoved: json['data_removed'] as bool?,
    );
  }

  /// Converts this [ReplicateTraining] to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'version': version,
      'input': input,
      'logs': logs,
      'error': error,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'output': output,
      'source': source,
      'data_removed': dataRemoved,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplicateTraining &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          model == other.model &&
          version == other.version;

  @override
  int get hashCode => id.hashCode ^ model.hashCode ^ version.hashCode;

  @override
  String toString() {
    return 'ReplicateTraining{id: $id, model: $model, status: $status, createdAt: $createdAt}';
  }

  /// Whether the training is currently running.
  bool get isRunning => status == 'starting' || status == 'processing';

  /// Whether the training has completed (succeeded, failed, or canceled).
  bool get isCompleted =>
      status == 'succeeded' || status == 'failed' || status == 'canceled';

  /// Whether the training completed successfully.
  bool get isSucceeded => status == 'succeeded';

  /// Whether the training failed.
  bool get isFailed => status == 'failed';

  /// Whether the training was canceled.
  bool get isCanceled => status == 'canceled';
}
