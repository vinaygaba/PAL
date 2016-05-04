
  import java.io.File;
  import org.apache.pdfbox.pdmodel.PDDocument;
  import org.apache.pdfbox.pdmodel.PDPage;
  import org.apache.pdfbox.pdmodel.PageLayout;
  import org.apache.pdfbox.pdmodel.font.PDFont;
  import org.apache.pdfbox.pdmodel.PDPageContentStream;
  import org.apache.pdfbox.pdmodel.font.PDType1Font;
  import java.util.ArrayList;
  import java.util.Arrays;
  import java.util.List;
  import java.util.HashMap;
  import java.util.Map;  
  public class Output
  {
      public static void main(String[] args) throws Exception
      {
        PDDocument pdfVar = new PDDocument();
PDPage pageVar = new PDPage();
pdfVar = Util.addPageToPDF(pdfVar,pageVar);
;
Tuple tupleVar = new Tuple(pdfVar,pageVar);
List<List<String>> table = new ArrayList<List<String>>(); 

String location = "/Users/dikshavanvari/Desktop/pie.pdf";List<Integer> pagenumbers = new ArrayList<Integer>(); 
pagenumbers[new Integer(0)] = new Integer(1);
table = 
 Util.readTable(location, pagenumbers);
Map<String,String> properties = new HashMap<String,String>(); 
properties.put("ChartTitle","Test Pie Chart"); 
properties.put("Height","400"); 
properties.put("Width","300"); 
properties.put("X","200"); 
properties.put("Y","600"); 

File file = new File(""); 
Image chartimage = new Image(file,800,600,100,600);
chartimage = 
 Util.drawPieChart(table, properties);
tupleVar = Util.addImageToTuple(tupleVar, chartimage);

"helloworld.pdf".save(pdfVar);
 "helloworld.pdf".close();
      }  
  }
