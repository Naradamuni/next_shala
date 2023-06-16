import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10),
          child: Text(title,
              style: GoogleFonts.montserrat(
                  color: textColor, fontWeight: FontWeight.w700, fontSize: 18),
              textAlign: TextAlign.left),
        ),
        inputWidget,
      ],
    );
  }
}
