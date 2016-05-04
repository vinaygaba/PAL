
import java.io.File;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import com.giaybac.traprange.PDFTableExtractor;
import com.giaybac.traprange.entity.Table;

public class Util{

  public static PDDocument addPageToPDF(PDDocument doc,PDPage page) throws Exception{

    doc.addPage(page);

    return doc;
  }

  public static Tuple addLineToTuple(Tuple tuple,Line line)throws Exception{
    // Start a new content stream which will "hold" the to be created content

    int pwidth = line.getWidth();
    int start = 0;
    int end = 0;
    PDPageContentStream contentStream = new PDPageContentStream(tuple.getDocument(), tuple.getPage(), true, true);

    PDFont font = PDType1Font.TIMES_ROMAN;
    int[] array = possibleWrapPoints(line.getText());
    // Define a text content stream using the selected font, moving the cursor and drawing the text "Hello World"
   
   for (int i =0; i < array.length; i++ ) {
      float width = font.getStringWidth(line.getText().substring(start,array[i])) / 1000 * line.getFontSize();
        if ( start <= end && width > pwidth ) {

           contentStream.beginText();
           contentStream.setFont(PDType1Font.TIMES_ROMAN, line.getFontSize());
           contentStream.moveTextPositionByAmount( line.getXcod(), line.getYcod() );
           end = array[i];
           contentStream.drawString(line.getText().substring(start,end));
           contentStream.endText();
           line.setRemainingText(line.getText().substring(end,line.getText().length()));

            // Make sure that the content stream is closed:
            contentStream.close();
    break;
        }
        else if(i == array.length - 1)
        {
           contentStream.beginText();
           contentStream.setFont(PDType1Font.TIMES_ROMAN, line.getFontSize());
           contentStream.moveTextPositionByAmount( line.getXcod(), line.getYcod() );
           end = array[i];
           contentStream.drawString(line.getText().substring(start,end));
           contentStream.endText();
           line.setRemainingText("");
            // Make sure that the content stream is closed:
            contentStream.close();

        }
    }
    return tuple;
  }


public static Tuple addImageToTuple(Tuple tuple, Image image) throws Exception
{
 PDImageXObject pdIMage = PDImageXObject.createFromFileByContent(image.getFile(), tuple.getDocument());
 PDPageContentStream contentStream = new PDPageContentStream(tuple.getDocument(), tuple.getPage(), true, true);

 
 contentStream.drawImage(pdIMage, image.getXCood(), image.getYCood(), image.getHeight(), image.getWidth());
 
 contentStream.close();
    
 return tuple;  

}


 public static List<List> readTable(String location, List<Integer> pageNumbers){
      
        PDFTableExtractor extractor = (new PDFTableExtractor()).setSource(location);
             
        List<List> lists = new ArrayList<List>();
        for(Integer j : pageNumbers)
        {
          extractor.addPage(j);
         
          List<Table> extract = extractor.extract();
          String csv = extract.get(0).toString();
       
          String[] line = csv.split("\n");
          for(int i = 0; i < line.length; i++)
          {
            String[] splits = line[i].split(";");
            List<String> asList = Arrays.asList(splits);
            lists.add(asList);
          }
        
        }
         
        return lists;
  }


  public static String readFile(String location) throws Exception{

    BufferedReader br = new BufferedReader(new FileReader(location));
    try {
        StringBuilder sb = new StringBuilder();
        String line = br.readLine();

        while (line != null) {
            sb.append(line);
            sb.append(" ");
            line = br.readLine();
        }
        return sb.toString();
    } finally {
        br.close();
    }

  }


    static  int[]  possibleWrapPoints(String text) {
      String[] split = text.split("(?<=\\W)");
      int[] ret = new int[split.length];
      ret[0] = split[0].length();
      for ( int i = 1 ; i < split.length ; i++ )
          ret[i] = ret[i-1] + split[i].length();
      return ret;
  }

}
