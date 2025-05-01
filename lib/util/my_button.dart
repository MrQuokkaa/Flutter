import '../exports/package_exports.dart';

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
      color: Colors.lightBlue,
      child: Text(text),
    );
  }
}