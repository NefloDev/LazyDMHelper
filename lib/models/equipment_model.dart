class EquipmentModel{
  final String id;
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
      required this.id,
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
}