import 'package:flutter/material.dart';
import 'package:listie/theme.dart';

class EmptyListIndicator extends StatelessWidget {
  final String title;
  final String? buttonText;
  final IconData buttonIcon;
  final Function? onButtonPressed;

  const EmptyListIndicator({
    Key? key,
    required this.title,
    this.buttonText,
    this.buttonIcon = Icons.add,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasButton = this.buttonText != null && this.onButtonPressed != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info,
          color: ThemeColors.primary,
          size: 38,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            this.title,
            style: ThemeText.heading6,
          ),
        ),
        if (hasButton)
          ElevatedButton.icon(
            onPressed: () {
              this.onButtonPressed!();
            },
            icon: Icon(this.buttonIcon),
            label: Text(this.buttonText!),
          )
      ],
    );
  }
}
