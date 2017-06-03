part of WebGLUtils;

class InputController {
  CanvasElement canvas;
  bool ownMouse = false;
  MouseSphereCameraController controller = new MouseSphereCameraController();
  Camera cam;
  
  InputController(CanvasElement canvas, Camera camera){
    this.canvas = canvas;
    this.cam = camera;
    inputBind();
  }
  
  bool get _fullScreened => canvas == document.fullscreenElement;

  void clicked(Event event) {
    canvas.requestPointerLock();
  }

  /* Returns true if the pointer is owned by our canvas element */
  bool get _pointerLocked => canvas == document.pointerLockElement;

  void pointerLockChange(Event event) {
    // Check if we own the mouse.
    ownMouse = _pointerLocked;
  }

  void toggleFullscreen() {
    if (_fullScreened) {
      document.cancelFullScreen();
    } else {
      canvas.requestFullscreen();
    }
  }
  
  void fullscreenChange(Event event) {
    canvas.width = canvas.parent.client.width;
    canvas.height = canvas.parent.client.height;
    cam.aspectRatio = canvas.width / canvas.height;
    cam.screenWidth = canvas.width;
    cam.screenHeight = canvas.height;
  }


  void keydown(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    var keyCode = event.keyCode;
    switch (keyCode) {
      case KeyCode.I:
        cam.rotateCamUp();
        break;
      case KeyCode.K:
        cam.rotateCamDown();
        break;
      case KeyCode.J:
        cam.rotateCamLeft();
        break;
      case KeyCode.L:
        cam.rotateCamRight();
        break;
      case KeyCode.W:
        cam.moveCamForward();
        break;
      case KeyCode.S:
        cam.moveCamBackward();
        break;
      case KeyCode.A:
        cam.moveCamLeft();
        break;
      case KeyCode.D:
        cam.moveCamRight();
        break;
      case KeyCode.F:
        toggleFullscreen();
        break;
    }
    
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
  }

  void mouseMove(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    controller.accumScroll += event.movement.y;
    event.preventDefault();
  }

  /*
  void mouseWheel(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    if (event is WheelEvent) {
      WheelEvent e = event;
      controller.mouseSensitivity = 720.0;
      controller.accumDX -= e.deltaX;
      controller.accumDY += e.deltaY;
    }
    event.preventDefault();
  }
  */

 
  // Bind input event callbacks
  void inputBind() {
    document.onPointerLockChange.listen(pointerLockChange);
    canvas.onClick.listen(clicked);
    document.onKeyDown.listen(keydown);
    document.onKeyUp.listen(keyup);
    document.onMouseMove.listen(mouseMove);
    //window.onMouseWheel.listen(mouseWheel);
    document.onFullscreenChange.listen(fullscreenChange);
  }
  
}