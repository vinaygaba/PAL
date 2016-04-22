package com.pal.text;

import java.io.File;
import java.io.FileFilter;
import java.util.List;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

public class LineWriter {

    /**
     * @param args the command line arguments
     */
    public static final FileFilter pdfFileFilter = new FileFilter() {

        public boolean accept(File file) {
            return file.isFile() && file.getName().toLowerCase().endsWith(".pdf");
        }
    };

    public static void closeQuietly(PDDocument doc) {
        if (doc != null) {
            try {
                doc.close();
            } catch (Exception exception) {
                //do something here if you wish like logging 
            }
        }
    }

    public static void CheckPages(File[] sourcePdfFiles,String textToInsert, String prefix) {

        for (File sourcePdfFile : sourcePdfFiles) {
            PDFont font = PDType1Font.HELVETICA_BOLD;
            float fontSize = 12.0f;
            PDDocument pdoc = null;
            try {

                pdoc = PDDocument.load(sourcePdfFile);
                List allPages = pdoc.getp
                PDPage lastPage = (PDPage) allPages.get(allPages.size() - 1);
                PDRectangle pageSize = lastPage.findMediaBox();
                float stringWidth = font.getStringWidth(textToInsert);
                float centeredPosition = (pageSize.getWidth() - (stringWidth * fontSize) / 1000f) / 2f;

                PDPageContentStream contentStream = new PDPageContentStream(pdoc, lastPage, true, true);

                contentStream.beginText();
                contentStream.setFont(font, fontSize);
                contentStream.moveTextPositionByAmount(centeredPosition, 30);
                contentStream.drawString(textToInsert);
                contentStream.endText();
                contentStream.close();

                File resultFile = new File(sourcePdfFile.getParentFile(), prefix + sourcePdfFile.getName());
                pdoc.save(resultFile.getAbsolutePath());


            } catch (Exception e) {
                System.err.println("An exception occured in parsing the PDF Document." + e.getMessage());
            } finally {
                closeQuietly(pdoc);
            }
        }
    }

    public static void main(String[] args) {
        File pdfFilesFolder = new File("C:\\1");
        File[] pdfFiles = pdfFilesFolder.listFiles(pdfFileFilter);
        //when a file is processed, the result will be saved in a new file having the location of the source file 
        //and the same name of source file prefixed with this
        String modifiedFilePrefix = "modified-";
        CheckPages(pdfFiles,"AAA", modifiedFilePrefix);
    }
}