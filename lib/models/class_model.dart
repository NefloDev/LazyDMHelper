class ClassModel{
  final String? id;
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
      this.id,
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

  factory ClassModel.fromJson(dynamic json) => ClassModel(
    id: json["id"].toString(),
    userid: json["userid"].toString(),
    name: json["name"].toString(),
    proficiencyOptions: json["proficiencyOptions"] ?? "",
    proficiencies: json["proficiencies"] ?? "",
    savingThrows: json["savingThrows"] ?? "",
    startingEquipment: json["startingEquipment"] ?? "",
    startingEquipmentOptions: json["startingEquipmentOptions"] ?? "",
    subclasses: json["subclasses"] ?? "",
    spellCasting: json["spellcasting"] ?? ""
  );

  Map<String, dynamic> toJson(){
    return{
      "id": id,
      "userid": userid,
      "name": name,
      "proficiencyOptions": proficiencyOptions,
      "proficiencies": proficiencies,
      "savingThrows": savingThrows,
      "startingEquipment": startingEquipment,
      "startingEquipmentOptions": startingEquipmentOptions,
      "subclasses": subclasses,
      "spellcasting": spellCasting
    };
  }
}