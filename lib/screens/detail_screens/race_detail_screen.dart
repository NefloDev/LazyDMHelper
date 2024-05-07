import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/texts.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/screens.dart';

import 'package:lazy_dm_helper/widgets/loading_indicator.dart';
import 'package:lazy_dm_helper/widgets/title_and_text.dart';

class RaceDetailScreen extends StatefulWidget{
  final String index;
  final String uid;

  const RaceDetailScreen({super.key, required this.index, required this.uid});

  @override
  State<StatefulWidget> createState() => RaceDetailScreenState();

}

class RaceDetailScreenState extends State<RaceDetailScreen>{
  late RaceModel? race;

  @override
  void initState() {
    super.initState();
    race = null;
  }

  Future getRace() async {
    RaceModel? temp = await APIManager.getRace(index: widget.index, uid: widget.uid);
    setState(() {
      race = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    if(race == null){
      getRace();
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(race != null ? race!.name : Texts.raceTitle)
        ),
        body: race == null ? const Center(child: LoadingIndicator())
            : CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: getRace,
                    child: Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: TitleAndText(title: Texts.asi, text: race!.asi)
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.age, text: race!.age)
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.size, text: race!.size)
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.speed, text: race!.speed.toString())
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.alignment, text: race!.alignment)
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.languages, text: race!.languages)
                                ),
                                race!.traits.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.traits, text: "· ${race!.traits.replaceAll("#", "\n· ")}")
                                ) : const SizedBox.shrink(),
                                race!.startingProficiencies.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.startingProficiencies, text: "· ${race!.startingProficiencies.replaceAll("#", "\n· ")}")
                                ) : const SizedBox.shrink(),
                                race!.startingProficiencyOptions.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.startingProficiencyOptions, text: "· ${race!.startingProficiencyOptions.replaceAll("#", "\n· ")}")
                                ) : const SizedBox.shrink(),
                                race!.subRaces.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TitleAndText(title: Texts.subRaces, text: "· ${race!.subRaces.replaceAll("#", "\n· ")}")
                                ) : const SizedBox.shrink()
                              ]
                          )
                      ),
                    ),
                  ),
                  widget.uid != "owner" ? Positioned(
                      bottom: 24,
                      right: 24,
                      child: FloatingActionButton(
                          onPressed: (){
                            showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                              return AlertDialog(
                                  title: const Text(Texts.raceDelete),
                                  content: const Text(Texts.raceDeleteConfirm),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(Texts.no),
                                    ),
                                    MaterialButton(
                                      onPressed: (){
                                        APIManager.deleteRace(uid: widget.uid, index: widget.index).then((value) {
                                          Navigator.pop(context);
                                          showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(value == 200 ? Texts.raceDeleteSuccess : Texts.raceDeleteFail),
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
                                      },
                                      child: const Text(Texts.yes),
                                    )
                                  ]
                              );
                            });
                          },
                          backgroundColor: colors.primaryContainer,
                          foregroundColor: colors.surface,
                          child: Icon(Icons.delete_forever, color: colors.secondary)
                      )
                  ) : const SizedBox.shrink()
                ],
              ),
            )
          ],
        )
    );
  }

}