

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

public class Util{


  public static PDPDocument addPageToPDF(PDPDocument doc,PDPage page){

    doc.addPage(page);

    return doc;
  }


}
