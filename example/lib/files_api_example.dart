import 'dart:io';
import 'package:replicate/replicate.dart';

Future<void> main() async {
  // Set your Replicate API key
  // IMPORTANT: Replace this with your actual API key from https://replicate.com/account/api-tokens
  // For security, consider using environment variables instead of hardcoding the key
  const apiKey = String.fromEnvironment('REPLICATE_API_TOKEN',
      defaultValue: 'YOUR_API_KEY_HERE');

  if (apiKey == 'YOUR_API_KEY_HERE') {
    print('❌ Please set your Replicate API key!');
    print('   You can either:');
    print(
        '   1. Replace YOUR_API_KEY_HERE with your actual API key in this file');
    print('   2. Set the REPLICATE_API_TOKEN environment variable');
    print(
        '   3. Get your API key from https://replicate.com/account/api-tokens');
    return;
  }

  Replicate.apiKey = apiKey;

  try {
    // List all files
    print('Listing files...');
    PaginatedFiles files = await Replicate.instance.files.list();
    print('Found ${files.results.length} files');
    for (ReplicateFile file in files.results) {
      print('- ${file.name} (${file.size} bytes)');
    }

    // Upload a new file
    print('\nUploading a file...');
    File localFile = File('example.txt');
    // Create a sample file for testing
    await localFile.writeAsString('Hello, Replicate Files API!');

    ReplicateFile uploadedFile = await Replicate.instance.files.create(
      file: localFile,
      filename: 'hello-world.txt',
      contentType: 'text/plain',
      metadata: {
        'description': 'A simple text file',
        'source': 'dart-example',
      },
    );
    print('Uploaded file: ${uploadedFile.name} with ID: ${uploadedFile.id}');

    // Get the file details
    print('\nGetting file details...');
    ReplicateFile fileDetails = await Replicate.instance.files.get(
      fileId: uploadedFile.id,
    );
    print('File details: ${fileDetails.name}, ${fileDetails.contentType}');

    // Delete the file
    print('\nDeleting file...');
    await Replicate.instance.files.delete(fileId: uploadedFile.id);
    print('File deleted successfully');

    // Clean up local file
    await localFile.delete();
  } catch (e) {
    print('Error: $e');
  }
}
