import 'package:flutter/material.dart';
import 'package:web_horizon/res/theme.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: const [
            Icon(
              Icons.sentiment_dissatisfied,
              size: 30.0,
              color: greyColor,
            ),
            heightSpace,
            heightSpace,
            Text(
              "Something went wrong",
              style: semibold18Grey,
            )
          ],
        ),
      ),
    );
  }
}
