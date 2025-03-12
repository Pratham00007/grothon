import 'package:flutter/material.dart';

class WishlistButton extends StatefulWidget {
  final bool isInWishlist;
  final Function(bool) onToggle;

  const WishlistButton({
    Key? key,
    required this.isInWishlist,
    required this.onToggle,
  }) : super(key: key);

  @override
  _WishlistButtonState createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: IconButton(
            icon: Icon(
              widget.isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: widget.isInWishlist ? Colors.red : Colors.grey,
              size: 28,
            ),
            onPressed: () {
              _animationController.forward();
              widget.onToggle(!widget.isInWishlist);
            },
          ),
        );
      },
    );
  }
}