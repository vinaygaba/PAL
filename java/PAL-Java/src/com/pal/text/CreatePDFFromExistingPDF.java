package com.pal.text;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PageLayout;

public class CreatePDFFromExistingPDF {
	
	/**
	 * Method to create a pdf file from an exiting pdf file
	 * @param filename Name of file that needs to be loaded
	 * @param filepath The file path where the output pdf should be saved to
	 * @throws IOException
	 */
	public static void createPDFFromExistingPDF(String filename,String filepath) throws IOException{
		
		File file = new File(filename);
		
		// Create a new empty document
		PDDocument document = PDDocument.load(file);
		
				
		// Save the newly created document
		document.save(filepath);

		// finally make sure that the document is properly
		// closed.
		document.close();
	}
	
	/**
	 * Method to merge multiple PDF's
	 * @param files List of files that need to be merged
	 * @param filepath The file path where the output pdf should be saved to
	 * @throws IOException
	 */
	public static void mergePDFs(List<File> files,String filepath)throws IOException{
		
		PDDocument doc = new PDDocument();
		
		for(File file:files){
			PDDocument document1 = PDDocument.load(file);
			
			for(PDPage pg:document1.getPages()){
				doc.addPage(pg);
			}
			
		}
		
		// Save the newly created document
		doc.save(filepath);

		// finally make sure that the document is properly
		// closed.
		doc.close();
		
	}

}
