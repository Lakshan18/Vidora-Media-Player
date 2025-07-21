import 'package:flutter/material.dart';

class WindowControlButton extends StatelessWidget {
  final IconData icon;
  final bool isHovered;
  final Function(bool) onHover;
  final VoidCallback onPressed;
  final bool isCloseButton;

  const WindowControlButton({
    Key? key,
    required this.icon,
    required this.isHovered,
    required this.onHover,
    required this.onPressed,
    this.isCloseButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 30,
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: isHovered
                ? isCloseButton
                    ? const Color(0xFF2D3F44)
                    : const Color(0xFF2D3F44)
                : Colors.transparent,
            child: Center(
              child: Icon(
                icon,
                size: 15,
                color: isHovered && isCloseButton
                    ? const Color(0xFF64929D)
                    : const Color(0xFF64929D),
              ),
            ),
          ),
        ),
      ),
    );
  }
}