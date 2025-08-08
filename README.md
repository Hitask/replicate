# Replicate Dart Client

A community-maintained Dart client package for Replicate.com, this package let you interact with Replicate.com APIs and create predictions from the available machine learning models.

## Key Features.

- Easy to call methods for creating, Getting, Cancelling one prediction, and getting a pagination lists of predictions used.
- `Stream` availability for listening to a predictions changes in realtime.
- Dynamic inputs for the possibility to use any model available on Replicate.com flexibly.
- Wrappers around response fields, for a better developer experience.
- Easy to configure, and set your settings using this library.
- **Files API** support for uploading, listing, getting, and deleting files on Replicate.
- **Training API** support for creating, monitoring, and managing model training jobs.
- **Account API** support for retrieving authenticated user or organization information.
- **Hardware API** support for listing available computational resources (CPU, GPU types).
- Comprehensive error handling with specific exception types.

# Full Documentation

You can check the Full Documentation of this library [from here](https://pub.dev/documentation/replicate/latest/).

# Usage

### Authentication

Before making any requests, you should set your API key so it will be used to make requests to your account on `Replicate.com`.

```dart
  Replicate.apiKey = "<YOUR_API_KEY>";
```

###### **Recommendation**:

it's better to load your api key from a `.env` file, you can do this in Dart using [dotenv](https://pub.dev/packages/dotenv) package.

<br>

## Create Prediction

You can call this to start creating a new prediction for the version and input you will provide, since the models can take some time to run, This `output` will not be available immediately, it will return a `Prediction` with the returned response from Replicate.com, with a `status` set to the prediction status at this point:

```dart
Prediction prediction = await Replicate.instance.predictions.create(
    version: "<MODEL_VERSION>",
    input: {
      "field_name": "<field_value>",
    },
  );
```

Note that `input` takes a `Map<String, dynamic>` as a value since every model has its input accepted fields.

if you want to create a new prediction for a model that accepts a file field(s), you need just to set that field(s) value to either a network url , or the base64 of that file.

<br>

## Get Prediction

if you need to get a Prediction at a specific point in time, you can call the `Replicate.instance.predictions.get()` method, it will return a new `Prediction` object with the requested prediction data:

```dart
Prediction prediction = await Replicate.instance.predictions.get(
    id: "<PREDICTION_ID>",
);

print(prediction); // ...
```

A `Prediction` object is a container for prediction progress data (status, logs, output, metrics... ) requested from your `Replicate.com` dashboard.

When a `Prediction` is Terminated, the `metrics` property will have a `predictTime` property with the amount of CPU or GPU time, in seconds, that this prediction used while running. This is the time you're billed for, and it doesn't include time waiting for the prediction to start.

A `Prediction` is considered terminated when the `status` property is one of :

- `PredictionStatus.succeeded`
- `PredictionStatus.canceled`
- `PredictionStatus.failed`

You might want to give a quick look over [Get Prediction](https://replicate.com/docs/reference/http#get-prediction).

<br>

## Cancel Prediction

You can cancel a running prediction by calling `Replicate.instance.predictions.cancel()` :

```dart
final canceledPrediction = await Replicate.instance.predictions.cancel(
  id: "<PREDICTION_ID>",
);
```

<br>

## Get list of predictions

You can get a paginated list of predictions that you've created with your account by calling :

```dart
PaginatedPredictions predictionsPageList = await Replicate.instance.predictions.list();

print(predictionsPageList.results); // ...
```

This includes predictions created from the API and the Replicate website. Returns 100 records per page.

You can check before requesting the next/previous pagination lists:

```dart
if (predictionsPageList.hasNextPage) {
  PaginatedPredictions next = await predictionsPageList.next();
  print(next.results); // ...
}
if (predictionsPageList.hasPreviousPage) {
  PaginatedPredictions prev = await predictionsPageList.previous();
  print(prev.results); // ...
}
```

<br>

## Listening to prediction changes.

After Creating a new prediction with [Create Prediction](#create-prediction), while it is running, you can get a `Stream` of its changes in real-time by calling:

```dart
Stream<Prediction> predictionStream = Replicate.instance.predictions.snapshots(
    id: "<PREDICTION_ID>",
);

predictionStream.listen((Prediction prediction) {
   print(prediction.status); // ...
});

```

By default, every time the status of the prediction changes, a new `Prediction` will be emitted to the `predictionStream`, but you can change and configure this behavior to meet your specific needs by specifying a `pollingInterval`, `shouldTriggerOnlyStatusChanges`, `stopPollingRequestsOnPredictionTermination`..

This functionality is based on polling request as it's recommended by [replicate from here](https://replicate.com/docs/reference/http#create-prediction).

<br>

## I don't want to listen to changes by `Stream`.

Well, Replicate.com offers also notifying with webhook feature.

while [creating a prediction](#create-prediction), you can set the `webhookCompleted` property to your HTTPS URL which will receive the response when the prediction is completed:

```dart
Prediction prediction = await Replicate.instance.predictions.create(
    version: "<MODEL_VERSION>",
    input: {
      "field_name": "<field_value>",
    },
    webhookCompleted: "<YOUR_HTTPS_URL>", // add this
  );
```

learn more about the webhook feature [from here](https://replicate.com/docs/reference/http#create-prediction--webhook_comple)

<br>

## Get Model

Gets a single model, based on it's owner and name, and returns it as a [ReplicateModel].

```dart
ReplicateModel model = await Replicate.instance.models.get(
  modelOwner: "replicate",
  modelNme: "hello-world",
);

print(model);  // ...
print(model.url);  // ...
print(model.owner); // replicate
```

<br>

## Create Model

Creates a new model with the specified parameters. You can create both public and private models.

```dart
ReplicateModel newModel = await Replicate.instance.models.create(
  owner: "your-username", // Must be your username or organization
  name: "my-awesome-model",
  description: "A model that does amazing things",
  visibility: "private", // "public" or "private"
  hardware: "cpu", // Hardware SKU: "cpu", "gpu-t4", "gpu-a40-small", etc.
  
  // Optional parameters
  githubUrl: "https://github.com/your-username/your-model-repo",
  coverImageUrl: "https://example.com/model-cover.jpg",
  licenseUrl: "https://opensource.org/licenses/MIT",
  paperUrl: "https://arxiv.org/abs/example",
);

print("Model created: ${newModel.name}");
print("URL: ${newModel.url}");
```

**Note**: There is a limit of 1,000 models per account. For most purposes, we recommend using a single model and pushing new versions of the model as you make changes to it.

<br>

## Get a list of model versions

Gets a model's versions as a paginated list, based on it's owner and name.

if you want to get a specific version, check [Get A Model Version](#get-a-model-version).

You can load the next and previous pagination list of a current on, by using `next()` and `previous()` method.

if no next or previous pages exists for a pagination list, a `NoNextPageException` or `NoPreviousPageException` will be thrown.

For avoiding those exceptions at all, you can check for the next and previos pages existence using the `hasNextPage` and `hasPreviousPage` :

```dart
PaginatedModels modelVersions = await Replicate.instance.model.versions(
 modelOwner: "replicate",
 modelNme: "hello-world",
);

print(modelVersions.results); // ...

// loads the next page if it exists
if (modelVersions.hasNextPage) {
 PaginatedModels nextPage = await modelVersions.next();

 print(nextPage.results); // ...
}
```

<br>

## Get A Model Version

Gets a single model version, based on it's owner, name, and version id.

if you want to get a list of versions, check [Get a list of model versions](#get-a-list-of-model-versions).

```dart
PaginationModel modelVersion = await Replicate.instance.models.version(
 modelOwner: "replicate",
 modelNme: "hello-world",
 versionId: "5c7d5dc6dd8bf75c1acaa8565735e7986bc5b66206b55cca93cb72c9bf15ccaa",
);

print(modelVersion.id); // ...
```

<br>

## Delete A Model.

Delete a model version and all associated predictions, including all output files.

```dart
await Replicate.instance.models.delete(
 modelOwner: "/* Owner */",
 modelNme: "/* Model Name */",
 versionId: "/* Version Id */",
);
```

if the file os deleted succefully, nothing will happen actually, so you should expect that the model is deleted if none happens in your code, However, when something goes wrong ( if you try to delete a model which you don't own, a `ReplicateException` will be thrown with the error message ).

<br>

## Get a collection of models.

Loads a collection of models.

```dart
ModelsCollection collection = await Replicate.instance.models.collection(
collectionSlug: "super-resolution",
);

  print(collection.name); // super resolution
  print(collection.models); // ...
```

<br>

# Files API

The Files API allows you to upload, list, get, and delete files on Replicate. This is useful for storing files that you want to use as inputs to models, especially for large files or files that you want to reuse across multiple predictions.

## List Files

Get a paginated list of all files created by the user or organization:

```dart
PaginatedFiles files = await Replicate.instance.files.list();
print('Found ${files.results.length} files');

for (ReplicateFile file in files.results) {
  print('- ${file.name} (${file.size} bytes, ${file.contentType})');
}

// Check for pagination
if (files.hasNextPage) {
  // Note: Pagination for files list is handled through direct API calls
  print('More files available');
}
```

## Create/Upload File

Create a file by uploading its content and optional metadata. You can upload any type of file, but there are some considerations for file size and usage:

```dart
import 'dart:io';

File localFile = File('/path/to/your/file.jpg');

ReplicateFile uploadedFile = await Replicate.instance.files.create(
  file: localFile,
  filename: 'my-image.jpg',
  contentType: 'image/jpeg', // Optional, defaults to 'application/octet-stream'
  metadata: { // Optional metadata
    'description': 'A beautiful landscape photo',
    'source': 'my-app',
    'category': 'nature',
  },
);

print('Uploaded file: ${uploadedFile.name}');
print('File ID: ${uploadedFile.id}');
print('File URL: ${uploadedFile.url}');
```

### File Upload Guidelines

- **Filename**: Required, must be ≤ 255 bytes and valid UTF-8
- **Content Type**: Optional, defaults to `application/octet-stream`
- **Metadata**: Optional JSON object for storing custom information
- **File Size**: Check Replicate's current limits for maximum file size

## Get File Details

Get the details of a specific file by its ID:

```dart
ReplicateFile file = await Replicate.instance.files.get(
  fileId: 'your-file-id-here',
);

print('File name: ${file.name}');
print('File size: ${file.size} bytes');
print('Content type: ${file.contentType}');
print('Created at: ${file.createdAt}');
print('Metadata: ${file.metadata}');
```

## Delete File

Delete a file by its ID. Once deleted, the file cannot be recovered:

```dart
await Replicate.instance.files.delete(
  fileId: 'your-file-id-here',
);

print('File deleted successfully');
```

**Note**: Once a file has been deleted, subsequent requests to the file resource will return 404 Not Found.

## Using Files with Predictions

After uploading a file, you can use its URL in model predictions:

```dart
// Upload a file first
File inputImage = File('/path/to/input.jpg');
ReplicateFile uploadedFile = await Replicate.instance.files.create(
  file: inputImage,
  filename: 'input.jpg',
  contentType: 'image/jpeg',
);

// Use the file URL in a prediction
Prediction prediction = await Replicate.instance.predictions.create(
  version: "your-model-version-id",
  input: {
    "image": uploadedFile.url, // Use the uploaded file's URL
    "prompt": "Transform this image",
  },
);
```

## File URLs and Access

- Files uploaded via the API are served by `replicate.delivery` and its subdomains
- File URLs require authorization headers for access
- If you use an allow list of external domains, add `replicate.delivery` and `*.replicate.delivery` to it

<br>

# Training API

The Training API allows you to create, monitor, and manage training jobs on Replicate. Training lets you fine-tune models with your own data to create custom versions tailored to your specific use cases.

## List Trainings

Get a paginated list of all trainings created by the user or organization:

```dart
PaginatedTrainings trainings = await Replicate.instance.trainings.list();
print('Found ${trainings.results.length} trainings');

for (ReplicateTraining training in trainings.results) {
  print('- ${training.id}: ${training.status} (${training.model})');
}

// Check for pagination
if (trainings.hasNextPage) {
  print('More trainings available');
}
```

## Create a Training

Create a new training job by specifying the model, version, destination, and training parameters:

```dart
ReplicateTraining training = await Replicate.instance.trainings.create(
  modelOwner: 'stability-ai',
  modelName: 'sdxl',
  versionId: 'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf',
  destination: 'your-username/your-custom-model', // Must be an existing model you own
  input: {
    'input_images': 'https://example.com/training-data.zip',
    'caption': 'A photo of a TOK person',
    'steps': 1000,
    'learning_rate': 1e-6,
  },
  webhook: 'https://your-webhook-url.com/training-webhook', // Optional
  webhookEventsFilter: ['start', 'completed'], // Optional
);

print('Training created: ${training.id}');
print('Status: ${training.status}');
print('Web URL: ${training.urls.get}');
```

### Training Parameters

- **modelOwner**: Username of the model owner
- **modelName**: Name of the model to train
- **versionId**: ID of the specific model version to train
- **destination**: Target model identifier in format "owner/model-name" (must exist and you must have write access)
- **input**: Training parameters specific to the model (varies by model)
- **webhook**: Optional HTTPS URL for status updates
- **webhookEventsFilter**: Optional list of events that trigger webhooks (`start`, `output`, `logs`, `completed`)

## Monitor Training Progress

Get the current state of a training and monitor its progress:

```dart
ReplicateTraining training = await Replicate.instance.trainings.get(
  trainingId: 'your-training-id',
);

print('Training Status: ${training.status}');
print('Created: ${training.createdAt}');

// Check training state
if (training.isRunning) {
  print('Training is in progress...');
  if (training.logs != null) {
    print('Recent logs: ${training.logs}');
  }
} else if (training.isSucceeded) {
  print('Training completed successfully!');
  if (training.output != null) {
    print('Output: ${training.output}');
  }
  if (training.metrics != null) {
    print('Training time: ${training.metrics!.predictTime} seconds');
  }
} else if (training.isFailed) {
  print('Training failed: ${training.error}');
} else if (training.isCanceled) {
  print('Training was canceled');
}
```

### Training Status

Training status can be one of:
- **starting**: The training is starting up
- **processing**: The train() method is currently running
- **succeeded**: The training completed successfully
- **failed**: The training encountered an error
- **canceled**: The training was canceled

## Cancel a Training

Cancel a running training:

```dart
ReplicateTraining canceledTraining = await Replicate.instance.trainings.cancel(
  trainingId: 'your-training-id',
);

print('Training canceled. Status: ${canceledTraining.status}');
```

**Note**: Only running trainings (status `starting` or `processing`) can be canceled.

## Training Best Practices

### 1. Prepare Your Training Data
```dart
// Upload training data using the Files API first
File trainingData = File('/path/to/training-data.zip');
ReplicateFile uploadedData = await Replicate.instance.files.create(
  file: trainingData,
  filename: 'training-data.zip',
  contentType: 'application/zip',
);

// Use the uploaded file URL in training
final training = await Replicate.instance.trainings.create(
  // ... other parameters
  input: {
    'input_images': uploadedData.url,
    // ... other training parameters
  },
);
```

### 2. Monitor Training with Polling
```dart
Future<void> monitorTraining(String trainingId) async {
  ReplicateTraining training;
  
  do {
    await Future.delayed(Duration(seconds: 30)); // Wait 30 seconds
    training = await Replicate.instance.trainings.get(trainingId: trainingId);
    
    print('Status: ${training.status}');
    
  } while (training.isRunning);
  
  if (training.isSucceeded) {
    print('Training completed! New model version created.');
  }
}
```

### 3. Use Webhooks for Real-time Updates
```dart
final training = await Replicate.instance.trainings.create(
  // ... other parameters
  webhook: 'https://your-app.com/webhooks/training',
  webhookEventsFilter: ['start', 'output', 'completed'],
);
```

### 4. Error Handling
```dart
try {
  final training = await Replicate.instance.trainings.create(
    // ... parameters
  );
} catch (e) {
  if (e is ReplicateException) {
    print('Training API error: ${e.message}');
    print('Status code: ${e.statsCode}');
  } else {
    print('Unexpected error: $e');
  }
}
```

<br>

# Account API

The Account API allows you to retrieve information about the authenticated user or organization associated with your API token. This is useful for verifying your authentication and getting account details.

## Get Account Information

Retrieve information about the authenticated account:

```dart
try {
  // Get account information
  ReplicateAccount account = await Replicate.instance.account.get();
  
  print('Account Type: ${account.type}'); // "user" or "organization"
  print('Username: ${account.username}');
  print('Display Name: ${account.name}');
  
  if (account.githubUrl != null) {
    print('GitHub URL: ${account.githubUrl}');
  }
  
} catch (e) {
  if (e is ReplicateException) {
    print('Account API error: ${e.message}');
    print('Status code: ${e.statsCode}');
  } else {
    print('Unexpected error: $e');
  }
}
```

The account object contains:
- **type**: The account type ("user" or "organization")
- **username**: The account username
- **name**: The display name of the user or organization
- **githubUrl**: Optional GitHub profile URL

This is particularly useful for:
- Verifying API token validity
- Displaying current user information in your application
- Determining if the account is a user or organization account
- Getting the correct owner name for creating models or other resources

<br>

# Hardware API

The Hardware API allows you to retrieve information about available hardware options for running models and deployments on Replicate. This is useful when creating models or deployments to specify which computational resources to use.

## List Available Hardware

Get a list of all available hardware options:

```dart
try {
  // Get list of available hardware
  List<ReplicateHardware> hardwareList = await Replicate.instance.hardware.list();
  
  print('Available Hardware Options:');
  for (final hardware in hardwareList) {
    print('${hardware.name}: ${hardware.sku}');
  }
  
  // Find specific hardware by SKU
  final gpuT4 = hardwareList.where((h) => h.sku == 'gpu-t4').firstOrNull;
  if (gpuT4 != null) {
    print('Found T4 GPU: ${gpuT4.name}');
  }
  
  // List all GPU options
  final gpuOptions = hardwareList.where((h) => h.sku.startsWith('gpu-')).toList();
  print('GPU Options: ${gpuOptions.length} available');
  
} catch (e) {
  if (e is ReplicateException) {
    print('Hardware API error: ${e.message}');
    print('Status code: ${e.statsCode}');
  } else {
    print('Unexpected error: $e');
  }
}
```

### Hardware Object

Each hardware object contains:
- **name**: Human-readable name (e.g., "Nvidia T4 GPU", "CPU")
- **sku**: SKU identifier used in API calls (e.g., "gpu-t4", "cpu")

### Usage with Models and Deployments

Use the hardware SKU when creating models or deployments:

```dart
// Example: Creating a model with specific hardware
await Replicate.instance.models.create(
  owner: "your-username",
  name: "my-model",
  description: "A model using T4 GPU",
  visibility: "private",
  hardware: "gpu-t4", // Use the SKU from hardware.list()
);
```

Typical hardware options include:
- **CPU**: `cpu` - Standard CPU processing
- **Nvidia T4 GPU**: `gpu-t4` - Cost-effective GPU for most models
- **Nvidia A40 GPU**: `gpu-a40-small` - High-performance GPU for larger models  
- **Nvidia A40 (Large) GPU**: `gpu-a40-large` - Maximum performance GPU

<br>

# Error Handling

<br>

### ReplicateException

This exception will be thrown when there is an error from the replicate.com end, as example when you hit the rate limit you will get a `ReplicateException` with the message and the status code of the erorr:

```dart
try {
// ...

} on ReplicateException carch(e) {
print(e.message);
print(e.statusCode);
}
```

<br>

### NoNextPageException, NoPreviousPageException

These are special and limited exception when working with [Get A List Of Model Versions](#get-a-list-of-model-versions), when you try to get the `next()` or `previous()` of a pagintaed list that don't exist, one of those exceptions will be thrown, but the way to avoid them totally are included in the documentation.

```dart
try {
PaginatedModels firstPage = // ...
page.previous(); // obviously, there is no previous for first page, right?

} on NoPreviousPageException catch(e) {
print(// no next for this paginated list.);
}
```
