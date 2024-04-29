class MagicItemModel{
  final String id;
  final String userId;
  final String name;
  final String description;
  final String rarity;
  final String type;

  MagicItemModel({
      required this.id,
      required this.userId,
      required this.name,
      this.description = "",
      this.rarity = "",
      this.type = ""
      });
}