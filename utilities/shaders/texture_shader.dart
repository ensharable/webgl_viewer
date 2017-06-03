part of WebGLUtils;

class TextureShader {
  Shader shader;
  WebGL.Program get program => shader.program;
  WebGL.RenderingContext gl;
  WebGL.UniformLocation mvUniformLocation;
  WebGL.UniformLocation pUniformLocation;
  Float32List _mvUniform;
  Float32List _pUniform;

  TextureShader(WebGL.RenderingContext gl) {
    this.gl = gl;
    shader = new Shader(_vertexShader, _fragmentShader);
    _mvUniform = new Float32List(16);
    _pUniform = new Float32List(16);
  }

  void prepare() {
    shader.compile(gl);
    shader.link(gl);
    mvUniformLocation  = gl.getUniformLocation(program, 'uMVMatrix');
    pUniformLocation = gl.getUniformLocation(program, 'uPMatrix');
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

  

final String _vertexShader = '''
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;
  
    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;
    
    varying highp vec2 vTextureCoord;
  
    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
    }
''';

final String _fragmentShader = '''
   varying highp vec2 vTextureCoord;
      
   uniform sampler2D uSampler;
      
   void main(void) {
     gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
    }
''';
}