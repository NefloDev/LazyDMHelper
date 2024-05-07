class EquipmentModel{
  final String? id;
  final String userid;
  final String name;
  final String description;
  final String category;
  final String type;
  final String cost;
  final double weight;
  final String range;
  final String damage;
  final int speed;
  final String contents;
  final String properties;
  final String special;

  EquipmentModel({
      this.id,
      required this.userid,
      required this.name,
      this.description = "",
      this.category = "",
      this.type = "",
      this.cost = "",
      this.weight = 0,
      this.range = "",
      this.damage = "",
      this.speed = 0,
      this.contents = "",
      this.properties = "",
      this.special = ""
  });

  factory EquipmentModel.fromJson(dynamic json) => EquipmentModel(
      id: json["id"].toString(),
      userid: json["userid"].toString(),
      name: json["name"].toString(),
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      type: json["type"] ?? "",
      cost: json["cost"] ?? "",
      weight: json["weight"] as double,
      range: json["range"] ?? "",
      damage: json["damage"] ?? "",
      speed: json["speed"] as int,
      contents: json["contents"] ?? "",
      properties: json["properties"] ?? "",
      special: json["special"] ?? ""
  );

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "userid": userid,
      "name": name,
      "description": description,
      "category": category,
      "type": type,
      "cost": cost,
      "weight": weight,
      "range": range,
      "damage": damage,
      "speed": speed,
      "contents": contents,
      "properties": properties,
      "special": special
    };
  }

  Map<String, dynamic> toReducedJson(){
    return {
      "name": name,
      "description": description,
      "category": category,
      "type": type,
      "cost": cost,
      "weight": weight,
      "range": range,
      "damage": damage,
      "speed": speed,
      "contents": contents,
      "properties": properties,
      "special": special
    };
  }
}