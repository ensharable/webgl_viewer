part of WebGLUtils;

class ModelObject{
  String id;
  List<double> vertics;
  List<double> normals;

  List<double> fixedNormals;
  List<double> fixedVertics;
  
  List<int> facesIndices;
  List<int> normalsIndices;
  
  int verticsCount=0;
  int facesCount=0;
  int normalsCount=0;
  
  int vertexStride=0;
  int positionAttributeIndex;
  int colorAttributeIndex;
  
  String useMaterial;
  
  ModelObject(String id, List<double> vertics, List<int> facesIndices, int verticsCount, 
      int facesCount, String useMaterial, List<int> normalsIndices, 
      List<double> normals, int normalsCount,
      List<double> fixedVertices, List<double> fixedNormals){
    this.id=id;
    this.vertics=vertics;
    this.facesIndices=facesIndices;
    
    this.verticsCount=verticsCount;
    this.facesCount=facesCount;
    this.useMaterial=useMaterial;
    
    this.normalsIndices=normalsIndices;
    this.normals=normals;
    this.normalsCount=normalsCount;
    
    this.fixedVertics = fixedVertices;
    this.fixedNormals = fixedNormals;
  }

}