package com.pal.text;

import java.io.File;
import java.io.IOException;
import java.util.List;
import org.apache.pdfbox.multipdf.Splitter;
import org.apache.pdfbox.pdmodel.PDDocument;

public class SplitPdf{
	//Splits document into 1 page sized Pdfs
	public static void splitPdf(File file) throws IOException{
				// Load an existing PDF document
		PDDocument documentToSplit = PDDocument.load(new File("test.pdf"));
		Splitter documentSplitter = new Splitter();
		// Splitting based on resulting document size (default is 1)
		List<PDDocument> splitDocuments = documentSplitter.split(documentToSplit);
		int i = 1;
		// Saving the split documents as a Pdf
		for(PDDocument doc : splitDocuments){
			doc.save("test" + i + ".pdf");
			doc.close();
			i++;
		}
	}
	//Splits document into 'split' sized Pdfs
	public static void splitPdfwithSize(File file, int split) throws IOException{
		// Load an existing PDF document
		PDDocument documentToSplit = PDDocument.load(new File("test.pdf"));
		Splitter documentSplitter = new Splitter();
		documentSplitter.setSplitAtPage(split);
		// Splitting based on resulting document size (default is 1)
		List<PDDocument> splitDocuments = documentSplitter.split(documentToSplit);
		int i = 1;
		// Saving the split documents as a Pdf
		for(PDDocument doc : splitDocuments){
			doc.save("test" + i + ".pdf");
			doc.close();
			i++;
		}
	}
	
}
