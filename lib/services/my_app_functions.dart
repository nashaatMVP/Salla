import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/text_widget.dart';

class MyAppFunctions {
  ////////////////////////////////   App Message  /////////////////////////////////////////////////////////////////////////////
  Future<void> globalMassage(
      {required context, required String message}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
    ));
  }

  /////////////////////////////////////////////  IMAGE PICKER   //////////////////////////////////////////////////////////////////

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 40,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ////////////////////////   Photo Library    /////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      galleryFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlesTextWidget(
                          label: "Photo Library",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        Icon(
                          Icons.my_library_add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.white,
                    endIndent: 0,
                    indent: 0,
                  ),

                  //////////////////////////////  Take Selfie Photo   /////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      cameraFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlesTextWidget(
                          label: "Take Selfie Photo",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    endIndent: 0,
                    indent: 0,
                  ),

                  ///////////////////////////////  Delete Photo   /////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      removeFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlesTextWidget(
                          label: "Delete Photo",
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        Icon(
                          CupertinoIcons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
