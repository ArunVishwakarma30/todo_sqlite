import 'package:flutter/cupertino.dart';
import 'package:todo_sqlite/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  final String label;
  final VoidCallback onTap;

// or we cab use this onTap this way as well
// final Function()? onTap

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: primaryClr),
        child: Center(
            child: Text(
          textAlign: TextAlign.center,
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: whiteClr),
        )),
      ),
    );
  }
}
