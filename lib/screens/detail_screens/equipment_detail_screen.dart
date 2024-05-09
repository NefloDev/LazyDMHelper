import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/screens.dart';
import 'package:lazy_dm_helper/widgets/widgets.dart';

class EquipmentDetailScreen extends StatefulWidget{
  final String index;
  final String uid;

  const EquipmentDetailScreen({super.key, required this.index, required this.uid});

  @override
  State<StatefulWidget> createState() => EquipmentDetailScreenState();

}

class EquipmentDetailScreenState extends State<EquipmentDetailScreen>{
  late EquipmentModel? equipment;

  @override
  void initState() {
    super.initState();
    equipment = null;
  }

  Future getEquipment() async {
    EquipmentModel? temp = await APIManager.getEquipment(index: widget.index, uid: widget.uid);
    setState(() {
      equipment = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    if(equipment == null){
      getEquipment();
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(equipment != null ? equipment!.name : Texts.equipmentTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => const ElementListScreen(title: Texts.equipment, endpoint: Texts.equipmentsEndpoint)), (_) => false),
          ),
        ),
        body: equipment == null ? const Center(child: LoadingIndicator())
            : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: getEquipment,
                        child: Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    equipment!.description.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                        child: TitleAndText(title: Texts.desc, text: equipment!.description)
                                    ) : const SizedBox.shrink(),
                                    equipment!.category.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.category, text: equipment!.category)
                                    ) : const SizedBox.shrink(),
                                    equipment!.type.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.type, text: equipment!.type)
                                    ) : const SizedBox.shrink(),
                                    equipment!.cost.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.cost, text: equipment!.cost)
                                    ) : const SizedBox.shrink(),
                                    equipment!.weight > 0 ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.weight, text: equipment!.weight.toString())
                                    ) : const SizedBox.shrink(),
                                    equipment!.range.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.range, text:  equipment!.range)
                                    ) : const SizedBox.shrink(),
                                    equipment!.damage.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.damage, text: equipment!.damage)
                                    ) : const SizedBox.shrink(),
                                    equipment!.speed > 0 ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.speed, text: equipment!.speed.toString())
                                    ) : const SizedBox.shrink(),
                                    equipment!.contents.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.contents, text: "· ${equipment!.contents.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    equipment!.properties.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.properties, text: "· ${equipment!.properties.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink(),
                                    equipment!.special.isNotEmpty ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: TitleAndText(title: Texts.special, text: "· ${equipment!.special.replaceAll("#", "\n· ")}")
                                    ) : const SizedBox.shrink()
                                  ]
                              )
                          ),
                        ),
                      ),
                      widget.uid != "owner" ? Positioned(
                          bottom: 36,
                          right: 24,
                          left: 190,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                  onPressed: (){
                                    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: const Text(Texts.equipmentDelete),
                                        content: const Text(Texts.equipmentDeleteConfirm),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(Texts.no),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              APIManager.deleteEquipment(uid: widget.uid, index: widget.index).then((value) {
                                                Navigator.pop(context);
                                                showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text(value == 200 ? Texts.equipmentDeleteSuccess : Texts.equipmentDeleteFail),
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
                                            },
                                            child: const Text(Texts.yes),
                                          )
                                        ],
                                      );
                                    });
                                  },
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.background,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: const Icon(Icons.delete_forever)
                              ),
                              FloatingActionButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (context) => EquipmentCreationScreen(
                                          userid: equipment!.userid,
                                          data: equipment!
                                      )
                                  ), (_) => false),
                                  backgroundColor: CustomColors.contrast,
                                  foregroundColor: colors.background,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: const Icon(Icons.edit)
                              )
                            ],
                          )
                      ) : const SizedBox.shrink()
                    ]
                  ),
                )
              ]
            )
    );
  }

}