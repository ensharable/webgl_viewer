part of WebGLUtils;

/**
 * To hold all the reference for the lights
 * singleton
 */
class LightsManager {
  Map _lightObjects = new Map<String, Light>();
  
  static final LightsManager _lm = new LightsManager._internal();

  factory LightsManager() {
    return _lm;
  }

  LightsManager._internal();
  
  void addLight(Light o){
    this._lightObjects.putIfAbsent(o.id, ()=>o);
  }
  
  Object getLight(String key){
    return this._lightObjects[key];
  }
  
}