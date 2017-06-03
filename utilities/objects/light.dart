part of WebGLUtils;

/*
 * Base class for light
 */
abstract class Light{
  String id;
  Vector3 lightPosition;
  Vector3 lightColor;
  Vector3 lightSpecColor;
  
  Light(String id, Vector3 lightPosition, Vector3 lightColor, Vector3 lightSpecColor){
    this.id=id;
    this.lightPosition = lightPosition;
    this.lightColor = lightColor;
    this.lightSpecColor = lightSpecColor;
  }
  
  /**
   * abstract method for prerender
   */
  void prerender(WebGL.RenderingContext gl, WebGL.Program p);
}
