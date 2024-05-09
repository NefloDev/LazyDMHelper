import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/class_model.dart';
import 'package:lazy_dm_helper/screens/detail_screens/class_detail_screen.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class ClassCreationScreen extends StatefulWidget{
  const ClassCreationScreen(
      {
        super.key,
        required this.userid,
        this.data,
      });

  final ClassModel? data;

  final String userid;

  @override
  State<StatefulWidget> createState() => ClassCreationScreenState();
}

class ClassCreationScreenState extends State<ClassCreationScreen>{
  late TextEditingController nameController;
  late TextEditingController proficiencyOptionsController;
  late TextEditingController proficienciesController;
  late TextEditingController savingThrowsController;
  late TextEditingController startingEquipmentController;
  late TextEditingController startingEquipmentOptionsController;
  late TextEditingController subclassesController;
  late TextEditingController spellCastingController;

  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
    nameController = TextEditingController(text: widget.data?.name);
    proficiencyOptionsController = TextEditingController(text: widget.data?.proficiencyOptions);
    proficienciesController = TextEditingController(text: widget.data?.proficiencies);
    savingThrowsController = TextEditingController(text: widget.data?.savingThrows);
    startingEquipmentController = TextEditingController(text: widget.data?.startingEquipment);
    startingEquipmentOptionsController = TextEditingController(text: widget.data?.startingEquipmentOptions);
    subclassesController = TextEditingController(text: widget.data?.subclasses);
    spellCastingController = TextEditingController(text: widget.data?.spellCasting);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Texts.classTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.data == null ? () => Navigator.pop(context)
              : () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => ClassDetailScreen(index: widget.data!.id!, uid: widget.data!.userid)), (_) => false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataCreationTextForm(controller: nameController, labelText: "* ${Texts.name}"),
            DataCreationTextForm(controller: proficiencyOptionsController, labelText: Texts.proficiencyOptions),
            DataCreationTextForm(controller: proficienciesController, labelText: Texts.proficiencies),
            DataCreationTextForm(controller: savingThrowsController, labelText: Texts.savingThrows),
            DataCreationTextForm(controller: startingEquipmentController, labelText: Texts.startingEquipment),
            DataCreationTextForm(controller: startingEquipmentOptionsController, labelText: Texts.startingEquipmentOptions),
            DataCreationTextForm(controller: subclassesController, labelText: Texts.subClasses),
            DataCreationTextForm(controller: spellCastingController, labelText: Texts.spellCasting),
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
                      ClassModel temp = ClassModel(
                          userid: widget.userid,
                          name: nameController.text.trim(),
                          proficiencyOptions: proficiencyOptionsController.text.trim(),
                          proficiencies: proficienciesController.text.trim(),
                          savingThrows: savingThrowsController.text.trim(),
                          startingEquipmentOptions: startingEquipmentOptionsController.text.trim(),
                          startingEquipment: startingEquipmentController.text.trim(),
                          subclasses: subclassesController.text.trim(),
                          spellCasting: spellCastingController.text.trim(),
                      );
                      widget.data == null ? APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.classesEndpoint).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.classSave),
                              content: const Text(Texts.classSaveSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.classes,
                                            endpoint: Texts.classesEndpoint)
                                    ), (_) => false); }
                                )
                              ]
                          );
                        });
                      }) : APIManager.updateData(json: temp.toJson(), endpointPlural: Texts.classesEndpoint, endpoint: Texts.classEndpoint, index: widget.data!.id!, uid: widget.data!.userid).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.classSave),
                              content: const Text(Texts.classUpdateSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.classes,
                                            endpoint: Texts.classesEndpoint)
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