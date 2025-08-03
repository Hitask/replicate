import 'package:replicate/replicate.dart';

void main() async {
  // Setting your API key.
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

  print('🚀 Replicate Training API Example');
  print('================================\n');

  try {
    // Example 1: List existing trainings
    print('📋 Listing existing trainings...');
    final trainings = await Replicate.instance.trainings.list();
    print('Found ${trainings.results.length} trainings');
    
    if (trainings.isNotEmpty) {
      print('\nRecent trainings:');
      for (var i = 0; i < trainings.results.length && i < 3; i++) {
        final training = trainings.results[i];
        print('  - ${training.id}: ${training.status} (${training.model})');
      }
    }

    // Example 2: Create a new training (commented out to avoid accidental usage)
    /*
    print('\n🔧 Creating a new training...');
    final newTraining = await Replicate.instance.trainings.create(
      modelOwner: 'stability-ai',
      modelName: 'sdxl',
      versionId: 'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf',
      destination: 'your-username/your-custom-model', // Replace with your destination
      input: {
        'input_images': 'https://example.com/training-data.zip', // Replace with your training data URL
        'caption': 'A photo of a TOK person',
        'steps': 1000,
        'learning_rate': 1e-6,
      },
      webhook: 'https://your-webhook-url.com/training-webhook', // Optional webhook for status updates
    );
    
    print('✅ Training created successfully!');
    print('Training ID: ${newTraining.id}');
    print('Status: ${newTraining.status}');
    print('Model: ${newTraining.model}');
    print('Web URL: ${newTraining.urls.get}');
    
    // Example 3: Monitor training progress
    print('\n⏳ Monitoring training progress...');
    var currentTraining = newTraining;
    
    while (currentTraining.isRunning) {
      await Future.delayed(Duration(seconds: 30)); // Wait 30 seconds
      
      currentTraining = await Replicate.instance.trainings.get(
        trainingId: currentTraining.id,
      );
      
      print('Status: ${currentTraining.status}');
      if (currentTraining.logs != null && currentTraining.logs!.isNotEmpty) {
        final recentLogs = currentTraining.logs!.split('\n').take(3).join('\n');
        print('Recent logs: $recentLogs');
      }
    }
    
    if (currentTraining.isSucceeded) {
      print('🎉 Training completed successfully!');
      if (currentTraining.output != null) {
        print('Output: ${currentTraining.output}');
      }
      if (currentTraining.metrics != null) {
        print('Training time: ${currentTraining.metrics!.predictTime} seconds');
      }
    } else if (currentTraining.isFailed) {
      print('❌ Training failed!');
      if (currentTraining.error != null) {
        print('Error: ${currentTraining.error}');
      }
    } else if (currentTraining.isCanceled) {
      print('⏹️ Training was canceled');
    }
    */

    // Example 4: Get details of a specific training (if you have a training ID)
    if (trainings.isNotEmpty) {
      final firstTraining = trainings.results.first;
      print('\n🔍 Getting training details...');
      final trainingDetails = await Replicate.instance.trainings.get(
        trainingId: firstTraining.id,
      );
      
      print('Training Details:');
      print('  ID: ${trainingDetails.id}');
      print('  Model: ${trainingDetails.model}');
      print('  Status: ${trainingDetails.status}');
      print('  Created: ${trainingDetails.createdAt}');
      if (trainingDetails.startedAt != null) {
        print('  Started: ${trainingDetails.startedAt}');
      }
      if (trainingDetails.completedAt != null) {
        print('  Completed: ${trainingDetails.completedAt}');
      }
      if (trainingDetails.metrics != null) {
        print('  Training time: ${trainingDetails.metrics!.predictTime} seconds');
      }
      
      // Example 5: Cancel a training (only if it's still running)
      /*
      if (trainingDetails.isRunning) {
        print('\n⏹️ Canceling training...');
        final canceledTraining = await Replicate.instance.trainings.cancel(
          trainingId: trainingDetails.id,
        );
        print('Training canceled. Status: ${canceledTraining.status}');
      }
      */
    }

    print('\n✅ Training API examples completed!');
    
  } catch (e) {
    print('❌ Error: $e');
    print('\nTroubleshooting:');
    print('- Make sure your API key is valid');
    print('- Check that you have sufficient credits');
    print('- Verify that the model supports training');
    print('- Ensure your destination model exists and you have write access');
  }
}

// Helper function to demonstrate training input validation
Map<String, dynamic> validateTrainingInput({
  required String modelOwner,
  required String modelName,
  required String destination,
  required Map<String, dynamic> input,
}) {
  print('🔍 Validating training parameters...');
  
  // Basic validation
  if (modelOwner.isEmpty || modelName.isEmpty) {
    throw ArgumentError('Model owner and name cannot be empty');
  }
  
  if (!destination.contains('/')) {
    throw ArgumentError('Destination must be in format "owner/model-name"');
  }
  
  if (input.isEmpty) {
    throw ArgumentError('Training input cannot be empty');
  }
  
  print('✅ Training parameters are valid');
  return input;
}
