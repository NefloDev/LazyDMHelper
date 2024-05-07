import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lazy_dm_helper/models/models.dart';

class APIManager{
  static Future<List> getElements({required String endpoint, required String uid}) async {
    List list = [];
    var url = Uri.https(dotenv.get("API_ENDPOINT"), "$endpoint${Texts.dataEndpoint}/$uid");
    var response = await http.get(url);
    dynamic jsonBody;
    if(response.statusCode == 200){
      jsonBody = json.decode(utf8.decode(response.bodyBytes));
      list.addAll(jsonBody);
      list.sort((a, b) => a["name"].toString().toLowerCase().compareTo(b["name"].toString().toLowerCase()));
    }

    return list;
  }

  static Future<List> getElementsByUser({required String endpoint, required String uid}) async {
    List list = [];
    var url = Uri.https(dotenv.get("API_ENDPOINT"), "$endpoint/$uid");
    var response = await http.get(url);
    dynamic jsonBody;
    if(response.statusCode == 200){
      jsonBody = json.decode(utf8.decode(response.bodyBytes));
      list.addAll(jsonBody);
      list.sort((a, b) => a["name"].toString().toLowerCase().compareTo(b["name"].toString().toLowerCase()));
    }

    return list;
  }

  static Future<int> deleteElement({required String index, required String endpointPlural, required String endpoint, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "$endpointPlural$endpoint/$index/$uid");
    final response = await http.delete(url);
    return response.statusCode;
  }

  static Future<int> saveData({required Map<String, dynamic> json, required String endpointPlural}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), endpointPlural);
    final response = await http.post(url, body: jsonEncode(json));
    return response.statusCode;
  }

  static Future<int> updateData({required Map<String, dynamic> json, required String index, required String endpointPlural, required String endpoint, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "$endpointPlural$endpoint/$index/$uid");
    final response = await http.put(url, body: jsonEncode(json));
    return response.statusCode;
  }

  static Future<ClassModel?> getClass({required String index, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "${Texts.classesEndpoint}${Texts.classEndpoint}/$index${uid != "owner" ? "/$uid" : ""}");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return ClassModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  static Future<MagicItemModel?> getMagicItem({required String index, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "${Texts.magicItemsEndpoint}${Texts.magicItemEndpoint}/$index${uid != "owner" ? "/$uid" : ""}");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return MagicItemModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  static Future<EquipmentModel?> getEquipment({required String index, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "${Texts.equipmentsEndpoint}${Texts.equipmentEndpoint}/$index${uid != "owner" ? "/$uid" : ""}");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return EquipmentModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  static Future<RaceModel?> getRace({required String index, required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "${Texts.racesEndpoint}${Texts.raceEndpoint}/$index${uid != "owner" ? "/$uid" : ""}");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return RaceModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  //DELETE

  static Future<int> deleteClass({required String uid, required String index}) async {
    return deleteElement(index: index, endpointPlural: Texts.classesEndpoint, endpoint: Texts.classEndpoint, uid: uid);
  }

  static Future<int> deleteMagicItem({required String uid, required String index}) async {
    return deleteElement(index: index, endpointPlural: Texts.magicItemsEndpoint, endpoint: Texts.magicItemEndpoint, uid: uid);
  }

  static Future<int> deleteRace({required String uid, required String index}) async {
    return deleteElement(index: index, endpointPlural: Texts.racesEndpoint, endpoint: Texts.raceEndpoint, uid: uid);
  }

  static Future<int> deleteEquipment({required String uid, required String index}) async {
    return deleteElement(index: index, endpointPlural: Texts.equipmentsEndpoint, endpoint: Texts.equipmentEndpoint, uid: uid);
  }

  static Future deleteUser({required String uid}) async {
    final url = Uri.https(dotenv.get("API_ENDPOINT"), "${Texts.usersEndpoint}${Texts.userEndpoint}/$uid");
    await http.delete(url);
  }

  static Future<int> deleteData({required String uid}) async {
    List equipments = await getElementsByUser(endpoint: Texts.equipmentsEndpoint, uid: uid);
    List classes = await getElementsByUser(endpoint: Texts.classesEndpoint, uid: uid);
    List races = await getElementsByUser(endpoint: Texts.racesEndpoint, uid: uid);
    List magicItems = await getElementsByUser(endpoint: Texts.magicItemsEndpoint, uid: uid);

    int success = 0;

    for(dynamic equipment in equipments){
      await deleteEquipment(uid: uid, index: equipment["id"].toString()) == 200 ? success++ : success = success;
    }
    for(dynamic classData in classes){
      await deleteClass(uid: uid, index: classData["id"].toString()) == 200 ? success++ : success = success;
    }
    for(dynamic race in races){
      await deleteRace(uid: uid, index: race["id"].toString()) == 200 ? success++ : success = success;
    }
    for(dynamic magicItem in magicItems){
      await deleteMagicItem(uid: uid, index: magicItem["id"].toString()) == 200 ? success++ : success = success;
    }

    return success == (equipments.length + classes.length + races.length + magicItems.length) ? 200 : 400;
  }
}