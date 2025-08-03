import 'package:replicate/src/network/builder/endpoint_url.dart';
import 'package:replicate/src/network/http_client.dart';

import '../../base/models_base.dart';
import '../../models/collection/collection.dart';
import '../../models/model/model.dart';
import '../../models/model/version.dart';

class ReplicateModels implements ReplicateModelsBase {
  /// Creates a new model with the specified parameters.
  ///
  /// [owner] is the name of the user or organization that will own the model.
  /// This must be the same as the user or organization that is making the API request.
  ///
  /// [name] is the name of the model. This must be unique among all models owned by the user or organization.
  ///
  /// [description] is a description of the model.
  ///
  /// [visibility] determines whether the model should be public or private.
  /// A public model can be viewed and run by anyone, whereas a private model
  /// can be viewed and run only by the user or organization members that own the model.
  ///
  /// [hardware] is the SKU for the hardware used to run the model.
  /// Possible values can be retrieved from the hardware.list endpoint.
  ///
  /// [coverImageUrl] is an optional URL for the model's cover image.
  ///
  /// [githubUrl] is an optional URL for the model's source code on GitHub.
  ///
  /// [licenseUrl] is an optional URL for the model's license.
  ///
  /// [paperUrl] is an optional URL for the model's paper.
  ///
  /// ```dart
  /// ReplicateModel model = await Replicate.instance.models.create(
  ///   owner: "alice",
  ///   name: "hot-dog-detector",
  ///   description: "Detect hot dogs in images",
  ///   visibility: "public",
  ///   hardware: "cpu",
  /// );
  /// print(model.name); // hot-dog-detector
  /// ```
  @override
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
  }) async {
    final Map<String, dynamic> requestBody = {
      'owner': owner,
      'name': name,
      'description': description,
      'visibility': visibility,
      'hardware': hardware,
    };

    // Add optional parameters if provided
    if (coverImageUrl != null) {
      requestBody['cover_image_url'] = coverImageUrl;
    }
    if (githubUrl != null) {
      requestBody['github_url'] = githubUrl;
    }
    if (licenseUrl != null) {
      requestBody['license_url'] = licenseUrl;
    }
    if (paperUrl != null) {
      requestBody['paper_url'] = paperUrl;
    }

    return await ReplicateHttpClient.post<ReplicateModel>(
      to: EndpointUrlBuilder.build(["models"]),
      body: requestBody,
      onSuccess: (Map<String, dynamic> response) {
        return ReplicateModel.fromJson(response);
      },
    );
  }

  /// Gets a single model, based on it's owner and name, and returns it as a [ReplicateModel].
  ///
  ///
  /// [modelOwner] is the username of the model owner.
  ///
  ///
  /// [modelNme] is the name of the model.
  ///
  /// ```dart
  /// ReplicateModel model = await Replicate.instance.models.get(
  ///  modelOwner: "replicate",
  /// modelNme: "hello-world",
  /// );
  /// print(model);
  /// ```
  @override
  Future<ReplicateModel> get({
    required String modelOwner,
    required String modelName,
  }) async {
    return await ReplicateHttpClient.get<ReplicateModel>(
        from: EndpointUrlBuilder.build(["models", modelOwner, modelName]),
        onSuccess: (Map<String, dynamic> response) {
          return ReplicateModel.fromJson(response);
        });
  }

  /// Gets a model's versions as a paginated list, based on it's owner and name.
  /// if you want to get a specific version, use [version].
  ///
  ///
  /// [modelOwner] is the username of the model owner.
  ///
  ///
  /// [modelNme] is the name of the model.
  ///
  /// ```dart
  /// final modelVersions = await ReplicateModels().versions(
  /// modelOwner: "replicate",
  /// modelNme: "hello-world",
  /// );
  /// print(modelVersions.results);
  ///
  /// if (modelVersions.hasNextPage) {
  ///  final nextPage = await modelVersions.next();
  ///  print(nextPage.results);
  /// }
  /// ```
  // @override
  // Future<PaginatedModels> versions({
  //   required String modelOwner,
  //   required String modelNme,
  // }) async {
  //   return await listModelsFromApiLink(
  //     EndpointUrlBuilder.build(["models", modelOwner, modelNme, "versions"]),
  //   );
  // }

  /// Loads a Collection of models, based on it's slug.
  /// if you want to get a specific model, use [get].
  /// if you want to get a paginated list of models, use [list].
  /// if you want to get a model's versions, use [versions].
  /// if you want to get a specific version, use [version].
  ///
  /// [collectionSlug] is the slug of the collection.
  ///
  /// ```dart
  /// final collection = await Replicate.instance.models.collection(
  /// collectionSlug: "super-resolution",
  /// );
  ///
  /// print(collection.models); // ...
  /// ```
  @override
  Future<ModelsCollection> collection({
    required String collectionSlug,
  }) async {
    return await ReplicateHttpClient.get(
      from: EndpointUrlBuilder.build(["collections", collectionSlug]),
      onSuccess: (Map<String, dynamic> response) {
        return ModelsCollection.fromJson(response);
      },
    );
  }

  /// Deletes an owned model version, based on it's owner and name.
  /// if you want to get a specific version, use [version].
  /// if you want to get a list of versions, use [versions].
  ///
  ///
  /// [modelOwner] is the username of the model owner.
  ///
  ///
  /// [modelNme] is the name of the model.
  ///
  ///
  /// [versionId] is the id of the version.
  ///
  ///
  /// ```dart
  /// await Replicate.instance.models.delete(
  ///  modelOwner: "/* Owner */",
  ///  modelNme: "/* Model Name */",
  ///  versionId: "/* Version Id */",
  /// );
  /// ```
  @override
  Future<void> delete(
      {required String modelOwner,
      required String modelName,
      required String versionId}) async {
    return await ReplicateHttpClient.delete(
      from: EndpointUrlBuilder.build(
          ["models", modelOwner, modelName, "versions", versionId]),
      onSuccess: () {
        return;
      },
    );
  }

  /// Gets a single model version, based on it's owner, name, and version id, and returns it as a [PaginationModel].
  ///
  /// if you want to get a list of versions, use [versions].
  ///
  ///
  /// [modelOwner] is the username of the model owner.
  ///
  ///
  /// [modelNme] is the name of the model.
  ///
  ///
  /// [versionId] is the id of the version.
  ///
  ///
  /// ```dart
  /// PaginationModel modelVersion = await Replicate.instance.models.version(
  ///  modelOwner: "replicate",
  ///  modelNme: "hello-world",
  ///  versionId: "5c7d5dc6dd8bf75c1acaa8565735e7986bc5b66206b55cca93cb72c9bf15ccaa",
  /// );
  ///
  /// print(modelVersion.id); // ...
  /// ```
  @override
  Future<ReplicateModelVersion> version({
    required String modelOwner,
    required String modelName,
    required String versionId,
  }) async {
    return await ReplicateHttpClient.get<ReplicateModelVersion>(
      from: EndpointUrlBuilder.build(
          ["models", modelOwner, modelName, "versions", versionId]),
      onSuccess: (Map<String, dynamic> response) {
        return ReplicateModelVersion.fromJson(response);
      },
    );
  }
}
