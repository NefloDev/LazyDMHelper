import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/models.dart';

void main() {

  const String testUID = "7xEXLf5uV1fZL7uFfQO3pxsmpeA2";
  const String ownerUID = "owner";

  setUp((){
    dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());
  });

  group('Test get classes, equipment, races and magic items', () {

    test('Get classes should not be empty', () async {
      List response = await APIManager.getElements(endpoint: Texts.classesEndpoint, uid: testUID);
      expect(response.isNotEmpty, true);
    });

    test('Get equipment should not be empty', () async {
      List response = await APIManager.getElements(endpoint: Texts.equipmentsEndpoint, uid: testUID);
      expect(response.isNotEmpty, true);
    });

    test('Get races should not be empty', () async {
      List response = await APIManager.getElements(endpoint: Texts.racesEndpoint, uid: testUID);
      expect(response.isNotEmpty, true);
    });

    test('Get magicItems should not be empty', () async {
      List response = await APIManager.getElements(endpoint: Texts.magicItemsEndpoint, uid: testUID);
      expect(response.isNotEmpty, true);
    });

  });

  group('Get specific class, equipment, race and magicItem', (){

    test('Get barbarian class should not be null', () async {
      ClassModel? response = await APIManager.getClass(index: "barbarian", uid: ownerUID);
      expect(response != null, true);
    });

    test('Get dragonborn race should not be null', () async {
      RaceModel? response = await APIManager.getRace(index: "dragonborn", uid: ownerUID);
      expect(response != null, true);
    });

    test('Get adamantine armor magic item should not be null', () async {
      MagicItemModel? response = await APIManager.getMagicItem(index: "adamantine-armor", uid: ownerUID);
      expect(response != null, true);
    });

    test('Get abacus equipment should not be null', () async {
      EquipmentModel? response = await APIManager.getEquipment(index: "abacus", uid: ownerUID);
      expect(response != null, true);
    });

  });

  group('Get classes, equipments, races and magic items by user', () {

    test('Get classes by test UID', () async {
       await APIManager.saveData(json: {
         "name": "testName",
         "userid": testUID
       }, endpointPlural: Texts.classesEndpoint);
       List response = await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid: testUID);
       await APIManager.deleteClass(uid: testUID, index: response.first["id"]);
       expect(response.isNotEmpty, true);
    });

    test('Get equipments by test UID', () async {
      await APIManager.saveData(json: {
        "name": "testName",
        "userid": testUID
      }, endpointPlural: Texts.equipmentsEndpoint);
      List response = await APIManager.getElementsByUser(endpoint: Texts.equipmentsEndpoint, uid: testUID);
      await APIManager.deleteEquipment(uid: testUID, index: response.first["id"]);
      expect(response.isNotEmpty, true);
    });

    test('Get races by test UID', () async {
      await APIManager.saveData(json: {
        "name": "testName",
        "userid": testUID
      }, endpointPlural: Texts.racesEndpoint);
      List response = await APIManager.getElementsByUser(endpoint: Texts.racesEndpoint, uid: testUID);
      await APIManager.deleteRace(uid: testUID, index: response.first["id"]);
      expect(response.isNotEmpty, true);
    });

    test('Get magic items by test UID', () async {
      await APIManager.saveData(json: {
        "name": "testName",
        "userid": testUID
      }, endpointPlural: Texts.magicItemsEndpoint);
      List response = await APIManager.getElementsByUser(endpoint: Texts.magicItemsEndpoint, uid: testUID);
      await APIManager.deleteMagicItem(uid: testUID, index: response.first["id"]);
      expect(response.isNotEmpty, true);
    });

  });

  test('Update elements name', () async {
    await APIManager.saveData(json: {
      "name": "testName",
      "userid": testUID
    }, endpointPlural: Texts.classesEndpoint);
    List response = await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid: testUID);

    expect(response.first["name"], "testName");

    await APIManager.updateData(json: {
      "name": "changedName",
      "userid": testUID
    }, index: response.first["id"], endpointPlural: Texts.classesEndpoint, endpoint: Texts.classEndpoint, uid: testUID);
    response = await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid: testUID);
    expect(response.first["name"], "changedName");

    await APIManager.deleteClass(uid: testUID, index: response.first["id"]);
  });

  test('Delete users data', () async {
    //Save data
    await APIManager.saveData(json: {"name": "testName", "userid": testUID}, endpointPlural: Texts.classesEndpoint);
    await APIManager.saveData(json: {"name": "testName", "userid": testUID}, endpointPlural: Texts.equipmentsEndpoint);
    await APIManager.saveData(json: {"name": "testName", "userid": testUID}, endpointPlural: Texts.racesEndpoint);
    await APIManager.saveData(json: {"name": "testName", "userid": testUID}, endpointPlural: Texts.magicItemsEndpoint);
    //Get data
    List response = [];
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.equipmentsEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.racesEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.magicItemsEndpoint, uid: testUID));
    //Check data is retrieved and clear data
    expect(response.length, 4);
    response.clear();
    //Delete data from database
    await APIManager.deleteData(uid: testUID);
    //Try to get data
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.equipmentsEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.racesEndpoint, uid: testUID));
    response.addAll(await APIManager.getElementsByUser(endpoint: Texts.magicItemsEndpoint, uid: testUID));
    //Check if data is empty
    expect(response.isEmpty, true);
  });
  
  test('Delete user', () async {
    await APIManager.saveData(json: {"userid": "test"}, endpointPlural: Texts.usersEndpoint);
    await APIManager.saveData(json: {"userid": "test", "name": "testName"}, endpointPlural: Texts.classesEndpoint);
    List response = await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid:"test");
    expect(response.isNotEmpty, true);

    await APIManager.deleteUser(uid: "test");
    response = await APIManager.getElementsByUser(endpoint: Texts.classesEndpoint, uid:"test");
    expect(response.isEmpty, true);
  });

}
