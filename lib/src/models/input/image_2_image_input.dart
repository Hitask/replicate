class Image2ImageInputMap {
  Input? input;

  Image2ImageInputMap({this.input});

  Image2ImageInputMap.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? prompt;
  String? sdxlWeights;
  int? guidanceScale;
  String? negativePrompt;

  Input(
      {this.image,
        this.prompt,
        this.sdxlWeights,
        this.guidanceScale,
        this.negativePrompt});

  Input.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    prompt = json['prompt'];
    sdxlWeights = json['sdxl_weights'];
    guidanceScale = json['guidance_scale'];
    negativePrompt = json['negative_prompt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['prompt'] = this.prompt;
    data['sdxl_weights'] = this.sdxlWeights;
    data['guidance_scale'] = this.guidanceScale;
    data['negative_prompt'] = this.negativePrompt;
    return data;
  }
}