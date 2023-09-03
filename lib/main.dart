import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flutter/material.dart' hide Viewport;

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with CameraHelper {
  @override
  Future<void> onLoad() async {
    // oldOnLoad();
    newOnLoad();
    return super.onLoad();
  }

  Future<void> oldOnLoad() async {
    camera.viewport = FixedResolutionViewport(Vector2.all(100));
    await add(_makeRect());
  }

  Future<void> newOnLoad() async {
    final world = await createCamera(Vector2.all(100));
    await world.add(_makeBg());
    await world.add(_makeRect());
  }

  _Rect _makeBg() {
    return _Rect(
      position: size / 2,
      size: size,
      color: const Color(0xFFCCCCCC),
    );
  }

  _Rect _makeRect() {
    return _Rect(
      position: Vector2.all(50),
      size: Vector2.all(10),
    );
  }
}

class _Rect extends PositionComponent with HasGameRef<MyGame> {
  final Paint _paint;

  _Rect({
    required Vector2 position,
    required Vector2 size,
    Color color = const Color(0xFF00FF00),
  })  : _paint = Paint()..color = color,
        super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}

mixin CameraHelper on FlameGame {
  late final Viewfinder viewfinder;

  @override
  Vector2 get size => viewfinder.visibleGameSize!;

  Future<World> createCamera(Vector2 size) async {
    final world = World();
    final camera = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
      world: world,
    );
    camera.viewfinder.anchor = Anchor.center;
    camera.viewport.anchor = Anchor.center;
    camera.moveBy(size / 2);
    viewfinder = camera.viewfinder;
    await addAll([camera, world]);
    return world;
  }
}
