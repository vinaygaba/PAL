package com.pal.text;

import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

public class TextPlacement {
	
	public static void main(String[] args) throws IOException {
		
		// Create a document and add a page to it
		PDDocument document = new PDDocument();
		PDPage page = new PDPage();
		document.addPage( page );

		// Create a new font object selecting one of the PDF base fonts
		PDFont font = PDType1Font.HELVETICA_BOLD;

		// Start a new content stream which will "hold" the to be created content
		PDPageContentStream content = new PDPageContentStream(document, page);

		
		
		content.beginText();
		content.setFont(font, 12);
		content.setLeading(14.5f);
		content.moveTextPositionByAmount(100, 700);
		content.drawString("Some text.");
		content.newLine();
		content.drawString("Some more text.");
		content.newLine();
		content.drawString("Still some more text.");
		
		content.close();
		int a = 5;
		
		document.save("test.pdf");
		document.close();
	}

}
