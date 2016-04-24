
  import java.io.File;
  import org.apache.pdfbox.pdmodel.PDDocument;
  import org.apache.pdfbox.pdmodel.PDPage;
  import org.apache.pdfbox.pdmodel.PageLayout;
  import org.apache.pdfbox.pdmodel.font.PDFont;
  import org.apache.pdfbox.pdmodel.PDPageContentStream;
  import org.apache.pdfbox.pdmodel.font.PDType1Font;
  public class Output
  {
      public static void main(String[] args) throws Exception
      {
        PDDocument pdfVar = new PDDocument();
PDPage page1 = new PDPage();
pdfVar = Util.addPageToPDF(pdfVar,page1);
;
Tuple tupleVar = new Tuple(pdfVar,page1);

File imageVarfile = new File("file.png"); 
Image imageVar = new Image(imageVarfile,new Integer(100),new Integer(100),new Integer(500),new Integer(600));
tupleVar = Util.addImageToTuple(tupleVar, imageVar);

pdfVar.save("helloworld.pdf");
 pdfVar.close();
      }  
  }
