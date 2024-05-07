import 'package:flutter/material.dart';

class RoundedTextButton extends StatelessWidget{
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? radius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Size? size;
  final Text text;
  final Function()? onPressed;


  const RoundedTextButton(
      {this.backgroundColor,
        this.foregroundColor,
        this.radius,
        this.elevation,
        this.padding,
        this.size,
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
            fixedSize: MaterialStatePropertyAll(size ?? const Size(150, 80))
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical:8.0),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: text,
          ),
        )
    );
  }

}