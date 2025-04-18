import 'package:flutter/material.dart';

import '../../my_theme.dart';

class PosAddProductWidget extends StatelessWidget {
  final double? height;
  final VoidCallback? onTap;
  const PosAddProductWidget({
    super.key,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: MyTheme.app_accent_color_extra_light,
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFCFD9E1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 6.0),
            blurRadius: 20.0,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        // icon: Image.asset('assets/icon/big_plus.png'),
        icon: const Icon(Icons.add_circle_rounded,
        size: 80,
          color: MyTheme.app_accent_color,
        ),
      ),
    );
  }
}
