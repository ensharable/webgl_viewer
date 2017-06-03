// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of WebGLUtils;

class Camera {
  Vector3 eyePosition;
  Vector3 upDirection;
  Vector3 lookAtPosition;
  Vector3 lookAtDirection;
  double zNear;
  double zFar;
  double aspectRatio;
  double fOV;
  int screenWidth;
  int screenHeight;
  
  var speed = 0.1; 
  Matrix2 counterClockWiseM = new Matrix2(0.0, 1.0, -1.0, 0.0);
  Matrix2 clockWiseM = new Matrix2(0.0, -1.0, 1.0, 0.0);

  Camera() {
    eyePosition = new Vector3(0.0, 0.0, 0.0);
    lookAtPosition = new Vector3(0.0, 0.0, -1.0);
    upDirection = new Vector3(0.0, 1.0, 0.0);
    lookAtDirection = new Vector3(0.0, 0.0, -1.0);
    
    // Note: this was originally set to 0.785398163 (90 degrees).  Different
    // settings of fOV produce different visual results. Neither number is
    // incorrect.
    fOV = 45.0;
    zNear = 0.1;
    zFar = 100.0;
    aspectRatio = 1.0;
  }

  String toString() {
    return '$eyePosition -> $lookAtPosition';
  }

  double get yaw {
    var z = new Vector3(0.0, 0.0, 1.0);
    var forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(z)));
  }

  double get pitch {
    var y = new Vector3(0.0, 1.0, 0.0);
    var forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(y)));
  }

  Matrix4 get projectionMatrix {
    return makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
  }

  Matrix4 get lookAtMatrix {
    return makeViewMatrix(eyePosition, lookAtPosition, upDirection);
  }
  
  Matrix4 get lookAtMatrixWithDirection {
    return makeViewMatrixWithDirection(eyePosition, lookAtDirection, upDirection);
  }
  
  
  
  void copyProjectionMatrixIntoArray(Float32List pm) {
    var m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
    m.copyIntoArray(pm);
  }

  void copyViewMatrixIntoArray(Float32List vm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(vm);
  }

  void copyNormalMatrixIntoArray(Float32List nm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(nm);
  }

  void copyProjectionMatrix(Matrix4 pm) {
    var m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
    m.copyInto(pm);
  }

  void copyViewMatrix(Matrix4 vm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyInto(vm);
  }

  void copyNormalMatrix(Matrix4 nm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyInto(nm);
  }

  void copyEyePosition(Vector3 ep) {
    eyePosition.copyInto(ep);
  }

  void copyLookAtPosition(Vector3 lap) {
    lookAtPosition.copyInto(lap);
  }

  Vector3 get frontDirection => lookAtPosition - eyePosition;
  
  
  
  /*
   *  move the camera in the lookatdirection.
   */
  void moveCamForward(){
    Vector2 v = lookAtDirection.xz;
    v.normalize();
    eyePosition.x += v.x * speed;
    eyePosition.z += v.y * speed;
  }
  
  void moveCamBackward(){
    Vector2 v = lookAtDirection.xz;
    v.normalize();
    eyePosition.x -= v.x * speed;
    eyePosition.z -= v.y * speed;
  }
  
  /**
   * http://mathworld.wolfram.com/PerpendicularVector.html
   */
  void moveCamRight(){
    Vector2 v = lookAtDirection.xz;
    v.normalize();
    v.postmultiply(counterClockWiseM);
    eyePosition.x -= v.x * speed;
    eyePosition.z -= v.y * speed;
  }
  void moveCamLeft(){
    Vector2 v = lookAtDirection.xz;
    v.normalize();
    v.postmultiply(clockWiseM);
    eyePosition.x -= v.x * speed;
    eyePosition.z -= v.y * speed;
  }
  
  
  void rotateCamUp(){
    //find the camera axis
    Vector3 temp = lookAtDirection.cross(upDirection);
    Matrix4 m = new Matrix4.identity();
    m.rotate(temp, -0.01);
    lookAtDirection.postmultiply(m.getRotation());
  }
  void rotateCamDown(){
    Vector3 temp = lookAtDirection.cross(upDirection);
    Matrix4 m = new Matrix4.identity();
    m.rotate(temp, 0.01);
    lookAtDirection.postmultiply(m.getRotation());
  }
  void rotateCamLeft(){
    Matrix4 m = new Matrix4.identity();
    m.rotate(upDirection, -0.01);
    lookAtDirection.postmultiply(m.getRotation());
  }
  void rotateCamRight(){
    Matrix4 m = new Matrix4.identity();
    m.rotate(upDirection, 0.01);
    lookAtDirection.postmultiply(m.getRotation());
  }
}
