import 'package:dogbreadapp/model/breedModel.dart';

class BreedDetailModel {
  List<BreedModel> breeds;
  int height;
  String id;
  String url;
  int width;

  BreedDetailModel({this.breeds, this.height, this.id, this.url, this.width});

  BreedDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['breeds'] != null) {
      breeds = new List<BreedModel>();
      json['breeds'].forEach((v) {
        breeds.add(new BreedModel.fromJson(v));
      });
    }
    height = json['height'];
    id = json['id'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.breeds != null) {
      data['breeds'] = this.breeds.map((v) => v.toJson()).toList();
    }
    data['height'] = this.height;
    data['id'] = this.id;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}

class Breeds {
  String bredFor;
  String breedGroup;
  Height height;
  dynamic id;
  String lifeSpan;
  String name;
  String origin;
  String referenceImageId;
  String temperament;
  Height weight;

  Breeds(
      {this.bredFor,
      this.breedGroup,
      this.height,
      this.id,
      this.lifeSpan,
      this.name,
      this.origin,
      this.referenceImageId,
      this.temperament,
      this.weight});

  Breeds.fromJson(Map<String, dynamic> json) {
    bredFor = json['bred_for'];
    breedGroup = json['breed_group'];
    height =
        json['height'] != null ? new Height.fromJson(json['height']) : null;
    id = json['id'];
    lifeSpan = json['life_span'];
    name = json['name'];
    origin = json['origin'];
    referenceImageId = json['reference_image_id'];
    temperament = json['temperament'];
    weight =
        json['weight'] != null ? new Height.fromJson(json['weight']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bred_for'] = this.bredFor;
    data['breed_group'] = this.breedGroup;
    if (this.height != null) {
      data['height'] = this.height.toJson();
    }
    data['id'] = this.id;
    data['life_span'] = this.lifeSpan;
    data['name'] = this.name;
    data['origin'] = this.origin;
    data['reference_image_id'] = this.referenceImageId;
    data['temperament'] = this.temperament;
    if (this.weight != null) {
      data['weight'] = this.weight.toJson();
    }
    return data;
  }
}

class Height {
  String imperial;
  String metric;

  Height({this.imperial, this.metric});

  Height.fromJson(Map<String, dynamic> json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imperial'] = this.imperial;
    data['metric'] = this.metric;
    return data;
  }
}
