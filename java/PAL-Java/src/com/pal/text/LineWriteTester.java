package com.pal.text;

	import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

	public class LineWriteTester
	{
	/**
	 * @param page
	 * @param contentStream
	 * @param y
	 * @param margin
	 * @param content
	 * @throws IOException
	 */
	  public static void drawTable(PDPage page, PDPageContentStream contentStream, float y, float margin, String[][] content) throws IOException {
	
	    //now add the text
	    
	    //set font
	
	
	    contentStream.setFont(PDType1Font.HELVETICA_BOLD,12);

	 
	            contentStream.beginText();
	            contentStream.setLeading(1f);
	            contentStream.moveTextPositionByAmount(50, 700);
	            contentStream.drawString("Some text");
	       //     contentStream.moveTextPositionByAmount(50, 720);
                contentStream.drawString("Some more text.");
//	            contentStream.newLine();
//	            contentStream.drawString("Still some more text.");
//	            //contentStream.moveTextPositionByAmount();
//
//	            contentStream.drawString("Hello! It is a good day today");
	            contentStream.endText();
	            
	           
	       }

	  
	 
	public static void main(String[] args) throws IOException {

		//Create a PDF Document
	    PDDocument doc = new PDDocument();
	    
	    //Add a page to it
	    PDPage page = new PDPage();
	    doc.addPage( page );
	    
	    //Get content stream
	    PDPageContentStream contentStream = new PDPageContentStream(doc, page);


		//2D string data
	    String[][] content = {
	        {"Name"," Time "},
	        {"HTC","01:25"},
	        {"Samsung Tab2","05:30"}
	    } ;
	    
	    drawTable(page, contentStream, 700, 100, content);

	    contentStream.close();
	    doc.save("test.pdf" );
	} 

	}


