class ClassModel{
  final String id;
  final String userid;
  final String name;
  final String proficiencyOptions;
  final String proficiencies;
  final String savingThrows;
  final String startingEquipment;
  final String startingEquipmentOptions;
  final String subclasses;
  final String spellCasting;

  ClassModel({
      required this.id,
      required this.userid,
      required this.name,
      this.proficiencyOptions = "",
      this.proficiencies = "",
      this.savingThrows = "",
      this.startingEquipment = "",
      this.startingEquipmentOptions = "",
      this.subclasses = "",
      this.spellCasting = ""
  });
}