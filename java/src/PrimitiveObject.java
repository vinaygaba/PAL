


public class PrimitiveObject{
  private final HashMap<String, Object> primitiveObjectMap = new HashMap<String, Object>();
  private final static String key = "PAL_KEY";


  public PrimitiveObject(){

  }

  public PrimitiveObject(int a){
    assignToMap(key,a);
  }

  public PrimitiveObject(boolean b){
    assignToMap(key,b);
  }

  public PrimitiveObject(String str){
    assignToMap(key,str);
  }

  public PrimitiveObject(float f){
    assignToMap(key,f);
  }

  public void assignToMap(String key, Object value){
    primitiveObjectMap.put(key,value);
  }


}
