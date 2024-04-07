import 'package:flutter/material.dart';

class SpriteComponent extends StatelessWidget {

  final String? asset;
  final Size imgSize;

  final bool flipX;
  final bool debug;

  final ImageRepeat repeat;
  final Alignment alignment;
  final BoxFit fit;

  const SpriteComponent({
    super.key,
    required this.imgSize,
    this.asset,
    this.flipX = false,
    this.debug = false,
    this.alignment = Alignment.bottomCenter,
    this.repeat = ImageRepeat.noRepeat,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    Container? debugBox;

    if (debug) {
      debugBox = Container(
        width: imgSize.width,
        height: imgSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Colors.white
          )
        ),
      );
    }

    Widget? child = Container(
      width: imgSize.width,
      height: imgSize.height,
      alignment: alignment,
      decoration: BoxDecoration(
        image: asset == null ? null : DecorationImage(
          fit: fit,
          repeat: repeat,
          alignment: alignment,
          image: AssetImage(asset!),
        )
      ),
      child: debugBox,
    );

    return Transform.flip(
      flipX: flipX,
      child: child,
    );
  }
}