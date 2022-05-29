part of 'main.dart';

class WindowButtons extends StatelessWidget {
  WindowButtons({Key? key}) : super(key: key);
  final col =
      WindowButtonColors(iconNormal: Colors.white, mouseOver: Colors.black54);
  final colex = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Colors.red,
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: col,
        ),
        MaximizeWindowButton(
          colors: col,
        ),
        CloseWindowButton(
          colors: colex,
        ),
      ],
    );
  }
}

class CustomWindow extends StatelessWidget {
  final Widget child;
  const CustomWindow({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WindowTitleBarBox(
            child: Container(
          // color: Colors.blue,
          decoration: BoxDecoration(
            // borderRadius:
            //     BorderRadius.only(topLeft: Radius.circular(18.0)),
            gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.grey.shade900,
                  Colors.grey.shade900,
                ],
                // stops: [],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child:
              Row(children: [Expanded(child: MoveWindow()), WindowButtons()]),
        )),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
