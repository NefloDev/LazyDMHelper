import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/screens/screens.dart';
import 'package:lazy_dm_helper/widgets/widgets.dart';

class MenuScreen extends StatelessWidget{
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(Texts.menuTitle),
            actions: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserSettingsScreen()));
              }, icon: const Icon(Icons.account_circle_outlined))
            ]
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedIconTextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ElementListScreen(endpoint: Texts.magicItemsEndpoint, title: Texts.magicItems))),
                              icon: SvgPicture.asset(Resources.itemAsset, width: 80,
                                  colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                              text: const Text(Texts.magicItems,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),
                              ),

                            ),
                            RoundedIconTextButton(
                                icon: SvgPicture.asset(Resources.monsterAsset, width: 80,
                                    colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                                text: const Text(Texts.notImplemented,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17
                                    )
                                )
                            )
                          ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                              children: [
                                const SizedBox(
                                  height: 190,
                                  width: 150,
                                ),
                                Positioned(
                                  top: 110,
                                  child: RoundedTextButton(
                                    size: const Size(150, 80),
                                    backgroundColor: colors.surface,
                                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                                    text: const Text(Texts.notImplemented,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: RoundedIconTextButton(
                                    size: const Size(150, 150),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ElementListScreen(endpoint: Texts.racesEndpoint, title: Texts.races))),
                                    icon: SvgPicture.asset(Resources.humanAsset, width: 80,
                                        colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                                    text: const Text(Texts.races,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),
                          Stack(
                              children: [
                                const SizedBox(
                                  height: 190,
                                  width: 150,
                                ),
                                Positioned(
                                  top: 110,
                                  child: RoundedTextButton(
                                    size: const Size(150, 80),
                                    backgroundColor: colors.surface,
                                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                                    text: const Text(Texts.notImplemented,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: RoundedIconTextButton(
                                    size: const Size(150, 150),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ElementListScreen(endpoint: Texts.classesEndpoint, title: Texts.classes))),
                                    icon: SvgPicture.asset(Resources.fistAsset, width: 80,
                                        colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                                    text: const Text(Texts.classes,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RoundedIconTextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ElementListScreen(endpoint: Texts.equipmentsEndpoint, title: Texts.equipment))),
                            icon: SvgPicture.asset(Resources.backpackAsset, width: 80,
                                colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                            text: const Text(Texts.equipment,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          ),
                          RoundedIconTextButton(
                            icon: SvgPicture.asset(Resources.sparklesAsset, width: 80,
                                colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                            text: const Text(Texts.notImplemented,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      child: RoundedIconTextButton(
                        size: const Size(350, 150),
                        icon: SvgPicture.asset(Resources.featureAsset, width: 80,
                            colorFilter: ColorFilter.mode(colors.surfaceVariant, BlendMode.srcIn)),
                        text: const Text(Texts.notImplemented,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }

}