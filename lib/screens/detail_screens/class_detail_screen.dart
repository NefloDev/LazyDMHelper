import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/creationScreens/class_creation_screen.dart';
import 'package:lazy_dm_helper/screens/screens.dart';

import 'package:lazy_dm_helper/widgets/loading_indicator.dart';
import 'package:lazy_dm_helper/widgets/title_and_text.dart';

class ClassDetailScreen extends StatefulWidget{
  final String index;
  final String uid;

  const ClassDetailScreen({super.key, required this.index, required this.uid});

  @override
  State<StatefulWidget> createState() => ClassDetailScreenState();

}

class ClassDetailScreenState extends State<ClassDetailScreen>{
  late ClassModel? classModel;

  @override
  void initState() {
    super.initState();
    classModel = null;
  }

  Future getClass() async {
    ClassModel? temp = await APIManager.getClass(index: widget.index, uid: widget.uid);
    setState(() {
      classModel = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    if(classModel == null){
      getClass();
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(classModel != null ? classModel!.name : Texts.classTitle)
        ),
        body: classModel == null ? const Center(child: LoadingIndicator())
            : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: getClass,
                        child: Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    classModel!.proficiencyOptions.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                        child: TitleAndText(title: Texts.proficiencyOptions, text: "· ${classModel!.proficiencyOptions.replaceAll("#", "\n· ").replaceAll("and ", "")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.proficiencies.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.proficiencies, text: "· ${classModel!.proficiencies.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.savingThrows.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.savingThrows, text: "· ${classModel!.savingThrows.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.startingEquipment.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.startingEquipment, text: "· ${classModel!.startingEquipment.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.startingEquipmentOptions.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.startingEquipmentOptions, text: "· ${classModel!.startingEquipmentOptions.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.subclasses.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.subClasses, text:  "· ${classModel!.subclasses.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    classModel!.spellCasting.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                  Texts.spellCasting,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: List.generate(classModel!.spellCasting.split("#").length, (index){
                                                String data = classModel!.spellCasting.replaceAll(".,", ".").split("#")[index];
                                                if(index == 0){
                                                  return Column(
                                                    children: [
                                                      TitleAndText(title: data.split(":")[0], text: data.split(":")[1].split("\n")[0]),
                                                      TitleAndText(title: data.split(":")[1].split("\n")[1], text: data.split(":")[2]),
                                                    ],
                                                  );
                                                }
                                                return TitleAndText(title: data.split("::")[0], text: data.split("::")[1]);
                                              }),
                                            )
                                          ],
                                        )
                                    ) : const SizedBox.shrink()
                                  ]
                              )
                          ),
                        ),
                      ),
                      widget.uid != "owner" ? Positioned(
                          bottom: 24,
                          right: 24,
                          left: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                  onPressed: (){
                                    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: const Text(Texts.classDelete),
                                        content: const Text(Texts.classDeleteConfirm),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(Texts.no),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              APIManager.deleteClass(uid: widget.uid, index: widget.index).then((value) {
                                                Navigator.pop(context);
                                                showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text(value == 200 ? Texts.classDeleteSuccess : Texts.classDeleteFail),
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
                                            },
                                            child: const Text(Texts.yes),
                                          )
                                        ],
                                      );
                                    });
                                  },
                                  backgroundColor: colors.primaryContainer,
                                  foregroundColor: colors.surface,
                                  child: Icon(Icons.delete_forever, color: colors.secondary)
                              ),
                              FloatingActionButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context) => ClassCreationScreen(
                                        userid: classModel!.userid,
                                        data: classModel!
                                      )
                                  ), (_) => false),
                                  backgroundColor: CustomColors.highlight,
                                  foregroundColor: colors.surface,
                                  child: Icon(Icons.edit, color: colors.secondary)
                              )
                            ],
                          )
                      ) : const SizedBox.shrink(),
                    ]
                  )
                )
              ]
            )
    );
  }

}