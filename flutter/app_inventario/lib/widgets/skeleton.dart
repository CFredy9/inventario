import 'package:flutter/material.dart';

import '../../constants.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      //enabled: _enabled,
      period: const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      loop: 0,
      child: Container(
        height: height,
        width: width,
        //color: Colors.grey,
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
            //color: Colors.grey,
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultPadding))),
      ));
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
