import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.PDFont;


public class TextWrapper {
	
	public static void main(String[] args) throws Exception {
		String title = "This is my wonderful title!"; // Or whatever title you want.
		int marginTop = 30; // Or whatever margin you want.

		PDDocument document = new PDDocument();
		PDPage page = new PDPage();
		document.addPage( page );
		PDPageContentStream stream = new PDPageContentStream(document, page);
		int fontSize = 12; // Or whatever font size you want.
		int paragraphWidth = 100;
		String text = "ksajdhaksjh dkajshdkjhasd hbjhbjhbkjlklhkgy yggub jgh"
				+ "kjhkjhkjhkjhkjhlkllb h khkjkjhb ygtdsdtygj kuhkhyffjk "
				+ "yhgjhvjghkjn ghkjhkfhl fghkjjhvhghggh gutftesdfgh uyghkgvb "
				+ "jhvgfhj fjhhchgvb ufghjhfcghjo dfd ftyukjhvbnjg sdfg"
				+ "ghfcn";
			
		int start = 0;
		int end = 0;
		int height = 10;
		stream.setFont(PDType1Font.TIMES_ROMAN, fontSize);
		
		
		
		int[] array = possibleWrapPoints(text);
		for(int i = 0; i < array.length; i++)
			System.out.println(array[i]);
			
	
		PDFont font = PDType1Font.TIMES_ROMAN;
		
		for (int i =0; i < array.length; i++ ) {
	    float width = font.getStringWidth(text.substring(start,array[i])) / 1000 * fontSize;
	    System.out.println("outer width:" +width);
		    if ( start <= end && width > paragraphWidth ) {
		    	
		    System.out.println("width:" +width);
//		        // Draw partial text and increase height
		    	stream.beginText();
		    	stream.moveTextPositionByAmount(10 , height);
		    	end = array[i];
		    	stream.drawString(text.substring(start, end));
      	        height += font.getFontDescriptor().getFontBoundingBox().getHeight() / 1000 * fontSize;
      	        System.out.println("height" +height);
     	        start = end;
     	        stream.endText();
		    }
		    end = array[i];
		}
	
		stream.beginText();
		stream.moveTextPositionByAmount(10 , height);
		stream.drawString(text.substring(start));
	    stream.endText();
			
	    stream.close(); 
	     System.out.println("saving pdf");
	 
	 
		document.save("test1.pdf");
	    document.close();
		
	}
	
	static	int[]  possibleWrapPoints(String text) {
	    String[] split = text.split("(?<=\\W)");
	    int[] ret = new int[split.length];
	    ret[0] = split[0].length();
	    for ( int i = 1 ; i < split.length ; i++ )
	        ret[i] = ret[i-1] + split[i].length();
	    return ret;
	}

}
