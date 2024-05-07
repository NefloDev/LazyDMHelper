class MagicItemModel{
  final String? id;
  final String userid;
  final String name;
  final String description;
  final String rarity;
  final String type;

  MagicItemModel({
      this.id,
      required this.userid,
      required this.name,
      this.description = "",
      this.rarity = "",
      this.type = ""
      });

  factory MagicItemModel.fromJson(dynamic json) => MagicItemModel(
      id: json["id"].toString(),
      userid: json["userid"].toString(),
      name: json["name"].toString(),
      description: json["description"] ?? "",
      rarity: json["rarity"] ?? "",
      type: json["type"] ?? ""
  );

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "userid": userid,
      "name": name,
      "description": description,
      "rarity": rarity,
      "type": type
    };
  }

  Map<String, dynamic> toReducedJson(){
    return {
      "name": name,
      "description": description,
      "rarity": rarity,
      "type": type
    };
  }
}