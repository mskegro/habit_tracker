import 'package:flutter/material.dart';

class PurpleBackground extends StatelessWidget {
  final Widget child;
  
  const PurpleBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade400,
            Colors.purple.shade600,
            Colors.deepPurple.shade800,
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(
            painter: DecorativeLinesPainter(),
            child: Container(),
          ),

          child,
        ],
      ),
    );
  }
}

class DecorativeLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(size.width * i / 8, 0),
        Offset(0, size.height * i / 8),
        paint,
      );
    }

    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(size.width * (1 - i / 6), 0),
        Offset(size.width, size.height * i / 6),
        paint,
      );
    }

    final path1 = Path();
    path1.moveTo(0, size.height * 0.25);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.25,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.35,
      size.width,
      size.height * 0.25,
    );
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.5,
      size.height * 0.75,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.75,
    );
    canvas.drawPath(path2, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.2),
      60,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.4),
      80,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      50,
      paint,
    );

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 4;
    
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.1), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.9), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}