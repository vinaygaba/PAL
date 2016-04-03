

import java.util.HashMap;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;


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

  public PrimitiveObject(PDDocument doc){
    assignToMap(key,doc);
  }

  public PrimitiveObject(PDPage page){
    assignToMap(key,page);
  }

  public PrimitiveObject(PDPageContentStream contentStream){
    assignToMap(key,contentStream);
  }

  public void assignToMap(String key, Object value){
    primitiveObjectMap.put(key,value);
  }

  public boolean contains(String key) {
       return primitiveObjectMap.containsKey(key);
   }

}
