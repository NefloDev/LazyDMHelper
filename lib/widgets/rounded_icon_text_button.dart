import 'package:flutter/material.dart';

class RoundedIconTextButton extends StatelessWidget{
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? radius;
  final double? elevation;
  final Size? size;
  final Widget icon;
  final Text text;
  final Function()? onPressed;

  RoundedIconTextButton(
      {this.backgroundColor,
        this.foregroundColor,
        this.radius,
        this.elevation,
        this.size,
        required this.icon,
        required this.text,
        this.onPressed
      });

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(backgroundColor ?? colors.surfaceTint),
            foregroundColor: MaterialStatePropertyAll(foregroundColor ?? colors.surfaceVariant),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 10)
            )),
            elevation: MaterialStatePropertyAll(elevation ?? 3),
            fixedSize: MaterialStatePropertyAll(size ?? const Size(150, 150))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon,
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: text,
                )
              ]
          ),
        )
    );
  }

}