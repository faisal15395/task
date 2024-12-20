import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/services/db_helper.dart';
import 'package:task/widgets/show_image_dialog.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title:
            const Text('Image Gallery', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Images',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Provider.of<ImageProviderModel>(context, listen: false)
                        .searchImages(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ImageProviderModel>(
              builder: (context, model, child) {
                return ListView.builder(
                  itemCount: model.images.length,
                  itemBuilder: (context, index) {
                    final image = model.images[index];
                    return ListTile(
                      leading: Image.file(File(image['path'])),
                      title: Text(image['name']),
                      subtitle: Text('${image['type']} - ${image['date']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showImageDialog(context, model, image);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              model.deleteImage(image['id']);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showImageDialog(context,
                  Provider.of<ImageProviderModel>(context, listen: false));
            },
            child: const Text('Add Image'),
          ),
        ],
      ),
    );
  }
}
