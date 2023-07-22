import 'package:flutter/material.dart';

///Component that sshows dot indicators
///Uses [DotFragment]
class DotIndicators extends StatelessWidget {
  ///The constructor
  const DotIndicators({
    Key? key,
    required this.length,
    required this.selectedIndex,
  }) : super(key: key);

  ///The max number of dots
  final int length;

  ///The selected index
  final int selectedIndex;

  ///Function to creeate and return a list of [DotFragments]
  List<Widget> _createDots() {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(DotFragment(
          isActive: i == selectedIndex,
          inactiveColor: const Color(0xff576475),
          activeColor: const Color(0xFFfafcfe),
          shadowColor: const Color(0xFF75cac2)));
    }
    return list;
  }

  ///Override build function
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _createDots(),
    );
  }
}

///A fragment that shows a single dot in selected and unselected states
///Supports styling in the for of color
///Dots are fixed size
class DotFragment extends StatelessWidget {
  ///Constructor
  const DotFragment(
      {Key? key,
      required this.isActive,
      required this.inactiveColor,
      required this.activeColor,
      required this.shadowColor})
      : super(key: key);

  ///The color of the dot in active state
  final Color activeColor;

  ///The color of the dot in inactive state
  final Color inactiveColor;

  ///The state
  final bool isActive;

  ///the color of ths shadow
  final Color shadowColor;

  ///build UI
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 3.0),
        height: isActive ? 4 : 3.0,
        width: isActive ? 6 : 4.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: shadowColor,
                    blurRadius: 1.0,
                    spreadRadius: 0.5,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}
