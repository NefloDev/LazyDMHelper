import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/equipment_model.dart';
import 'package:lazy_dm_helper/screens/detail_screens/detail_screens.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class EquipmentCreationScreen extends StatefulWidget{
  const EquipmentCreationScreen({super.key, required this.userid, this.data});

  final String userid;
  final EquipmentModel? data;

  @override
  State<StatefulWidget> createState() => EquipmentCreationScreenState();
}

class EquipmentCreationScreenState extends State<EquipmentCreationScreen>{
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController categoryController;
  late TextEditingController typeController;
  late TextEditingController costController;
  late TextEditingController weightController;
  late TextEditingController rangeController;
  late TextEditingController damageController;
  late TextEditingController speedController;
  late TextEditingController contentsController;
  late TextEditingController propertiesController;
  late TextEditingController specialController;

  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
    nameController = TextEditingController(text: widget.data?.name);
    descController = TextEditingController(text: widget.data?.description);
    categoryController = TextEditingController(text: widget.data?.category);
    typeController = TextEditingController(text: widget.data?.type);
    costController = TextEditingController(text: widget.data?.cost);
    weightController = TextEditingController(text: widget.data?.weight.toString());
    rangeController = TextEditingController(text: widget.data?.range);
    damageController = TextEditingController(text: widget.data?.damage);
    speedController = TextEditingController(text: widget.data?.speed.toString());
    contentsController = TextEditingController(text: widget.data?.contents);
    propertiesController = TextEditingController(text: widget.data?.properties);
    specialController = TextEditingController(text: widget.data?.special);
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
          onPressed: widget.data == null ? () => Navigator.pop(context)
          : () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => EquipmentDetailScreen(index: widget.data!.id!, uid: widget.data!.userid)), (_) => false),
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
            DataCreationTextForm(controller: weightController, labelText: Texts.weight, isDecimal: true,),
            DataCreationTextForm(controller: rangeController, labelText: Texts.range),
            DataCreationTextForm(controller: damageController, labelText: Texts.damage),
            DataCreationTextForm(controller: speedController, labelText: Texts.speed, isNumeric: true,),
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
                        weight: double.tryParse(weightController.text.trim()) ?? 0.0,
                        range: rangeController.text.trim(),
                        damage: damageController.text.trim(),
                        speed: int.tryParse(speedController.text.trim()) ?? 0,
                        contents: contentsController.text.trim(),
                        properties: propertiesController.text.trim(),
                        special: specialController.text.trim()
                      );
                      widget.data == null ? APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.equipmentsEndpoint).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
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
                      }) : APIManager.updateData(json: temp.toJson(), index: widget.data!.id!, endpointPlural: Texts.equipmentsEndpoint, endpoint: Texts.equipmentEndpoint, uid: widget.data!.userid).then((value){
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.equipmentSave),
                              content: const Text(Texts.equipmentUpdateSuccess),
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