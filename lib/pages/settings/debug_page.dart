import '../../exports/package_exports.dart';
import '../../exports/theme_exports.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Debug Page", style: textTheme.headlineLarge),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildColorPreview(context, "Primary", themeColor(context).primary),
          const Divider(),
          _buildColorPreview(
              context, "Secondary", themeColor(context).secondary),
          const Divider(),
          _buildColorPreview(context, "Tertiary", themeColor(context).tertiary),
        ],
      ),
    );
  }

  Widget _buildColorPreview(BuildContext context, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 50,
        color: color,
        child: Center(
          child: Text('Current $label Color'),
        ),
      ),
    );
  }
}
