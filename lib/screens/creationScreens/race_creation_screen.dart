import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/race_model.dart';
import 'package:lazy_dm_helper/screens/detail_screens/detail_screens.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class RaceCreationScreen extends StatefulWidget{
  const RaceCreationScreen({super.key, required this.userid, this.data});

  final String userid;
  final RaceModel? data;

  @override
  State<StatefulWidget> createState() => RaceCreationScreenState();
}

class RaceCreationScreenState extends State<RaceCreationScreen>{
  late TextEditingController nameController;
  late TextEditingController asiController;
  late TextEditingController ageController;
  late TextEditingController sizeController;
  late TextEditingController speedController;
  late TextEditingController alignmentController;
  late TextEditingController languagesController;
  late TextEditingController traitsController;
  late TextEditingController startingProficienciesController;
  late TextEditingController startingProficiencyOptionsController;
  late TextEditingController subRacesController;

  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
    nameController = TextEditingController(text: widget.data?.name);
    asiController = TextEditingController(text: widget.data?.asi);
    ageController = TextEditingController(text: widget.data?.age);
    sizeController = TextEditingController(text: widget.data?.size);
    speedController = TextEditingController(text: widget.data?.speed.toString());
    alignmentController = TextEditingController(text: widget.data?.alignment);
    languagesController = TextEditingController(text: widget.data?.languages);
    traitsController = TextEditingController(text: widget.data?.traits);
    startingProficienciesController = TextEditingController(text: widget.data?.startingProficiencies);
    startingProficiencyOptionsController = TextEditingController(text: widget.data?.startingProficiencyOptions);
    subRacesController = TextEditingController(text: widget.data?.subRaces);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Texts.raceTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.data == null ? () => Navigator.pop(context)
              : () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => RaceDetailScreen(index: widget.data!.id!, uid: widget.data!.userid)), (_) => false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataCreationTextForm(controller: nameController, labelText: "* ${Texts.name}"),
            DataCreationTextForm(controller: asiController, labelText: Texts.asi),
            DataCreationTextForm(controller: ageController, labelText: Texts.age),
            DataCreationTextForm(controller: sizeController, labelText: Texts.size),
            DataCreationTextForm(controller: speedController, labelText: Texts.speed, isNumeric: true),
            DataCreationTextForm(controller: alignmentController, labelText: Texts.alignment),
            DataCreationTextForm(controller: languagesController, labelText: Texts.languages),
            DataCreationTextForm(controller: traitsController, labelText: Texts.traits),
            DataCreationTextForm(controller: startingProficienciesController, labelText: Texts.startingProficiencies),
            DataCreationTextForm(controller: startingProficiencyOptionsController, labelText: Texts.startingProficiencyOptions),
            DataCreationTextForm(controller: subRacesController, labelText: Texts.subRaces),
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
                      RaceModel temp = RaceModel(
                        userid: widget.userid,
                        name: nameController.text.trim(),
                        asi: asiController.text.trim(),
                        age: ageController.text.trim(),
                        size: sizeController.text.trim(),
                        speed: int.parse(speedController.text.trim().isEmpty ? "0": speedController.text.trim()),
                        alignment: alignmentController.text.trim(),
                        languages: languagesController.text.trim(),
                        traits: traitsController.text.trim(),
                        startingProficiencies: startingProficienciesController.text.trim(),
                        startingProficiencyOptions: startingProficiencyOptionsController.text.trim(),
                        subRaces: subRacesController.text.trim(),
                      );
                      widget.data == null ? APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.racesEndpoint).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.raceSave),
                              content: const Text(Texts.raceSaveSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.races,
                                            endpoint: Texts.racesEndpoint)
                                    ), (_) => false); }
                                )
                              ]
                          );
                        });
                      }) : APIManager.updateData(json: temp.toJson(), index: widget.data!.id!, endpointPlural: Texts.racesEndpoint, endpoint: Texts.raceEndpoint, uid: widget.data!.userid).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.raceSave),
                              content: const Text(Texts.raceUpdateSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.races,
                                            endpoint: Texts.racesEndpoint)
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