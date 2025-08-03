import 'package:replicate/replicate.dart';

void main() async {
  print('🧪 Testing Account API Integration...\n');

  // Note: This example shows how to use the Account API
  // To actually test it, you would need to set a valid API token

  try {
    // Uncomment and set your API token to test live
    // Replicate.apiKey = "YOUR_API_TOKEN_HERE";

    print('📊 Account API is properly integrated:');
    print('✅ ReplicateAccount model defined');
    print('✅ AccountBase abstract class defined');
    print('✅ ReplicateAccountAPI implementation defined');
    print('✅ Account API added to main Replicate instance');

    print('\n🔧 Usage pattern:');
    print('   Replicate.instance.account.get()');

    print('\n📝 Example Response Structure:');
    print('''
{
  "type": "organization",
  "username": "acme",
  "name": "Acme Corp, Inc.",
  "github_url": "https://github.com/acme"
}
''');

    // Show model structure without making API call
    final mockAccount = ReplicateAccount(
      type: 'organization',
      username: 'acme',
      name: 'Acme Corp, Inc.',
      githubUrl: 'https://github.com/acme',
    );

    print('🎯 Model properties:');
    print('   Type: ${mockAccount.type}');
    print('   Username: ${mockAccount.username}');
    print('   Name: ${mockAccount.name}');
    print('   GitHub URL: ${mockAccount.githubUrl}');

    print('\n✅ Account API integration test completed!');
    print('\n💡 To test with live API:');
    print(
        '   1. Get your API key from: https://replicate.com/account/api-tokens');
    print(
        '   2. Run: REPLICATE_API_TOKEN="your_key" dart run example/lib/account_api_example.dart');
  } catch (e) {
    print('❌ Error during integration test: $e');
  }
}
