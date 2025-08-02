class Text2ImageInputMap {
  Input? input;

  Text2ImageInputMap({this.input});

  Text2ImageInputMap.fromJson(Map<String, dynamic> json) {
    input = json['input'] != null ? new Input.fromJson(json['input']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.input != null) {
      data['input'] = this.input!.toJson();
    }
    return data;
  }
}

class Input {
  int? width;
  int? height;
  String? prompt;
  String? scheduler;
  int? numOutputs;
  int? guidanceScale;
  String? negativePrompt;
  int? numInferenceSteps;

  Input(
      {this.width,
        this.height,
        this.prompt,
        this.scheduler,
        this.numOutputs,
        this.guidanceScale,
        this.negativePrompt,
        this.numInferenceSteps});

  Input.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    prompt = json['prompt'];
    scheduler = json['scheduler'];
    numOutputs = json['num_outputs'];
    guidanceScale = json['guidance_scale'];
    negativePrompt = json['negative_prompt'];
    numInferenceSteps = json['num_inference_steps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['prompt'] = this.prompt;
    data['scheduler'] = this.scheduler;
    data['num_outputs'] = this.numOutputs;
    data['guidance_scale'] = this.guidanceScale;
    data['negative_prompt'] = this.negativePrompt;
    data['num_inference_steps'] = this.numInferenceSteps;
    return data;
  }
}