import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/texts.dart';
import 'package:lazy_dm_helper/core/api_manager.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/screens.dart';

import 'package:lazy_dm_helper/widgets/widgets.dart';

class MagicItemDetailScreen extends StatefulWidget{
  final String index;
  final String uid;

  const MagicItemDetailScreen({super.key, required this.index, required this.uid});

  @override
  State<StatefulWidget> createState() => MagicItemDetailScreenState();

}

class MagicItemDetailScreenState extends State<MagicItemDetailScreen>{
  late MagicItemModel? magicItem;

  @override
  void initState() {
    super.initState();
    magicItem = null;
  }

  Future getMagicItem() async {
    MagicItemModel? temp = await APIManager.getMagicItem(index: widget.index, uid: widget.uid);
    setState(() {
      magicItem = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    if(magicItem == null){
      getMagicItem();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(magicItem != null ? magicItem!.name : Texts.magicItemTitle)
      ),
      body: magicItem == null ? const Center(child: LoadingIndicator())
          : CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: getMagicItem,
                  child: Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                magicItem!.description.isNotEmpty ? Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: TitleAndText(title: Texts.desc, text: magicItem!.description),
                                ) : const SizedBox.shrink(),
                                magicItem!.rarity.isNotEmpty ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TitleAndText(title: Texts.rarity, text: magicItem!.rarity),
                                ) : const SizedBox.shrink(),
                                magicItem!.type.isNotEmpty ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TitleAndText(title: Texts.type, text: magicItem!.type),
                                ) : const SizedBox.shrink()
                              ]
                          )
                      )
                  ),
                ),
                widget.uid != "owner" ? Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton(
                        onPressed: (){
                          showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                            return AlertDialog(
                                title: const Text(Texts.magicItemDelete),
                                content: const Text(Texts.magicItemDeleteConfirm),
                                actions: [
                                  MaterialButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(Texts.no),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      APIManager.deleteMagicItem(uid: widget.uid, index: widget.index).then((val) {
                                        Navigator.pop(context);
                                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text(val == 200 ? Texts.magicItemDeleteSuccess : Texts.magicItemDeleteFail),
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
              ]
            )
          )
        ],
      )
    );
  }

}