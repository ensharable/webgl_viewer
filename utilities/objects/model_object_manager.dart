part of WebGLUtils;

/**
 * singleton
 */
class ModelObjectManager {
  Map _modelObjects = new Map<String, ModelObject>();
  
  static final ModelObjectManager _mom = new ModelObjectManager._internal();

  factory ModelObjectManager() {
    return _mom;
  }

  ModelObjectManager._internal();
  
  void addObject(ModelObject o){
    this._modelObjects.putIfAbsent(o.id, ()=>o);
  }
  
  Object getObject(String key){
    return this._modelObjects[key];
  }
  
}