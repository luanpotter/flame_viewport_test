import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // old way
    camera.viewport = FixedResolutionViewport(Vector2.all(100));
    await add(
      _Rect(
        position: Vector2.all(50),
        size: Vector2.all(10),
      ),
    );
    return super.onLoad();
  }
}

class _Rect extends PositionComponent with HasGameRef<MyGame> {
  static final _paint = Paint()..color = const Color(0xFF00FF00);

  _Rect({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}