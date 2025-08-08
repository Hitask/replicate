import 'package:replicate/replicate.dart';

void main() async {
  // Set up your API token (get it from https://replicate.com/account/api-tokens)
  Replicate.apiKey = "r8_LQ0BmhTLd1bfDYiEZCW1s29_xxxxxxxxxxxxxxxx"; // Use your real API token here

  print('🔧 Testing Hardware API...\n');

  try {
    // Get list of available hardware
    final hardwareList = await Replicate.instance.hardware.list();

    print('📋 Available Hardware Options:');
    print('Total hardware options: ${hardwareList.length}\n');

    for (final hardware in hardwareList) {
      print('• ${hardware.name}');
      print('  SKU: ${hardware.sku}');
      print('');
    }

    // Example: Find specific hardware by SKU
    final gpuT4 = hardwareList.where((h) => h.sku == 'gpu-t4').firstOrNull;
    if (gpuT4 != null) {
      print('🎯 Found GPU T4 hardware:');
      print('   Name: ${gpuT4.name}');
      print('   SKU: ${gpuT4.sku}');
    }

    // Example: List all GPU options
    final gpuOptions = hardwareList.where((h) => h.sku.startsWith('gpu-')).toList();
    print('\n🚀 GPU Options Available:');
    for (final gpu in gpuOptions) {
      print('   ${gpu.name} (${gpu.sku})');
    }

  } on ReplicateException catch (e) {
    print('❌ API Error:');
    print('   Status Code: ${e.statsCode}');
    print('   Message: ${e.message}');
  } catch (e) {
    print('❌ Unexpected error: $e');
  }

  print('\n✅ Hardware API example completed!');
}
