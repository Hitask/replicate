import '../../base/trainings_base.dart';
import '../../models/trainings/training.dart';
import '../../models/trainings/paginated_trainings.dart';
import '../../network/builder/endpoint_url.dart';
import '../../network/http_client.dart';

/// Implementation of training-related operations for the Replicate API.
///
/// This class handles all training operations including creating, monitoring,
/// listing, and canceling training jobs.
class ReplicateTrainings extends TrainingsBase {
  @override
  Future<ReplicateTraining> create({
    required String modelOwner,
    required String modelName,
    required String versionId,
    required String destination,
    required Map<String, dynamic> input,
    String? webhook,
    List<String>? webhookEventsFilter,
  }) async {
    final url = EndpointUrlBuilder.build(
        ['models', modelOwner, modelName, 'versions', versionId, 'trainings']);

    final body = <String, dynamic>{
      'destination': destination,
      'input': input,
    };

    if (webhook != null) {
      body['webhook'] = webhook;
    }

    if (webhookEventsFilter != null && webhookEventsFilter.isNotEmpty) {
      body['webhook_events_filter'] = webhookEventsFilter;
    }

    return await ReplicateHttpClient.post<ReplicateTraining>(
      onSuccess: (response) => ReplicateTraining.fromJson(response),
      to: url,
      body: body,
    );
  }

  @override
  Future<ReplicateTraining> get({
    required String trainingId,
  }) async {
    final url = EndpointUrlBuilder.build(['trainings', trainingId]);

    return await ReplicateHttpClient.get<ReplicateTraining>(
      onSuccess: (response) => ReplicateTraining.fromJson(response),
      from: url,
    );
  }

  @override
  Future<PaginatedTrainings> list() async {
    final url = EndpointUrlBuilder.build(['trainings']);

    return await ReplicateHttpClient.get<PaginatedTrainings>(
      onSuccess: (response) => PaginatedTrainings.fromJson(response),
      from: url,
    );
  }

  @override
  Future<ReplicateTraining> cancel({
    required String trainingId,
  }) async {
    final url = EndpointUrlBuilder.build(['trainings', trainingId, 'cancel']);

    return await ReplicateHttpClient.post<ReplicateTraining>(
      onSuccess: (response) => ReplicateTraining.fromJson(response),
      to: url,
    );
  }
}
