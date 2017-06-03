part of objectviewer;

class Objectviewer{

    WebGL.RenderingContext glContext;
    CanvasElement canvas;
    Camera camera = new Camera();
    int get width => canvas.width;
    int get height => canvas.height;
    ShaderManager sm = new ShaderManager();

    void startup(String canvasId) {
      canvas = querySelector(canvasId);
      glContext = canvas.getContext('experimental-webgl');
      if (glContext == null) {
        canvas.parent.text = ">>> Browser does not support WebGL <<<";
        return;
      }

      canvas.width = canvas.parent.client.width;
      canvas.height = canvas.parent.client.height;

      camera.aspectRatio = canvas.width / canvas.height;
      camera.screenWidth = canvas.width;
      camera.screenHeight = canvas.height;

      //String modelUrl=getBaseUrl()+"/3dmodels/box_triangle_mesh.obj";
      //String materialUrl=getBaseUrl()+"/3dmodels/box_triangle_mesh.mtl";

      String modelUrl=getBaseUrl()+"/3dmodels/box_2.obj";
      String materialUrl=getBaseUrl()+"/3dmodels/box_2.mtl";

      Scene testScene = new Scene();

      testScene.loadObjects(modelUrl, materialUrl).then((value) {
        startEngine();
      });;

    }

    void startEngine(){
      //ObjectViewerShader ovs = new ObjectViewerShader(glContext);
      //sm.add("test", ovs);

      ObjectViewerLightShader ovls = new ObjectViewerLightShader(glContext);
      sm.add("objectLightShader", ovls);

      ObjectViewerTextureLightShader ovtls = new ObjectViewerTextureLightShader(glContext);
      sm.add("objectTextureLightShader", ovtls);

      //initial camera
      InputController contrller = new InputController(this.canvas, camera);

      //start engine
      var me = new ViewerEngine(glContext, camera);
    }

}
