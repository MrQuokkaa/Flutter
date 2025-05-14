import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/util_exports.dart';
import '../exports/page_exports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Functions f = Functions();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        color: Colors.lightGreen,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Profile"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await f.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}