package com.pal.text;

import java.io.File;
import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;

public class CreatePDFFromExistingPDF {
	
	public static void createPDFFromExistingPDF(File file) throws IOException{
		
		// Create a new empty document
		PDDocument document = PDDocument.load(new File("test.pdf"));
				
				
				
		// Save the newly created document
		document.save("BlankPage.pdf");

		// finally make sure that the document is properly
		// closed.
		document.close();
	}

}
