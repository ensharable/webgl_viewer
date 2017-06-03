part of WebGLUtils;

class ViewerEngine{
  MaterialManager mm = new MaterialManager();
  ModelObjectManager mom = new ModelObjectManager();
  ShaderManager sm = new ShaderManager();
  LightsManager lm = new LightsManager();
  
  Matrix4 _tranMatrix = new Matrix4.identity();
  Shader shader;
  
  WebGL.RenderingContext glContext;
  Camera cam;
  
  double angleSpeed = 0.002;
  MyRenderObject robj;
  
  ViewerEngine(WebGL.RenderingContext glContext, Camera camera){
    this.glContext = glContext;
    
    shader = sm.get("objectTextureLightShader");
    shader.prepare();
    shader.enable();
    cam = camera;
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
    
    //Get the object to render
    robj = new MyRenderObject(glContext, shader.program, mom.getObject("Cube"));
    robj.setupBuffers();
    robj.setupMaterial();

    //get the light
    Light light = lm.getLight("light_1");
    light.prerender(glContext, shader.program);
        
    start();
  }
  
  void start(){
    requestRedraw();
  }
  
  void move(){
    Matrix4 temp = new Matrix4.translationValues(0.01, 0.0, 0.0);
    _tranMatrix = _tranMatrix*temp;
  }
  
  void rotation(){
    Matrix4 temp = new Matrix4.rotationY(angleSpeed);
    _tranMatrix = _tranMatrix*temp;
  }
  
  
  Matrix4 get tranMatrix => _tranMatrix;
  
  void update(double time){
    glContext.viewport(0, 0, cam.screenWidth, cam.screenHeight);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    //glContext.enable(WebGL.RenderingContext.CULL_FACE);
    glContext.depthFunc(WebGL.RenderingContext.LEQUAL);  
    glContext.enable(WebGL.RenderingContext.DEPTH_TEST);
    
    //set the matrix:
    var projectionMatrix = cam.projectionMatrix;
    var viewMatrix = cam.lookAtMatrixWithDirection;
    projectionMatrix.multiply(viewMatrix);
    
    //move();
    rotation();
    
    shader.enable();
    shader.pUniform = projectionMatrix;
    shader.mvUniform = _tranMatrix;
    
    //calculate normal matrix (The normal matrix is the transpose inverse of the modelview matrix. )
    //GSSL : mat4 normalMatrix = transpose(inverse(modelView));
    var normalMatrix = new Matrix4.copy(_tranMatrix);
    normalMatrix.invert();
    normalMatrix.transpose();
    shader.nUniform = normalMatrix;
    
    robj.modifyShaderAttributes();
    robj.prerender();
    robj.render();
    requestRedraw();
  }
  
  void requestRedraw() {
    window.animationFrame.then(update);
  }
}