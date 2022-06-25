import 'package:flutter/material.dart';

class AnimatedDialog{
  static void showAnimateDialog({required BuildContext context,required Widget alert}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: alert,
        );
      },
      barrierDismissible :true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}