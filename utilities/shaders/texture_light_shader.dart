part of WebGLUtils;

class TextureLightShader {
  Shader shader;
  WebGL.Program get program => shader.program;
  WebGL.RenderingContext gl;
  WebGL.UniformLocation mvUniformLocation;
  WebGL.UniformLocation pUniformLocation;
  WebGL.UniformLocation normalUniformLocation;
  Float32List _mvUniform;
  Float32List _pUniform;
  Float32List _normalUniform;

  TextureLightShader(WebGL.RenderingContext gl) {
    this.gl = gl;
    shader = new Shader(_vertexShader, _fragmentShader);
    _mvUniform = new Float32List(16);
    _pUniform = new Float32List(16);
    _normalUniform = new Float32List(16);
  }

  void prepare() {
    shader.compile(gl);
    shader.link(gl);
    mvUniformLocation  = gl.getUniformLocation(program, 'uMVMatrix');
    pUniformLocation = gl.getUniformLocation(program, 'uPMatrix');
    normalUniformLocation = gl.getUniformLocation(program, 'uNormalMatrix');
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
  
  set normalUniform(Matrix4 m) {
    m.copyIntoArray(_normalUniform);
    gl.uniformMatrix4fv(normalUniformLocation, false, _normalUniform);
  }

final String _vertexShader = '''
    attribute highp vec3 aVertexNormal;
    attribute highp vec3 aVertexPosition;
    attribute highp vec2 aTextureCoord;
    
    uniform highp mat4 uNormalMatrix;
    uniform highp mat4 uMVMatrix;
    uniform highp mat4 uPMatrix;
    
    varying highp vec2 vTextureCoord;
    varying highp vec3 vLighting;
    
    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
      
      // Apply lighting effect
      
      highp vec3 ambientLight = vec3(0.6, 0.6, 0.6);
      highp vec3 directionalLightColor = vec3(0.5, 0.5, 0.75);
      highp vec3 directionalVector = vec3(0.85, 0.8, 0.75);
      
      highp vec4 transformedNormal = uNormalMatrix * vec4(aVertexNormal, 1.0);
      
      highp float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
      vLighting = ambientLight + (directionalLightColor * directional);
    }
''';

final String _fragmentShader = '''
    varying highp vec2 vTextureCoord;
    varying highp vec3 vLighting;
    
    uniform sampler2D uSampler;
    
    void main(void) {
      highp vec4 texelColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
      
      gl_FragColor = vec4(texelColor.rgb * vLighting, texelColor.a);
    }
''';
}