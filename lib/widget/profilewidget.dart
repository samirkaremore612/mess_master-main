import 'package:flutter/material.dart';
import 'dart:io';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      this.isEdit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme.primary
    const color = Color.fromARGB(170,25, 55, 109);
    return Column(
      children: [
        SizedBox(height: 24),
        Center(
          child: Stack(
            children: [
              buildImage(),
              Positioned(
                bottom: 0,
                right: 4,
                child: buildEditIcon(color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    // final image = AssetImage(imagePath);

    final image = imagePath.contains('assets/')
        ? AssetImage(imagePath)
        : NetworkImage(imagePath);

    return ClipOval(
      child: Material(
          child: Ink.image(
            image: image as ImageProvider,
            width: 128,
            height: 128,
            child: InkWell(onTap: onClicked),
      )),
    );
  }

  Widget buildEditIcon(Color color) {
    return buildCircle(
      all: 3,
      color: Colors.white,
      child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          )),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
      ));
}
