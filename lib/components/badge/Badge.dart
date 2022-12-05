import "package:flutter/material.dart";

class Badge extends StatelessWidget {
  final String value;
  final Widget child;
  final Color? color;

  const Badge({Key? key, required this.value, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 2,
          right: 3,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            height: 22,
            width: 22,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
