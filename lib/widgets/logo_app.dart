part of 'widgets.dart';

class LogoApp extends StatelessWidget {
  final double size;
  final bool whiteMode;

  LogoApp({this.size = 100, this.whiteMode = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      this.whiteMode
          ? 'assets/img/logo_white.png'
          : 'assets/img/logo_color.png',
      width: size,
    );
  }
}
