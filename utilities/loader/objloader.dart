
part of WebGLUtils;

class ObjLoader{
  
  static Future<Object> parseObjectModelFromURL(String url){
    return HttpRequest.getString(url).then((String fileContents) {
      return readDataString(fileContents);
    });
  }
  
  static Future<Material> parseObjectMaterialFromURL(String url){
    
    return HttpRequest.getString(url).then((String fileContents) {
      return readMaterialString(fileContents);
    });
  }
  
  static ModelObject readDataString(String fileContents){
    List<String> linesContents = fileContents.split('\n');
    Iterator it = linesContents.iterator;
    
    String id;
    var vertices = new List();
    var normals = new List();
    var facesIndices = new List();
    var normalIndices = new List();
    int verticesCounter=0;
    int normalsCounter=0;
    int facesCounter=0;
    String useMaterial;
    
    while(it.moveNext()){
      List<String> currentline = it.current.trim().split(' ');
      if(currentline.elementAt(0)=='o'){
        id = currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='usemtl'){
        useMaterial = currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='v'){
        for(int i=1; i<currentline.length; i++){
          vertices.add(double.parse(currentline.elementAt(i)));
        }
        verticesCounter++;
      }else if(currentline.elementAt(0)=='vn'){
        for(int i=1; i<currentline.length; i++){
          normals.add(double.parse(currentline.elementAt(i)));
        }
        normalsCounter++;
      }else if(currentline.elementAt(0)=='f'){
        for(int i=1; i<currentline.length; i++){
          //the WebGL index is zero base, but the obj file is 1 base
          if(currentline.elementAt(i).contains("//", 0)){
            List<String> currentElements = currentline.elementAt(i).split("//");
            facesIndices.add(int.parse(currentElements.elementAt(0)) - 1);
            normalIndices.add(int.parse(currentElements.elementAt(1)) - 1);
          }else{
            facesIndices.add(int.parse(currentline.elementAt(i)) - 1);
          }
        }
        facesCounter++;
      }
    }
    
    List<double> fixedNormals = createNormalArray(normals, normalIndices, normalsCounter);
    List<double> fixedVertics = createVertexArray(vertices, facesIndices, verticesCounter);
    
    print("vertces count: " + verticesCounter.toString() + "\n" + vertices.toString());
    print("faces count: " + facesCounter.toString() + "\n" + facesIndices.toString());
    print("normals count: " + normalsCounter.toString() + "\n" + normals.toString());
    print("normals indices: " + normalIndices.toString());
    print("fixed vertices: #"+ fixedVertics.length.toString() +"=" + fixedVertics.toString());
    print("fixed normals: #"+ fixedNormals.length.toString() +"=" + fixedNormals.toString());
    
    
    return new ModelObject(id, vertices, facesIndices, verticesCounter, facesCounter, useMaterial, normalIndices, normals, normalsCounter, fixedVertics, fixedNormals);
  }
  
  
  /*
Ka r g b
defines the ambient color of the material to be (r,g,b). The default is (0.2,0.2,0.2);
Kd r g b
defines the diffuse color of the material to be (r,g,b). The default is (0.8,0.8,0.8);
Ks r g b
defines the specular color of the material to be (r,g,b). This color shows up in highlights. The default is (1.0,1.0,1.0);
d alpha
defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all) Some formats use Tr instead of d;
Tr alpha
defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all). Some formats use d instead of Tr;
Ns s
defines the shininess of the material to be s. The default is 0.0;
illum n
denotes the illumination model used by the material. illum = 1 indicates a flat material with no specular highlights, so the value of Ks is not used. illum = 2 denotes the presence of specular highlights, and so a specification for Ks is required.
map_Ka filename
names a file containing a texture map, which should just be an ASCII dump of RGB values;
   */
  static Material readMaterialString(String fileContents){
    
    List<String> linesContents = fileContents.split('\n');
    Iterator it = linesContents.iterator;
    
    Material material = new Material();
    
    while(it.moveNext()){
      List<String> currentline = it.current.trim().split(' ');
      if(currentline.elementAt(0)=='newmtl'){
        material.name=currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='Ka'){
        material.ambient=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='Ns'){
        material.shininessOfMateria = double.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='Kd'){
        material.diffuse=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='Ks'){
        material.specular=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='d'){
        material.transparent=double.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='illum'){
        material.illuminationMode=int.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='map_Ka'){
        material.textureMap=currentline.elementAt(1);
      }
      
    }
    return material;
  }
  
  static List<double> createNormalArray(List<double> normals, List<int> normalsIndices, int normalsCounter){
    if(normalsCounter==0){
      return null;
    }else{
      List<double> result = new List<double>();
      int vector_dim = normals.length~/normalsCounter; //divide(return int result)
      for(final x in normalsIndices){
        result.add(normals[vector_dim*x]);
        result.add(normals[vector_dim*x+1]);
        result.add(normals[vector_dim*x+2]);
      }
      return result;
    }
  }
  
  static List<double> createVertexArray(List<double> vertices, List<int> facesIndices, int verticesCounter){
    if(verticesCounter==0){
      return null;
    }else{
      List<double> result = new List<double>();
      int vector_dim = vertices.length~/verticesCounter; //divide(return int result)
      for(final x in facesIndices){
        result.add(vertices[vector_dim*x]);
        result.add(vertices[vector_dim*x+1]);
        result.add(vertices[vector_dim*x+2]);
      }
      return result;
    }
  }
}