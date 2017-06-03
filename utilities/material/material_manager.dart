part of WebGLUtils;

/**
 * singleton
 */
class MaterialManager {
  Map _materials = new Map<String, Material>();
  
  static final MaterialManager _mm = new MaterialManager._internal();

  factory MaterialManager() {
    return _mm;
  }

  MaterialManager._internal();
  
  void addMaterial(Material m){
    this._materials.putIfAbsent(m.name, ()=>m);
  }
  
  Material getMaterial(String key){
    return this._materials[key];
  }
  
}