import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/util_exports.dart';
import '../exports/page_exports.dart';

class NameInputPage extends StatelessWidget {
  NameInputPage({super.key});

  final TextEditingController _controller = TextEditingController();
  final Functions f = Functions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What's your name?",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  await f.saveUserName(name);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(userName: name),
                      ),
                    );
                  };
                };
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
