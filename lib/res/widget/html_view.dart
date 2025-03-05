import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:web_horizon/res/theme.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        HtmlWidget(
          html,
          textStyle: const TextStyle(
            color: blackColor,
          ),
        ),
      ],
    );
  }
}
