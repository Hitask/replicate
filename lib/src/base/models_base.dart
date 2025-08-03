import '../models/collection/collection.dart';
import '../models/model/model.dart';

abstract class ReplicateModelsBase
    implements
        GetModel,
        CreateModel,
        GetModelsVersions,
        GetModelVersion,
        DeleteModelVersion,
        GetCollectionsModels {}

abstract class CreateModel {
  Future<ReplicateModel> create({
    required String owner,
    required String name,
    required String description,
    required String visibility,
    required String hardware,
    String? coverImageUrl,
    String? githubUrl,
    String? licenseUrl,
    String? paperUrl,
  });
}

abstract class GetCollectionsModels {
  Future<ModelsCollection> collection({
    required String collectionSlug,
  });
}

abstract class DeleteModelVersion {
  Future<void> delete({
    required String modelOwner,
    required String modelName,
    required String versionId,
  });
}

abstract class GetModelVersion {
  Future version({
    required String modelOwner,
    required String modelName,
    required String versionId,
  });
}

abstract class GetModelsVersions {
  // Future<PaginatedModels> versions({
  //   required String modelOwner,
  //   required String modelNme,
  // });
}

abstract class GetModel {
  Future<ReplicateModel> get({
    required String modelOwner,
    required String modelName,
  });
}
