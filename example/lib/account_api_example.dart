import 'package:replicate/replicate.dart';

void main() async {
  // Set up your API token (get it from https://replicate.com/account/api-tokens)
  Replicate.apiKey = "YOUR_API_TOKEN_HERE";

  try {
    print('🔍 Fetching account information...\n');

    // Get account information
    final account = await Replicate.instance.account.get();

    print('✅ Account Information Retrieved:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Account Type: ${account.type}');
    print('Username: ${account.username}');
    print('Display Name: ${account.name}');

    if (account.githubUrl != null) {
      print('GitHub URL: ${account.githubUrl}');
    } else {
      print('GitHub URL: Not set');
    }

    print('\n📊 Account Summary:');
    if (account.type == 'organization') {
      print('• This is an organization account');
      print('• Organization name: ${account.name}');
    } else {
      print('• This is a user account');
      print('• User display name: ${account.name}');
    }

    print('\n✅ Account API example completed successfully!');
  } catch (e) {
    print('❌ Error fetching account information: $e');
    print('\nTroubleshooting:');
    print('- Make sure your API key is valid');
    print('- Check your internet connection');
    print('- Verify the API key has the correct permissions');
    print('- Get your API key from: https://replicate.com/account/api-tokens');
  }
}

/// Helper function to format account type for display
String formatAccountType(String type) {
  switch (type.toLowerCase()) {
    case 'organization':
      return '🏢 Organization';
    case 'user':
      return '👤 User';
    default:
      return '❓ $type';
  }
}
