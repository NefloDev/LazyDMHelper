class BasicData{
  final String index;
  final String name;
  final String userid;

  BasicData({required this.index, required this.userid, required this.name});

  factory BasicData.fromJson(dynamic json) => BasicData(
      index: json["index"] ?? "",
      userid: json["userid"] ?? "",
      name: json["name"] ?? ""
  );
}