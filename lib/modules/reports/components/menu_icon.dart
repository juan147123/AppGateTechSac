import 'package:app_quick_reports/themes/ak_ui.dart';
import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  final double size;
  final void Function()? onPressed;

  MenuIcon({required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Widget _hs = SizedBox(
      width: size,
    );
    final Widget _vs = SizedBox(
      height: size,
    );
    final _dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: akTitleColor,
        borderRadius: BorderRadius.circular(size * 2),
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        padding: EdgeInsets.all(akContentPadding),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot,
                _hs,
                _dot,
              ],
            ),
            _vs,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot,
                _hs,
                _dot,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
