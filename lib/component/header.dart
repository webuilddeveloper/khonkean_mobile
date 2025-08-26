import 'package:flutter/material.dart';

PreferredSizeWidget header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonLeft = true,
  bool isButtonRight = false,
  String imageRightButton = 'assets/images/task_list.png',
  Function? rightButton,
  String menu = '',
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10), // ความสูง space
        child: SizedBox(), // ว่างเปล่า
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      titleSpacing: 5,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),

      leading: isButtonLeft
          ? Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: InkWell(
                onTap: () => functionGoBack(),
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(1.0),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            )
          : null,

      // Right Button (Optional)
      actions: [
        if (isButtonRight)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
            child: InkWell(
              onTap: () => rightButton?.call(),
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 42.0,
                height: 42.0,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(
                  imageRightButton,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
