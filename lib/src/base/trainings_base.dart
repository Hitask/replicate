import '../models/trainings/training.dart';
import '../models/trainings/paginated_trainings.dart';

/// Abstract base class for training-related operations.
///
/// This class defines the interface for interacting with Replicate's training API,
/// which allows you to create, manage, and monitor training jobs.
abstract class TrainingsBase {
  /// Create a new training for a model version.
  ///
  /// [modelOwner] is the username of the model owner.
  /// [modelName] is the name of the model.
  /// [versionId] is the ID of the model version to train.
  /// [destination] is the target model identifier in format "owner/name".
  /// [input] contains the training parameters and data.
  /// [webhook] is an optional URL for receiving training status updates.
  /// [webhookEventsFilter] specifies which events trigger webhooks.
  ///
  /// Returns a [ReplicateTraining] object representing the created training.
  ///
  /// Example:
  /// ```dart
  /// final training = await Replicate.instance.trainings.create(
  ///   modelOwner: 'stability-ai',
  ///   modelName: 'sdxl',
  ///   versionId: 'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf',
  ///   destination: 'my-username/my-custom-model',
  ///   input: {
  ///     'input_images': 'https://example.com/training-data.zip',
  ///     'caption': 'A photo of a TOK person',
  ///   },
  /// );
  /// ```
  Future<ReplicateTraining> create({
    required String modelOwner,
    required String modelName,
    required String versionId,
    required String destination,
    required Map<String, dynamic> input,
    String? webhook,
    List<String>? webhookEventsFilter,
  });

  /// Get the current state of a training.
  ///
  /// [trainingId] is the ID of the training to retrieve.
  ///
  /// Returns a [ReplicateTraining] object with the current training state.
  ///
  /// Example:
  /// ```dart
  /// final training = await Replicate.instance.trainings.get(
  ///   trainingId: 'zz4ibbonubfz7carwiefibzgga',
  /// );
  /// print('Training status: ${training.status}');
  /// ```
  Future<ReplicateTraining> get({
    required String trainingId,
  });

  /// Get a paginated list of all trainings created by the authenticated user or organization.
  ///
  /// Returns a [PaginatedTrainings] object containing the training list and pagination info.
  ///
  /// Example:
  /// ```dart
  /// final trainings = await Replicate.instance.trainings.list();
  /// print('Found ${trainings.results.length} trainings');
  ///
  /// for (final training in trainings.results) {
  ///   print('Training ${training.id}: ${training.status}');
  /// }
  /// ```
  Future<PaginatedTrainings> list();

  /// Cancel a running training.
  ///
  /// [trainingId] is the ID of the training to cancel.
  ///
  /// Returns a [ReplicateTraining] object with the updated status.
  ///
  /// Example:
  /// ```dart
  /// final canceledTraining = await Replicate.instance.trainings.cancel(
  ///   trainingId: 'zz4ibbonubfz7carwiefibzgga',
  /// );
  /// print('Training canceled: ${canceledTraining.status}');
  /// ```
  Future<ReplicateTraining> cancel({
    required String trainingId,
  });
}
