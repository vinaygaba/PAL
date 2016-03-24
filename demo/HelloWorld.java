
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

class HelloWorld{
  // Create a document and add a page to it
PDDocument pdfVar = new PDDocument();
PDPage page1 = new PDPage();
pdfVar.addPage( page1 );

// Create a new font object selecting one of the PDF base fonts
PDFont font = PDType1Font.TIMES_NEW_ROMAN;

// Start a new content stream which will "hold" the to be created content
PDPageContentStream contentStream = new PDPageContentStream(pdfVar, page1);

// Define a text content stream using the selected font, moving the cursor and drawing the text "Hello World"
contentStream.beginText();
contentStream.setFont( font, 12 );
contentStream.moveTextPositionByAmount( 100, 700 );
contentStream.drawString( "Hello World" );
contentStream.endText();

// Make sure that the content stream is closed:
contentStream.close();

// Save the results and ensure that the document is properly closed:
document.save( "helloworld.pdf");
document.close();

}
