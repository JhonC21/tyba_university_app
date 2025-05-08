import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';
import 'package:tyba_university_app/feature/university/presentation/bloc/university_bloc.dart';
import 'package:tyba_university_app/shared/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

// Class for university detail
class UniversityDetailPage extends StatelessWidget {
  const UniversityDetailPage({required this.university, super.key});

  static const String path = '/university-detail';
  static const String routeName = 'university-detail';

  final University university;

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(title: Text(university.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.dp(2)),
        child: Column(
          children: [
            _ImageSection(university: university),
            SizedBox(height: responsive.dp(2)),
            _StudentCountSection(university: university),
            SizedBox(height: responsive.dp(2)),
            Text('Country: ${university.country}',
                style: Theme.of(context).textTheme.titleMedium),
            if (university.stateProvince != null)
              Text('State/Province: ${university.stateProvince}',
                  style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: responsive.dp(2)),
            Text('Domains:', style: Theme.of(context).textTheme.titleMedium),
            ...university.domains.map((domain) => Text('- $domain')),
            SizedBox(height: responsive.dp(2)),
            Text('Web Pages:', style: Theme.of(context).textTheme.titleMedium),
            ...university.webPages.map(
              (webPage) => InkWell(
                onTap: () => launchUrl(Uri.parse(webPage)),
                child:
                    Text(webPage, style: const TextStyle(color: Colors.blue)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final University university;

  const _ImageSection({required this.university});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniversityBloc, UniversityState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: university.imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        university.imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.school, size: 60, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onPressed: () => _pickImage(ImageSource.gallery, context),
                ),
                const SizedBox(width: 16),
                _buildImageButton(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: () => _pickImage(ImageSource.camera, context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        context
            .read<UniversityBloc>()
            .add(UniversityEvent.updateUniversityImage(
              universityName: university.name,
              imageFile: File(pickedFile.path),
            ));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class _StudentCountSection extends StatelessWidget {
  final University university;

  const _StudentCountSection({required this.university});

  @override
  Widget build(BuildContext context) {
    Timer? _debouncer;

    return BlocBuilder<UniversityBloc, UniversityState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Count:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: university.studentCount?.toString() ?? '',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter student count',
                errorMaxLines: 3,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                final number = int.tryParse(value);
                if (number == null) return 'Enter a valid number';
                if (number < 0) return 'Enter a positive number';
                return null;
              },
              onChanged: (value) {
                _debouncer?.cancel();
                _debouncer = Timer(const Duration(milliseconds: 500), () {
                  final number = int.tryParse(value);
                  context.read<UniversityBloc>().add(
                        UniversityEvent.updateStudentCount(
                          universityName: university.name,
                          studentCount: number,
                        ),
                      );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
