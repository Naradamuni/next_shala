import 'package:flutter/widgets.dart';

/// The reuseable compenent to render title and input filed
class TitledInputFragment extends StatelessWidget {
  /// The constructor
  const TitledInputFragment(
      {Key? key,
      required this.title,
      required this.inputWidget,
      this.textColor = const Color(0xFF2a2a3a)})
      : super(key: key);

  /// The input widget
  final Widget inputWidget;

  /// The title text color
  final Color textColor;

  /// The title of the field
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontFamily: "Avenir",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            textAlign: TextAlign.left),
        const SizedBox(
          height: 12,
        ),
        inputWidget,
      ],
    );
  }
}
