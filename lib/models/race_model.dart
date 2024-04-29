class RaceModel{
  final String id;
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
      required this.id,
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
}