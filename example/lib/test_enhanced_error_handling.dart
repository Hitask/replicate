import 'package:replicate/replicate.dart';

void main() async {
  print('🧪 Testing Enhanced HTTP Client Error Handling...\n');

  // Set up API key for testing
  Replicate.apiKey = "YOUR_API_TOKEN_HERE";

  // Test 1: Successful request (should work)
  await testSuccessfulRequest();

  // Test 2: Model not found (404 status code)
  await testNotFoundError();

  print('\n✅ Enhanced HTTP error handling tests completed!');
}

Future<void> testSuccessfulRequest() async {
  print('📋 Test 1: Successful API request...');

  try {
    final account = await Replicate.instance.account.get();
    print('   ✅ Success: Account retrieved for ${account.username}');
  } catch (e) {
    print('   ❌ Unexpected error: $e');
  }
}

Future<void> testNotFoundError() async {
  print('\n📋 Test 2: Testing 404 error with status code checking...');

  try {
    // Try to get a model that doesn't exist
    final model = await Replicate.instance.models.get(
      modelOwner: "nonexistent-user-12345",
      modelName: "nonexistent-model-67890",
    );

    print('   ❌ Unexpected success: ${model.name}');
  } on ReplicateException catch (e) {
    print('   ✅ Caught ReplicateException:');
    print('      Status Code: ${e.statsCode}');
    print('      Message: ${e.message}');

    // Verify that status code checking is working
    if (e.statsCode == 404) {
      print('      ✅ Status code 404 correctly detected');
    } else {
      print('      ⚠️  Unexpected status code: ${e.statsCode}');
    }
  } catch (e) {
    print('   ❌ Unexpected error type: $e');
  }
}

/*
Enhanced HTTP Client Error Checking Summary:
============================================

🔧 Improvements Made:
• Added HTTP status code validation (2xx = success)
• Enhanced error message fallback logic
• Consistent error handling across all HTTP methods
• Better error messages when no specific error field is present

🎯 Error Detection Logic:
1. Check if status code is in 2xx range (200-299)
2. Check if error/detail fields are absent
3. Both conditions must be true for success
4. Otherwise, throw ReplicateException with appropriate message

📊 Error Message Priority:
1. decodedBody["error"] - Primary error field
2. decodedBody["detail"] - Secondary error field  
3. "HTTP {statusCode} error" - Fallback based on status code

✅ Benefits:
• Catches HTTP errors even without error fields in response
• More robust error detection
• Consistent behavior across all HTTP methods
• Better error messages for debugging
*/
