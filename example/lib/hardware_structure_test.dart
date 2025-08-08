import 'package:replicate/replicate.dart';

void main() async {
  print('🔧 Hardware API Integration Test...\n');

  try {
    // Set a test API key
    Replicate.apiKey = "your-api-key-here";

    // Verify the hardware API is accessible
    final hardware = Replicate.instance.hardware;
    print('✅ Hardware API accessible');
    
    // Actually call the API and print the hardware list
    final hardwareList = await hardware.list();
    print('✅ Hardware list retrieved successfully');
    print('📋 Available Hardware Options (${hardwareList.length} total):\n');
    
    for (final hw in hardwareList) {
      print('• ${hw.name}');
      print('  SKU: ${hw.sku}');
      print('');
    }
    
    print('\n🎉 Hardware API test complete!');
    
  } catch (e) {
    print('❌ Structure verification failed: $e');
  }
}
