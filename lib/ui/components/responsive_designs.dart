import 'package:flutter/material.dart';
import 'package:hex_game/ui/components/const.dart';

class ResponsiveDesign {
  static Widget centeredAndMaxWidth({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
      child: Wrap(
        children: [
          Center(
            child: ConstrainedBox(constraints: BoxConstraints(maxWidth: AppDimensions.smallScreenSize), child: child),
          ),
        ],
      ),
    );
  }
}
