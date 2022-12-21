import 'package:flutter/material.dart';
import './logo_image_part.dart';
Widget logoPart(){
  return Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: Container(
              width: 200,
              height: 150,
              child: logoImagePart()
          ),
        ),
      );
}
