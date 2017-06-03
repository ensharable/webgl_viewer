part of WebGLUtils;

class ObjectViewerTextureLightShader extends Shader{
  WebGL.RenderingContext gl;
  
  ObjectViewerTextureLightShader(WebGL.RenderingContext gl) : super(gl) {
    this.gl = gl;
    super.vertexShaderSource=_vertexShader;
    super.fragmentShaderSource=_fragmentShader;
  }

//simple texture light shader:
// prdf shadering: http://www.mathematik.uni-marburg.de/~thormae/lectures/graphics1/code/WebGLShaderLightMat/ShaderLightMat.html 
  //Todo add texture
 
    final String _vertexShader = '''
        attribute highp vec3 aVertexPosition;
        attribute highp vec3 aVertexNormal;
        
        uniform highp mat4 uMVMatrix;
        uniform highp mat4 uPMatrix;
        uniform highp mat4 uNMatrix;

        uniform highp vec3 materialDiffuseColor;
        uniform highp vec3 materialAmbientColor;
        uniform highp vec3 lightPos; 
        uniform highp vec3 lightColor;
        uniform highp vec3 lightSpecColor;       
      
        varying highp vec3 vLighting;

        
        void main(void) {
          gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);

          // Apply lighting effect
          // all following gemetric computations are performed in the
          // camera coordinate system (aka eye coordinates)
          vec3 normal = vec3(uNMatrix * vec4(aVertexNormal, 0.0));
          vec4 vertPos4 = uMVMatrix * vec4(aVertexNormal, 1.0);
          vec3 vertPos = vec3(vertPos4) / vertPos4.w;

          vec3 lightDir = normalize(lightPos - vertPos);
          vec3 reflectDir = reflect(-lightDir, normal);
          vec3 viewDir = normalize(-vertPos);
     
          float lambertian = max(dot(lightDir,normal), 0.0);
          float specular = 0.0;
  
          if(lambertian > 0.0) {
            float specAngle = max(dot(reflectDir, viewDir), 0.0);
            specular = pow(specAngle, 4.0);
          }
          vLighting = lambertian*materialDiffuseColor + specular*lightSpecColor;

        }
    ''';

    final String _fragmentShader = '''
      varying highp vec3 vLighting;
      
      void main(void) {
        gl_FragColor = vec4(vLighting, 1.0);
      }
    ''';
}