part of WebGLUtils;

class ObjectViewerLightShader extends Shader{
  WebGL.RenderingContext gl;
  
  ObjectViewerLightShader(WebGL.RenderingContext gl) : super(gl) {
    this.gl = gl;
    super.vertexShaderSource=_vertexShader;
    super.fragmentShaderSource=_fragmentShader;
  }

 
  final String _vertexShader = '''
      attribute highp vec3 aVertexPosition;
      attribute highp vec3 aVertexNormal;
      
      uniform highp mat4 uMVMatrix;
      uniform highp mat4 uPMatrix;
      uniform highp mat4 uNMatrix;
      uniform highp vec3 materialDiffuseColor;
      uniform highp vec3 materialAmbientColor;
      uniform highp vec3 uLightPos; 
      uniform highp vec3 lightColor;       

      
      varying highp vec3 vLighting;
      
      void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
  
        highp vec3 uLightPos = vec3(10.0, 10.0, 10.0); 
        highp vec3 lightColor = vec3(0.5, 0.5, 0.75);       

        // Apply lighting effect
        highp vec3 modelViewVertex = vec3(uMVMatrix * vec4(aVertexPosition, 1.0)); 
        highp vec3 modelViewNormal = vec3(uMVMatrix * vec4(aVertexNormal, 0.0));
        highp float distance = length(uLightPos - modelViewVertex);
  
        highp vec3 lightVector = normalize(uLightPos - modelViewVertex); 

        highp vec4 transformedNormal = uNMatrix * vec4(aVertexNormal, 1.0);        
        highp float directional = max(dot(transformedNormal.xyz, lightVector), 0.0);
        vLighting = materialAmbientColor + (lightColor * directional);


        //highp float diffuse = max(dot(modelViewNormal, lightVector), 0.0);
        //diffuse = diffuse * (1.0 / (1.0 + (0.25 * distance * distance)));
        //vLighting = materialDiffuseColor * diffuse;
        //vLighting=vec3(0.0, 0.0, 1.0);
      }
  ''';

  final String _fragmentShader = '''
    varying highp vec3 vLighting;
    
    void main(void) {
      gl_FragColor = vec4(vLighting, 1.0);
    }
  ''';
  
}