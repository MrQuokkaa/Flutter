import '../exports/package_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override 
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Functions f = Functions();
  File? _profileImage;
  String? _uploadError;
  double xp = 0.4;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      try {
        debugLog('[Profile] Uploading profile picture');
        final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

        await storageRef.putFile(file);
        debugLog('[Profile] Upload complete');
        final downloadUrl = await storageRef.getDownloadURL();
        debugLog('[Profile] Retrieved download URL: $downloadUrl');

        await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': downloadUrl});
        debugLog('[Profile] Firestore updated with new image URL');

        setState((){
          _profileImage = file;
          _uploadError = null;
        });

        Provider.of<ProfileProvider>(context, listen: false).updateProfileImage(downloadUrl);
        debugLog('[Profile] Provider updated with new image');
      } catch (e) {
        debugLog('[Profile] Image upload error: $e');
        setState(() {
          _uploadError = 'Failed to upload image. Please try again.';
        });
      }
    } else {
      debugLog('[Profile] No image was selected');
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    final imageProvider = _profileImage != null
      ? FileImage(_profileImage!)
      : imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack( //StatefulBuilder!!!
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: imageProvider
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickAndUploadImage();

                        setState(() {});
                      },
                      child: const Text("Change profile picture"),
                    ),
                    if (_uploadError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _uploadError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                )
              )
            ],
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final imageUrl = profileProvider.imageUrl;
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'User';

    final imageProvider = _profileImage != null
      ? FileImage(_profileImage!)
      : imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => f.logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4), // nudge avatar slightly up or down
                  child: GestureDetector(
                    onTap: () => _showImageDialog(context, imageUrl),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Level..',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '0/... XP',
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  // Background
                                  Container(
                                    height: 14,
                                    color: Colors.grey.shade300,
                                  ),
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: xp.clamp(0.0, 1.0),
                                    child: Container(
                                      height: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        int tickCount = 3; 
                                        double spacing = constraints.maxWidth / (tickCount + 1);

                                        return Stack(
                                          children: List.generate(tickCount, (index) {
                                            return Positioned(
                                              left: spacing * (index + 1) - 1,
                                              top: 2,
                                              bottom: 2,
                                              child: Container(
                                                width: 2,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    ]
                  )
                )
              ],
            ),
            const SizedBox(height: 32),
            const Center(child: Text("Profile Page Context Placeholder"))  
          ],
        )
      )
    );
  }
}
