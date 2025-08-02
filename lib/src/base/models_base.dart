import '../models/collection/collection.dart';
import '../models/model/model.dart';

abstract class ReplicateModelsBase
    implements
        GetModel,
        GetModelsVersions,
        GetModelVersion,
        DeleteModelVersion,
        GetCollectionsModels {}

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
