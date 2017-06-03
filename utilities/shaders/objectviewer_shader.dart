part of WebGLUtils;

class ObjectViewerShader extends Shader{
  WebGL.UniformLocation mvUniformLocation;
  WebGL.UniformLocation pUniformLocation;
  Float32List _mvUniform;
  Float32List _pUniform;
  WebGL.RenderingContext gl;

  ObjectViewerShader(WebGL.RenderingContext gl) : super(gl){
    this.gl = gl;
    super.vertexShaderSource=_vertexShader;
    super.fragmentShaderSource=_fragmentShader;
  }


final String _vertexShader = '''
   attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying lowp vec4 vColor;

    void main(void) {
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    vColor = aVertexColor;
    }
''';

final String _fragmentShader = '''
    varying lowp vec4 vColor;
      
      void main(void) {
        gl_FragColor = vColor;
      }
''';
}