import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.lightGreen,
            child: const Center(child: Text("Profile"))));
  }
}
