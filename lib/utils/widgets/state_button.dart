import 'package:flutter/material.dart';

class StateButton extends StatelessWidget {

  final String text;
  final bool isLoading;
  final void Function()? onPressed;
  
  const StateButton({super.key, required this.text, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromHeight(54.0),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Text(isLoading ? 'Loading' : text),
      ),
    );
  }
}