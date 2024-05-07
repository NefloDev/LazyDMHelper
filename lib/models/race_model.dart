class RaceModel{
  final String? id;
  final String userid;
  final String name;
  final String asi;
  final String age;
  final String size;
  final int speed;
  final String alignment;
  final String languages;
  final String traits;
  final String startingProficiencies;
  final String startingProficiencyOptions;
  final String subRaces;

  RaceModel({
      this.id,
      required this.userid,
      required this.name,
      this.asi = "",
      this.age = "",
      this.size = "",
      this.speed = 0,
      this.alignment = "",
      this.languages = "",
      this.traits = "",
      this.startingProficiencies = "",
      this.startingProficiencyOptions = "",
      this.subRaces = ""
      });

  factory RaceModel.fromJson(dynamic json) => RaceModel(
      id: json["id"],
      userid: json["userid"],
      name: json["name"],
      asi: json["asi"] ?? "",
      age: json["age"] ?? "",
      size: json["size"] ?? "",
      speed: json["speed"] as int,
      alignment: json["alignment"] ?? "",
      languages: json["languages"] ?? "",
      traits: json["traits"] ?? "",
      startingProficiencies: json["startingProficiencies"] ?? "",
      startingProficiencyOptions: json["startingProficiencyOptions"] ?? "",
      subRaces: json["subraces"] ?? ""
  );

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "userid": userid,
      "name": name,
      "asi": asi,
      "age": age,
      "size": size,
      "speed": speed,
      "alignment": alignment,
      "languages": languages,
      "traits": traits,
      "startingProficiencies": startingProficiencies,
      "startingProficiencyOptions": startingProficiencyOptions,
      "subraces": subRaces
    };
  }
}