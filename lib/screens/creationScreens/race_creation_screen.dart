import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/race_model.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class RaceCreationScreen extends StatefulWidget{
  const RaceCreationScreen({super.key, required this.userid});

  final String userid;

  @override
  State<StatefulWidget> createState() => RaceCreationScreenState();
}

class RaceCreationScreenState extends State<RaceCreationScreen>{
  TextEditingController nameController = TextEditingController();
  TextEditingController asiController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController alignmentController = TextEditingController();
  TextEditingController languagesController = TextEditingController();
  TextEditingController traitsController = TextEditingController();
  TextEditingController startingProficienciesController = TextEditingController();
  TextEditingController startingProficiencyOptionsController = TextEditingController();
  TextEditingController subRacesController = TextEditingController();

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
        title: const Text(Texts.raceTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataCreationTextForm(controller: nameController, labelText: "* ${Texts.name}"),
            DataCreationTextForm(controller: asiController, labelText: Texts.asi),
            DataCreationTextForm(controller: ageController, labelText: Texts.age),
            DataCreationTextForm(controller: sizeController, labelText: Texts.size),
            DataCreationTextForm(controller: speedController, labelText: Texts.speed),
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
                        speed: speedController.text.trim() as int,
                        alignment: alignmentController.text.trim(),
                        languages: languagesController.text.trim(),
                        traits: traitsController.text.trim(),
                        startingProficiencies: startingProficienciesController.text.trim(),
                        startingProficiencyOptions: startingProficiencyOptionsController.text.trim(),
                        subRaces: subRacesController.text.trim(),
                      );
                      APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.classesEndpoint).then((value) {
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