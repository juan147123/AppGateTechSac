part of 'widgets.dart';

class ArrowBack extends StatelessWidget {
  final double size;
  final void Function()? onTap;
  final Color? color;

  ArrowBack({this.size = 5.0, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: akContentPadding, vertical: akContentPadding * 0.75),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: SvgPicture.asset(
            'assets/icons/arrow_right.svg',
            color: this.color != null ? this.color : akPrimaryColor,
            width: akFontSize + 6.0,
          ),
        ),
      ),
    );
  }
}
