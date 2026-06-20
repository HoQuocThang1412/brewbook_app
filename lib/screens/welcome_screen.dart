import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final Widget nextScreen;

  const WelcomeScreen({super.key, required this.nextScreen});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(_fade);

    _controller.forward();
    _timer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => widget.nextScreen,
          transitionDuration: const Duration(milliseconds: 420),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EA),
      body: Stack(
        children: [
          const _BackgroundDecoration(),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: ScaleTransition(
                    scale: _scale,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CoffeeHero(),
                          SizedBox(height: 30),
                          Text(
                            'BrewBook',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3B2B23),
                              letterSpacing: -0.6,
                              height: 1.05,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ứng dụng quản lý công thức & vận hành quán',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A6A5F),
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Designed & built by HoQuThang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9A7B4F),
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 34),
                          _LoadingBar(),
                          SizedBox(height: 16),
                          Text(
                            'Đang khởi động hệ thống...',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF9B8A7F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0E2CF).withOpacity(0.65),
            ),
          ),
        ),
        Positioned(
          bottom: -90,
          left: -50,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEAD5BC).withOpacity(0.55),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: 24,
          child: Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.white.withOpacity(0.38),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 160,
          right: 28,
          child: Transform.rotate(
            angle: 0.25,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF3E7D7).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoffeeHero extends StatelessWidget {
  const _CoffeeHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFFCF8),
                  Color(0xFFF0E3D3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F8B5E34),
                  blurRadius: 36,
                  offset: Offset(0, 20),
                ),
              ],
            ),
          ),
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8D9C8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                _SteamLine(left: 38, delay: 0),
                _SteamLine(left: 58, delay: 0.2),
                _SteamLine(left: 78, delay: 0.4),
                Positioned(
                  bottom: 26,
                  child: Icon(
                    Icons.local_cafe_rounded,
                    size: 54,
                    color: Color(0xFF8B5E34),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DED0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.78,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB88A52),
                  Color(0xFF8B5E34),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SteamLine extends StatefulWidget {
  final double left;
  final double delay;

  const _SteamLine({required this.left, required this.delay});

  @override
  State<_SteamLine> createState() => _SteamLineState();
}

class _SteamLineState extends State<_SteamLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: 18,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = (_controller.value + widget.delay) % 1;
          final opacity = (1 - value).clamp(0.0, 1.0);
          final dy = 10 + (value * 18);
          final scale = 0.8 + (value * 0.45);

          return Transform.translate(
            offset: Offset(math.sin(value * math.pi) * 4, -dy),
            child: Opacity(
              opacity: opacity * 0.55,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: const Color(0xFFDAB892),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
