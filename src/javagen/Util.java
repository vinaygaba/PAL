

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

public class Util{


  public static PDDocument addPageToPDF(PDDocument doc,PDPage page) throws Exception{

    doc.addPage(page);

    return doc;
  }

  public static Tuple addLineToTuple(Tuple tuple,Line line)throws Exception{
    // Start a new content stream which will "hold" the to be created content
    PDPageContentStream contentStream = new PDPageContentStream(tuple.getDocument(), tuple.getPage(), true, true);

    // Define a text content stream using the selected font, moving the cursor and drawing the text "Hello World"
   contentStream.beginText();
   contentStream.setFont(PDType1Font.TIMES_ROMAN, line.getFontSize());
   contentStream.moveTextPositionByAmount( line.getXcod(), line.getYcod() );
   contentStream.drawString(line.getText());
   contentStream.endText();
   contentStream.close();

    // Make sure that the content stream is closed:
    contentStream.close();


    return tuple;
  }


}
