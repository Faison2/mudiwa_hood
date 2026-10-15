import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'root_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// One-shot intro timeline (crest, rings, shimmer, tagline, progress).
  late final AnimationController _intro;

  /// Endless ambient loop (ripples, arc rotation, glow breathing).
  late final AnimationController _loop;

  late final Animation<double> _glow;
  late final Animation<double> _crestFade;
  late final Animation<double> _crestScale;
  late final Animation<double> _ringFade;
  late final Animation<double> _shimmer;
  late final Animation<double> _footerFade;
  late final Animation<double> _progress;

  static const _words = ['PROVOKE', 'INSPIRE', 'MOTIVATE'];

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _glow = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _crestFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.05, 0.4, curve: Curves.easeOut),
    );
    _crestScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _ringFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
    );
    _shimmer = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.5, 0.85, curve: Curves.easeInOut),
    );
    _footerFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    );
    _progress = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    );

    _intro.forward().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 250), _goNext);
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 750),
        pageBuilder: (_, __, ___) => const RootShell(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  /// Staggered 0..1 value for each tagline word.
  double _wordValue(int i) {
    const start = 0.45;
    const stagger = 0.08;
    const length = 0.22;
    final t = ((_intro.value - (start + i * stagger)) / length).clamp(0.0, 1.0);
    return Curves.easeOut.transform(t);
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset('assets/images/splash_logo.png', width: 150);

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: AnimatedBuilder(
        animation: Listenable.merge([_intro, _loop]),
        builder: (context, _) {
          final loopT = _loop.value;
          final breathe = 1 + 0.06 * math.sin(loopT * 2 * math.pi);

          return Stack(
            children: [
              // Base gradient.
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: AppColors.inkGradient),
                ),
              ),

              // Breathing gold glow behind the crest.
              Align(
                alignment: const Alignment(0, -0.12),
                child: Opacity(
                  opacity: _glow.value,
                  child: Transform.scale(
                    scale: breathe,
                    child: Container(
                      width: 440,
                      height: 440,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.gold.withValues(alpha: 0.24),
                            AppColors.gold.withValues(alpha: 0.06),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Vignette to focus the eye on the centre.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 1.1,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                        stops: const [0.55, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Crest with ripples, orbiting arc and shimmer.
              Align(
                alignment: const Alignment(0, -0.12),
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: _ringFade.value,
                        child: CustomPaint(
                          size: const Size(320, 320),
                          painter: _RipplePainter(
                            t: loopT,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _ringFade.value,
                        child: Transform.rotate(
                          angle: loopT * 2 * math.pi,
                          child: const CustomPaint(
                            size: Size(240, 240),
                            painter: _OrbitArcPainter(color: AppColors.gold),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _crestFade.value,
                        child: Transform.scale(
                          scale: _crestScale.value,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.08),
                                  Colors.white.withValues(alpha: 0.02),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.18),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (rect) {
                                // Sweeps a soft highlight left → right once.
                                final dx = -1.6 + 3.2 * _shimmer.value;
                                return LinearGradient(
                                  begin: Alignment(dx - 0.6, -0.4),
                                  end: Alignment(dx + 0.6, 0.4),
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.55),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.35, 0.5, 0.65],
                                ).createShader(rect);
                              },
                              child: logo,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tagline + progress.
              Positioned(
                bottom: 64,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _footerFade.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < _words.length; i++) ...[
                            if (i > 0) const _Separator(),
                            Opacity(
                              opacity: _wordValue(i),
                              child: Transform.translate(
                                offset: Offset(0, 10 * (1 - _wordValue(i))),
                                child: Text(
                                  _words[i],
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 11,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 22),
                      _GlowProgressBar(value: _progress.value),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: 4,
          height: 4,
          color: AppColors.gold.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _GlowProgressBar extends StatelessWidget {
  const _GlowProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 2.4,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.4),
                    AppColors.gold,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three thin rings expanding outward from the crest and fading away.
class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const innerR = 108.0;
    final maxR = size.width / 2;

    for (var i = 0; i < 3; i++) {
      final p = (t + i / 3) % 1.0;
      final radius = innerR + (maxR - innerR) * p;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: (1 - p) * 0.3);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.t != t || old.color != color;
}

/// A faint ring with a comet-like gold arc and a glowing head.
class _OrbitArcPainter extends CustomPainter {
  const _OrbitArcPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2 - 2;
    final rect = Rect.fromCircle(center: center, radius: r);

    // Faint full ring.
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.1),
    );

    // Comet tail.
    const headFraction = 0.3;
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.9),
            Colors.transparent,
          ],
          stops: const [0.0, headFraction, headFraction + 0.001],
        ).createShader(rect),
    );

    // Glowing head.
    const a = headFraction * 2 * math.pi;
    final head = Offset(center.dx + r * math.cos(a), center.dy + r * math.sin(a));
    canvas.drawCircle(
      head,
      5,
      Paint()
        ..color = color.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(head, 2.2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_OrbitArcPainter old) => old.color != color;
}