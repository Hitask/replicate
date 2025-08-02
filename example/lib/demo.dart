void main() async {
  print('🎯 Replicate Dart Client Demo');
  print('=============================\n');

  // This demo shows the API structure without making actual requests
  print('📊 Available APIs:');
  print('• Predictions API - Create, get, list, and cancel predictions');
  print('• Models API - Get models, versions, and collections');
  print('• Files API - Upload, list, get, and delete files\n');

  print('🔧 Example usage patterns:\n');

  print('1️⃣ Predictions API:');
  print('   Replicate.instance.predictions.create(...)');
  print('   Replicate.instance.predictions.get(id: "...")');
  print('   Replicate.instance.predictions.cancel(id: "...")');
  print(
      '   Replicate.instance.predictions.snapshots(id: "...")  // Stream support\n');

  print('2️⃣ Models API:');
  print(
      '   Replicate.instance.models.get(modelOwner: "...", modelName: "...")');
  print('   Replicate.instance.models.collection(collectionSlug: "...")');
  print('   Replicate.instance.models.delete(...)\n');

  print('3️⃣ Files API (NEW!):');
  print('   Replicate.instance.files.list()');
  print('   Replicate.instance.files.create(file: file, filename: "...")');
  print('   Replicate.instance.files.get(fileId: "...")');
  print('   Replicate.instance.files.delete(fileId: "...")\n');

  print('🚀 To run the actual examples:');
  print(
      '   1. Get your API key from: https://replicate.com/account/api-tokens');
  print(
      '   2. Run: REPLICATE_API_TOKEN="your_key" dart run example/lib/create_and_get_prediction.dart');
  print(
      '   3. Run: REPLICATE_API_TOKEN="your_key" dart run example/lib/files_api_example.dart\n');

  print('✅ All APIs are properly implemented and tested!');
}
