import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/Authentication/my_profile.dart';
import 'package:edirnebenim/Image/compress.dart';
import 'package:edirnebenim/Image/xfile2image.dart';
import 'package:edirnebenim/Service/firebase_storage_service.dart';
import 'package:edirnebenim/Trade/models/trade_model.dart';
import 'package:edirnebenim/Trade/values/trade_regions.dart';
import 'package:edirnebenim/Values/my_user.dart';
import 'package:edirnebenim/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({
    required this.tradeModel,
    super.key,
  });
  final TradeModel tradeModel;
  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  List<Image?> images = [];
  List<File> imagesFiles = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.tradePrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Iconsax.arrow_left_2,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          'Fotoğraf ekle',
          style: AppConfig.font.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Yeni Fotoğraf',
          style: AppConfig.font.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          final picker = ImagePicker();

          final image = await picker.pickImage(source: ImageSource.camera);

          if (image != null) {
            final croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              uiSettings: [
                AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: Colors.deepOrange,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false,
                ),
                IOSUiSettings(
                  title: 'Cropper',
                ),
              ],
            );
            /*
            final imagefile =
                image == null ? null : Image(image: await xFileToImage(image));
            */
            if (croppedFile != null) {
              final path = croppedFile.path;
              imagesFiles.add(File(image.path));
              images.add(Image.file(File(path)));
            }

            setState(() {});
          }
        },
        icon: const Icon(Icons.add_a_photo_outlined),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 18,
          left: 18,
          right: 18,
        ),
        child: InkWell(
          onTap: AuthService().authorizedControl(context, function: () async {
            if (images.isNotEmpty) {
              final ref = FirebaseFirestore.instance.collection('trades').doc();
              isLoading.value = true;
              for (final image in imagesFiles) {
                final compressedImage = await compressFile(image);
                final imageURL = await FirebaseStorageService().uploadFile(
                  ref.id,
                  image.path,
                  compressedImage,
                );
                print(imageURL);
                if (widget.tradeModel.photos == null) {
                  widget.tradeModel.photos = [imageURL!];
                } else {
                  widget.tradeModel.photos!.add(imageURL!);
                }
                print(widget.tradeModel.photos);
              }
              widget.tradeModel
                ..createdAt = Timestamp.now()
                ..docID = ref.id
                ..uid = AuthService.user?.uid;
              await ref.set(widget.tradeModel.toJson()).then((value) {
                isLoading.value = false;
              });

              print(widget.tradeModel.photos);
            }
          }),
          borderRadius: BorderRadius.circular(99),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppConfig.tradePrimaryColor,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hemen ilan ver',
                  style: AppConfig.font.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: List.generate(
                images.length,
                (index) => Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: images[index],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        images.removeAt(index);
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: AppConfig.tradePrimaryColor.withOpacity(.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
