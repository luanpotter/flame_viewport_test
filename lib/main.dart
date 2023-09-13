import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' hide Viewport;
import 'package:flame_viewport_test/util.dart';
import 'package:flutter/material.dart' hide Viewport;
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with CameraHelper, KeyboardEvents {
  final Vector2 move = Vector2.zero();
  late final _Rect _player;

  @override
  Future<void> onLoad() async {
    await createCamera(Vector2.all(100));

    await world.add(_makeBg());

    await world.add(_player = _makeRect());

    // camera bug: cameraComponent.moveBy(size / 2);
    cameraComponent.follow(_player);

    await world.add(_makeRect(Vector2.all(10)));
    await world.add(_makeRect(Vector2(20, 70)));
    await world.add(_makeRect(Vector2(80, 80)));
  }

  _Rect _makeBg() {
    return _Rect(
      position: size / 2,
      size: size,
      color: const Color(0xFFCCCCCC),
    );
  }

  _Rect _makeRect([
    Vector2? position,
  ]) {
    return _Rect(
      position: position ?? Vector2.all(50),
      size: Vector2.all(10),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _player.position.add(move * dt * 20);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    readArrowLikeKeysIntoVector2(
      event,
      keysPressed,
      move,
      up: LogicalKeyboardKey.keyW,
      down: LogicalKeyboardKey.keyS,
      left: LogicalKeyboardKey.keyA,
      right: LogicalKeyboardKey.keyD,
    );
    return KeyEventResult.handled;
  }
}

class _Rect extends PositionComponent with HasGameRef<MyGame>, TapCallbacks {
  final Paint _paint;

  _Rect({
    required Vector2 position,
    required Vector2 size,
    Color? color,
  })  : _paint = Paint()..color = color ?? _randomColor(),
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

  @override
  void onTapUp(TapUpEvent event) {
    _paint.color = _randomColor();
  }
}

final _r = Random();

Color _randomColor() {
  return Color.fromARGB(
    255,
    _r.nextInt(255),
    _r.nextInt(255),
    _r.nextInt(255),
  );
}

mixin CameraHelper on FlameGame {
  late final CameraComponent cameraComponent;
  late final World world;

  @override
  Vector2 get size => cameraComponent.viewfinder.visibleGameSize!;

  Future<void> createCamera(Vector2 size) async {
    world = World();
    cameraComponent = CameraComponent.withFixedResolution(
      width: size.x,
      height: size.y,
      world: world,
    );
    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.viewport.anchor = Anchor.center;
    await addAll([cameraComponent, world]);
  }
}
