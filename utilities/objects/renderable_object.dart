part of WebGLUtils;

abstract class RenderableObject{
  WebGL.RenderingContext _gl;
  WebGL.Program _p;  
  ModelObject _obj;
  WebGL.Buffer indexBuffer;
  WebGL.Buffer vertexBuffer;
  WebGL.Buffer verticesColorBuffer;
  int aVertexPosition;
  int aVertexColor;
  int aVertexNormal;

  MaterialManager mm = new MaterialManager();
  Material m;
  
  RenderableObject(WebGL.RenderingContext gl, WebGL.Program p, ModelObject obj){
    this._gl=gl;
    this._p=p;
    this._obj=obj;
  }
  
  void setupBuffers();
  void modifyShaderAttributes();
  void prerender();
  void render();
}