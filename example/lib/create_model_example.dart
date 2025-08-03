import 'package:replicate/replicate.dart';

void main() async {
  // Set up your API token (get it from https://replicate.com/account/api-tokens)
  Replicate.apiKey = "YOUR_API_TOKEN_HERE";

  try {
    // Create a new model
    final newModel = await Replicate.instance.models.create(
      owner: "your-username", // Replace with your actual username
      name: "my-awesome-model-test",
      description: "A model that does amazing things",
      visibility: "public", // or "private"
      hardware: "cpu", // or "gpu-t4", "gpu-a40-small", etc.

      // Optional parameters
      githubUrl: "https://github.com/your-username/your-model-repo",
      coverImageUrl: "https://example.com/model-cover.jpg",
      licenseUrl: "https://opensource.org/licenses/MIT",
      paperUrl: "https://arxiv.org/abs/example",
    );

    print("Model created successfully!");
    print("Name: ${newModel.name}");
    print("Owner: ${newModel.owner}");
    print("Description: ${newModel.description}");
    print("Visibility: ${newModel.visibility}");
    print("URL: ${newModel.url}");
    print("Run count: ${newModel.runCount}");

    if (newModel.githubUrl != null) {
      print("GitHub URL: ${newModel.githubUrl}");
    }

    if (newModel.coverImageUrl != null) {
      print("Cover image URL: ${newModel.coverImageUrl}");
    }
  } catch (e) {
    print("Error creating model: $e");
  }
}
