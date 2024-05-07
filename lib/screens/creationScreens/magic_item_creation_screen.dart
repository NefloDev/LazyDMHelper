import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/magic_item_model.dart';
import 'package:lazy_dm_helper/screens/detail_screens/detail_screens.dart';
import 'package:lazy_dm_helper/screens/element_list_screen.dart';
import 'package:lazy_dm_helper/widgets/data_creation_text_form.dart';

class MagicItemCreationScreen extends StatefulWidget{
  const MagicItemCreationScreen({super.key, required this.userid, this.data});

  final String userid;

  final MagicItemModel? data;

  @override
  State<StatefulWidget> createState() => MagicItemCreationScreenState();
}

class MagicItemCreationScreenState extends State<MagicItemCreationScreen>{
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController rarityController;
  late TextEditingController typeController;

  late bool waiting;

  @override
  void initState() {
    super.initState();
    waiting = false;
    nameController = TextEditingController(text: widget.data?.name);
    descController = TextEditingController(text: widget.data?.description);
    rarityController = TextEditingController(text: widget.data?.rarity);
    typeController = TextEditingController(text: widget.data?.type);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Texts.magicItemTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.data == null ? () => Navigator.pop(context)
          : () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => MagicItemDetailScreen(index: widget.data!.id!, uid: widget.data!.userid)), (_) => false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataCreationTextForm(controller: nameController, labelText: "* ${Texts.name}"),
            DataCreationTextForm(controller: descController, labelText: Texts.desc),
            DataCreationTextForm(controller: rarityController, labelText: Texts.rarity),
            DataCreationTextForm(controller: typeController, labelText: Texts.type),
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
                      MagicItemModel temp = MagicItemModel(
                          userid: widget.userid,
                          name: nameController.text.trim(),
                          description: descController.text.trim(),
                          rarity: rarityController.text.trim(),
                          type: typeController.text.trim()
                      );
                      widget.data == null ? APIManager.saveData(json: temp.toJson(), endpointPlural: Texts.magicItemsEndpoint).then((value) {
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(Texts.magicItemSave),
                            content: const Text(Texts.magicItemSaveSuccess),
                            actions: [
                              MaterialButton(
                                  child: const Text(Texts.close),
                                  onPressed: () { Navigator.of(context)
                                      .pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context) => const ElementListScreen(
                                          title: Texts.magicItems,
                                          endpoint: Texts.magicItemsEndpoint)
                                  ), (_) => false); }
                              )
                            ]
                          );
                        });
                      }) : APIManager.updateData(json: temp.toJson(), index: widget.data!.id!, endpointPlural: Texts.magicItemsEndpoint, endpoint: Texts.magicItemEndpoint, uid: widget.data!.userid).then((value){
                        setState(() {
                          waiting = false;
                        });
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(Texts.magicItemSave),
                              content: const Text(Texts.magicItemUpdateSuccess),
                              actions: [
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => const ElementListScreen(
                                            title: Texts.magicItems,
                                            endpoint: Texts.magicItemsEndpoint)
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