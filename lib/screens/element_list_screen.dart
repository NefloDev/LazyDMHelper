import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/core.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/screens.dart';

import 'package:lazy_dm_helper/widgets/loading_indicator.dart';

class ElementListScreen extends StatefulWidget{
  final String title;
  final String endpoint;

  const ElementListScreen({super.key, required this.title, required this.endpoint});

  @override
  State<StatefulWidget> createState() => ElementListScreenState();
}

class ElementListScreenState extends State<ElementListScreen>{
  late List elements;
  late String userid;

  @override
  void initState() {
    super.initState();
    elements = [];
  }

  Future getElementsList(String uid) async {
    elements.clear();
    List temp = await APIManager.getElements(endpoint: widget.endpoint, uid: uid);
    setState(() {
      elements.addAll(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state){
      UserModel user = (state as AuthenticationLoggedInState).user;
      if(elements.isEmpty){
        getElementsList(user.id);
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuScreen()), (route) => false);
            },
          ),
        ),
        body: Center(
          child: elements.isEmpty ? const LoadingIndicator() : CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          getElementsList(user.id);
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List<Widget>.generate(elements.length, (i){
                              String name = elements[i]["name"];
                              String index = elements[i]["index"];
                              String userid = elements[i]["userid"];
                              return Column(
                                children: [
                                  MaterialButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return switch(widget.endpoint){
                                          Texts.magicItemsEndpoint => MagicItemDetailScreen(index: index, uid: userid),
                                          Texts.racesEndpoint => RaceDetailScreen(index: index, uid: userid),
                                          Texts.classesEndpoint => ClassDetailScreen(index: index, uid: userid),
                                          Texts.equipmentsEndpoint => EquipmentDetailScreen(index: index, uid: userid),
                                          String() => throw UnimplementedError(),
                                        };
                                      }));
                                    },
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Text(name)),
                                  ),
                                 const Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  )
                                ]
                              );
                            })
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: FloatingActionButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return switch(widget.endpoint){
                              Texts.magicItemsEndpoint => MagicItemCreationScreen(userid: user.id),
                              Texts.racesEndpoint => RaceCreationScreen(userid: user.id),
                              Texts.classesEndpoint => ClassCreationScreen(userid: user.id),
                              Texts.equipmentsEndpoint => EquipmentCreationScreen(userid: user.id),
                              String() => throw UnimplementedError(),
                            };
                          })),
                          backgroundColor: CustomColors.contrast,
                          foregroundColor: colors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Icon(Icons.add, color: colors.background)
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      );
    });
  }
}