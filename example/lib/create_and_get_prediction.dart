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

  // Setting showLogs to true will print all the requests and responses to the console.
  Replicate.showLogs = true;

  // Creating a prediction.
  Prediction firstPrediction = await Replicate.instance.predictions.create(
    version: "50adaf2d3ad20a6f911a8a9e3ccf777b263b8596fbd2c8fc26e8888f8a0edbb5",
    input: {
      "image": "https://i.stack.imgur.com/KEtWo.png",
    },
  );

  print(firstPrediction.createdAt);

  // Waiting for 2 seconds.
  await Future.delayed(Duration(seconds: 2), () {
    print("Waited 2 seconds.");
  });

  // if the prediction id created successfully, you should be able to check it in your replicate dashboard.
  //
  // you can get the prediction with it's id.
  Prediction firstPredictionWithId = await Replicate.instance.predictions.get(
    id: firstPrediction.id,
  );

  // printing the status of the prediction, at this point.
  print(firstPredictionWithId);
}
