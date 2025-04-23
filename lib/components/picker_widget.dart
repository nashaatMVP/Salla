import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerr extends StatelessWidget {
  const ImagePickerr({super.key, this.pickedImage, required this.function});

  final XFile? pickedImage;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.green.shade600, width: 4),
              borderRadius: BorderRadius.circular(200),
            ),
            child: pickedImage == null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade200, width: 4),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  )
                : Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(200),
                   ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(pickedImage!.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                ),
          ),
        ),
        Positioned(
          bottom: 20,
          top: 20,
          right: 20,
          left: 20,
          child: InkWell(
            onTap: () => function(),
            child: const Icon(
              size: 20,
              Icons.upload,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
