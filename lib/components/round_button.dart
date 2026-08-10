import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  RoundButton({required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPress,
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.indigo,
                    Colors.indigoAccent,
              ])),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white , fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
