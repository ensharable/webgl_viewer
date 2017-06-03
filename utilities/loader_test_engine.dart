part of WebGLUtils;

class LoaderTestEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  ObjectViewerShader objectViewershader;
  TextureShader shader;
  TextureLightShader textureLightShader;
  
  ObjectViewerLightShader objectViewerLightShader;
  
  WebGL.RenderingContext glContext;
  Camera cam;
  
  double angleSpeed = 0.002;
  RenderObject robj;
  BoxWithNormal bwn;
  BoxWithTexture bwt;
  
  MaterialManager mm = new MaterialManager();
  
  LoaderTestEngine(WebGL.RenderingContext glContext, Camera camera){
    this.glContext = glContext;
    
    objectViewershader = new ObjectViewerShader(glContext);
    objectViewershader.prepare();
    objectViewershader.enable();
    
    shader = new TextureShader(glContext);
    shader.prepare();
    shader.enable();
    
    textureLightShader =  new TextureLightShader(glContext);
    textureLightShader.prepare();
    textureLightShader.enable();
    
    objectViewerLightShader = new ObjectViewerLightShader(glContext);
    objectViewerLightShader.prepare();
    objectViewerLightShader.enable;
    
    cam = camera;
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
    
    
    /*
    String modelUrl=getBaseUrl()+"/3dmodels/box_triangle_mesh.obj";
    String materialUrl=getBaseUrl()+"/3dmodels/box_triangle_mesh.mtl";
    ObjectModel obj;
    Future objLoad = ObjLoader.parseObjectModelFromURL(modelUrl);
    Future materialLoad = ObjLoader.parseObjectMaterialFromURL(materialUrl);
    
    
    Future first = objLoad.then((ObjectModel result) {
      robj = new RenderObject(glContext, objectViewershader.program, result);
      robj.setupBuffers();
      
    });
    
    Future second = materialLoad.then((Material result) {
      mm.addMaterial(result);
      robj.setupMaterial();
    });
    
    Future.wait([first, second]).then((value) {
      start();
    });
    */
    bwt = new BoxWithTexture(glContext, textureLightShader.program);
    bwt.setupBuffers();
    bwt.setupTexture();
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
    
    //moveCamForward();
    //moveCamBackward();
    //moveCamLeft();
    //moveCamRight();
    
    /*
    objectViewershader.enable();
    objectViewershader.pUniform = projectionMatrix;
    objectViewershader.mvUniform = _tranMatrix;
    
    robj.modifyShaderAttributes();
    robj.prerender();
    robj.render();
    */
    
    /*
    objectViewerLightShader.enable();
    objectViewerLightShader.pUniform = projectionMatrix;
    objectViewerLightShader.mvUniform = _tranMatrix;
    */
    textureLightShader.enable();
    textureLightShader.pUniform = projectionMatrix;
    textureLightShader.mvUniform = _tranMatrix;
    
    Matrix4 norM = _tranMatrix.clone();
    norM.invert();
    norM.transpose();
    textureLightShader.normalUniform = norM;
    
    bwt.modifyShaderAttributes();
    bwt.prerender();
    bwt.render();
    
    requestRedraw();
  }
  
  void requestRedraw() {
    window.animationFrame.then(update);
  }
  
 
  
}