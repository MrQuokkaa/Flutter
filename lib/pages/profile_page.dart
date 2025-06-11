import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/util_exports.dart';
import '../exports/page_exports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Functions f = Functions();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: textTheme.headlineLarge,
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Profile Page Content Placeholder"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => f.logout(context),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}