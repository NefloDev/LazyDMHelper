import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/equipment_model.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class EquipmentCreationScreen extends StatefulWidget{
  const EquipmentCreationScreen({super.key, required this.userid});

  final String userid;

  @override
  State<StatefulWidget> createState() => EquipmentCreationScreenState();
}

class EquipmentCreationScreenState extends State<EquipmentCreationScreen>{
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController rangeController = TextEditingController();
  TextEditingController damageController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  TextEditingController propertiesController = TextEditingController();
  TextEditingController specialController = TextEditingController();

  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Texts.equipmentTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataCreationTextForm(controller: nameController, labelText: "* ${Texts.name}"),
            DataCreationTextForm(controller: descController, labelText: Texts.desc),
            DataCreationTextForm(controller: categoryController, labelText: Texts.category),
            DataCreationTextForm(controller: typeController, labelText: Texts.type),
            DataCreationTextForm(controller: costController, labelText: Texts.cost),
            DataCreationTextForm(controller: weightController, labelText: Texts.weight),
            DataCreationTextForm(controller: rangeController, labelText: Texts.range),
            DataCreationTextForm(controller: damageController, labelText: Texts.damage),
            DataCreationTextForm(controller: speedController, labelText: Texts.speed),
            DataCreationTextForm(controller: contentsController, labelText: Texts.contents),
            DataCreationTextForm(controller: propertiesController, labelText: Texts.properties),
            DataCreationTextForm(controller: specialController, labelText: Texts.special),
            const Padding(
              padding: EdgeInsets.symmetric(vertical:8.0, horizontal: 32.0),
              child: Text(Texts.requiredFields),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: !waiting ? MaterialButton(
                  onPressed: (){
                    if(nameController.text.isNotEmpty){
                      setState(() {
                        waiting = true;
                      });
                      EquipmentModel temp = EquipmentModel(
                        userid: widget.userid,
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                        category: categoryController.text.trim(),
                        type: typeController.text.trim(),
                        cost: costController.text.trim(),
                        weight: weightController.text.trim() as double,
                        range: rangeController.text.trim(),
                        damage: damageController.text.trim(),
                        speed: speedController.text.trim() as int,
                        contents: contentsController.text.trim(),
                        properties: propertiesController.text.trim(),
                        special: specialController.text.trim()
                      );
                      APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.classesEndpoint).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.equipmentSave),
                              content: const Text(Texts.equipmentSaveSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.equipment,
                                            endpoint: Texts.equipmentsEndpoint)
                                    ), (_) => false); }
                                )
                              ]
                          );
                        });
                      });
                    }
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  color: colors.primary,
                  minWidth: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(Texts.save,
                      style: TextStyle(
                          color: colors.surface
                      ),
                    ),
                  )
              ) : const SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }

}