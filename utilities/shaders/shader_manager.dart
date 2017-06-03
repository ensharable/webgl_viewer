part of WebGLUtils;

/**
 * singleton
 */
class ShaderManager {
  Map _shaders = new Map<String, Shader>();
  
  static final ShaderManager _sm = new ShaderManager._internal();

  factory ShaderManager() {
    return _sm;
  }

  ShaderManager._internal();
  
  void add(String key, Shader s){
    this._shaders.putIfAbsent(key, ()=>s);
  }
  
  Shader get(String key){
    return this._shaders[key];
  }
  
}