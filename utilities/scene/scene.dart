part of WebGLUtils;

class Scene {
  List<String> objectsNames;
  ModelObjectManager objectManager = new ModelObjectManager();
  MaterialManager materialManager = new MaterialManager();
  ShaderManager shaderManager = new ShaderManager();
  LightsManager lightsManager = new LightsManager();
  String shadername;
  
  
  Scene(){
    objectsNames = new List<String>();
  }

  Future loadObjects(String objUrl, String matUrl){
    //Light settings
    Vector3 lightPosition = new Vector3(1.0, 1.0, 1.0);
    Vector3 lightColor = new Vector3(0.5, 0.5, 0.0) ; 
    Vector3 lightSpecColor = new Vector3( 1.0, 1.0, 0.0);
    PointLight pl = new PointLight("light_1", lightPosition, lightColor, lightSpecColor);
    lightsManager.addLight(pl);    
    
    Future objLoad = ObjLoader.parseObjectModelFromURL(objUrl);
    Future materialLoad = ObjLoader.parseObjectMaterialFromURL(matUrl);
    
    return Future.wait([objLoad, materialLoad])
      .then((List responses) => handleObjectLoaded(responses))
      .catchError((e) => handleObjectLoadError(e));
  }
  
  void handleObjectLoaded(List responds){
    ModelObject obj = responds[0];
    Material mat = responds[1];
    if(obj!=null){
      objectManager.addObject(obj);
    }
    if(mat!=null){
      materialManager.addMaterial(mat);
    }
    objectsNames.add(obj.id);
  }
  
  void setShaderName(String shadername){
    shadername=shadername;
  }
  
  void handleObjectLoadError(Error e){
    print(e.toString());
  }
}