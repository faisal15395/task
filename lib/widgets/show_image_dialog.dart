import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task/services/db_helper.dart';

void showImageDialog(BuildContext context, ImageProviderModel model,
    [Map<String, dynamic>? image]) {
  final nameController = TextEditingController(text: image?['name']);
  final typeController = TextEditingController(text: image?['type']);
  final picker = ImagePicker();
  File? selectedImage;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(image == null ? 'Add Image' : 'Update Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  selectedImage = File(pickedFile.path);
                }
              },
              child: const Text('Select Image'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  typeController.text.isNotEmpty) {
                final date = DateTime.now().toIso8601String();
                if (image == null && selectedImage != null) {
                  final directory = await getApplicationDocumentsDirectory();
                  final path =
                      join(directory.path, basename(selectedImage!.path));
                  await selectedImage!.copy(path);

                  model.addImage({
                    'name': nameController.text,
                    'type': typeController.text,
                    'date': date,
                    'path': path,
                  });
                } else if (image != null) {
                  model.updateImage(image['id'], {
                    'name': nameController.text,
                    'type': typeController.text,
                    'date': date,
                    'path': image['path'],
                  });
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
