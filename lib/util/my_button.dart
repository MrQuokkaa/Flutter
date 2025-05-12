import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  
  final String text;
  VoidCallback onPressed;
  
  MyButton({
    super.key, 
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: themeColor(context).secondary,
      child: Text(text),
    );
  }
}