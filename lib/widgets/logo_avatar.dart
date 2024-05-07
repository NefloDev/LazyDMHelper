import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/resources.dart';

class LogoAvatar extends StatelessWidget{
  const LogoAvatar({super.key, required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          height: radius*2,
        ),
        Positioned(top: 0, right: 0, left: 0,
            child: CircleAvatar(
                backgroundColor: colors.secondaryContainer, radius: radius)
        ),
        Positioned(top: 0, right: 0, left: 0,
            child: Image.asset(Resources.lazyDMAsset, width: radius*2, height: radius*2))
      ]
    );
  }

}