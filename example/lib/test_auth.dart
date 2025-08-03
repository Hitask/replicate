import 'package:replicate/replicate.dart';

void main() async {
  // Set up your API token
  Replicate.apiKey =
      "YOUR_API_TOKEN_HERE"; // Replace with your actual API token

  try {
    print("Testing existing GET endpoint...");

    // Test an existing GET endpoint to see if the Token format works
    final model = await Replicate.instance.models.get(
      modelOwner: "replicate",
      modelName: "hello-world",
    );

    print("GET request works! Model: ${model.name}");
    print("Owner: ${model.owner}");
  } catch (e) {
    print("Error with GET request: $e");
  }
}
