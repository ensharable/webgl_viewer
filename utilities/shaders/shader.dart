// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of WebGLUtils;

class Shader {
  String vertexShaderSource;
  String fragmentShaderSource;
  WebGL.Shader vertexShader;
  WebGL.Shader fragmentShader;
  WebGL.Program program;
  WebGL.RenderingContext gl;
  
  WebGL.UniformLocation mvUniformLocation;
  WebGL.UniformLocation pUniformLocation;
  WebGL.UniformLocation nUniformLocation;
  Float32List _mvUniform; //for model view matrix
  Float32List _pUniform; //for projection matrix
  Float32List _nUniform; //for normal matrix
  
  Shader(WebGL.RenderingContext gl){
    this.gl = gl;
    _mvUniform = new Float32List(16);
    _pUniform = new Float32List(16);
    _nUniform = new Float32List(16);
  }

  void compile() {
    vertexShader = gl.createShader(WebGL.RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);
    // Print compile log
    print(gl.getShaderInfoLog(vertexShader));

    fragmentShader = gl.createShader(WebGL.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);
    // Print compile log
    print(gl.getShaderInfoLog(fragmentShader));
  }

  void link() {
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    
    if (!gl.getProgramParameter(program, WebGL.LINK_STATUS)) {
      print('Unable to initialize the shader program.');
    }
    
    print(gl.getProgramInfoLog(program));
    
    dumpUniforms();
    dumpAttributes();
  }

  void dumpUniforms() {
    final int numUniforms = gl.getProgramParameter(program,
                                 WebGL.RenderingContext.ACTIVE_UNIFORMS);
    printLog('Dumping active uniforms:');
    for (var i = 0; i < numUniforms; i++) {
      var uniform = gl.getActiveUniform(program, i);
      printLog('[$i] - ${uniform.name}');
    }
  }

  void dumpAttributes() {
    final int numAttributes = gl.getProgramParameter(program,
                                WebGL.RenderingContext.ACTIVE_ATTRIBUTES);
    printLog('Dumping active attributes:');
    for (var i = 0; i < numAttributes; i++) {
      var attribute = gl.getActiveAttrib(program, i);
      printLog('[$i] - ${attribute.name}');
    }
  }
  
  void prepare() {
    compile();
    link();
    mvUniformLocation  = gl.getUniformLocation(program, 'uMVMatrix');
    pUniformLocation = gl.getUniformLocation(program, 'uPMatrix');
    nUniformLocation = gl.getUniformLocation(program, 'uNMatrix');
  }

  void enable() {
    gl.useProgram(program);
  }

  set mvUniform(Matrix4 m) {
    m.copyIntoArray(_mvUniform);
    gl.uniformMatrix4fv(mvUniformLocation, false, _mvUniform);
  }

  set pUniform(Matrix4 m) {
    m.copyIntoArray(_pUniform);
    gl.uniformMatrix4fv(pUniformLocation, false, _pUniform);
  }
  
  set nUniform(Matrix4 m) {
      m.copyIntoArray(_nUniform);
      gl.uniformMatrix4fv(nUniformLocation, false, _nUniform);
    }
}
