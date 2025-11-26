
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiService {
  static final ConfettiService _instance = ConfettiService._internal();
  
  ConfettiController? _confettiController;
  OverlayEntry? _overlayEntry;
  
  factory ConfettiService() {
    return _instance;
  }
  
  ConfettiService._internal();
  
  void playConfetti(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _confettiController?.dispose();
    }
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController!,
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
          gravity: 0.1,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
            Colors.red,
          ],
        ),
      ),
    );
    
    try {
      Overlay.of(context).insert(_overlayEntry!);
      _confettiController?.play();
    } catch (e) {
      print('Error playing confetti: $e');
    }
  }
  
  void dispose() {
    _confettiController?.dispose();
    _overlayEntry?.remove();
    _confettiController = null;
    _overlayEntry = null;
  }
}