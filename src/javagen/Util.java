
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
import org.jfree.chart.ChartFactory;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;

import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;

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


  public static Image drawPieChart(List<List<String>> data, HashMap<String, String> attributes) {

		try {

			DefaultPieDataset pieDataset = new DefaultPieDataset();
			int width = 400; /* Width of the image */
			int height = 300; /* Height of the image */
			String chartTitle = "Chart Title";
			String imageName = "imageName.png";
			int xcod = 100;
			int ycod = 700;

			if (attributes.containsKey("ChartTitle")) {
				chartTitle = attributes.get("ChartTitle");
			}

			if (attributes.containsKey("Height")) {
				height = Integer.parseInt(attributes.get("Height"));
			}

			if (attributes.containsKey("Width")) {
				width = Integer.parseInt(attributes.get("Width"));
			}

			if (attributes.containsKey("ImageName")) {
				imageName = attributes.get("ImageName") + ".png";
			}

			if (attributes.containsKey("X")) {
				xcod = Integer.parseInt(attributes.get("X"));
			}

			if (attributes.containsKey("Y")) {
				ycod = Integer.parseInt(attributes.get("Y"));
			}

			System.out.println(data.size());
			List<String> subList;
			for (int i = 0; i < data.size(); i++) {
				subList = data.get(i);
				pieDataset.setValue(subList.get(0), Integer.parseInt(subList.get(1)));
			}
			// Create the chart
			JFreeChart chart = ChartFactory.createPieChart3D(chartTitle, pieDataset, true, true, true);

			ChartUtilities.saveChartAsPNG(new File(imageName), chart, height, width);

			Image image = new Image(new File(imageName), height, width, xcod, ycod);

			return image;

		}

    public static Image drawBarChart(List<List<String>> data, HashMap<String, String> attributes) {

		try {

			DefaultCategoryDataset dataset = new DefaultCategoryDataset();
			int width = 400; /* Width of the image */
			int height = 300; /* Height of the image */
			String chartTitle = "Chart Title";
			String imageName = "imageName.png";
			String xaxis = "X-Axis";
			String yaxis = "Y-Axis";
			int xcod = 100;
			int ycod = 700;

			if (attributes.containsKey("ChartTitle")) {
				chartTitle = attributes.get("ChartTitle");
			}

			if (attributes.containsKey("Height")) {
				height = Integer.parseInt(attributes.get("Height"));
			}

			if (attributes.containsKey("Width")) {
				width = Integer.parseInt(attributes.get("Width"));
			}

			if (attributes.containsKey("ImageName")) {
				imageName = attributes.get("ImageName") + ".png";
			}

			if (attributes.containsKey("X")) {
				xcod = Integer.parseInt(attributes.get("X"));
			}

			if (attributes.containsKey("Y")) {
				ycod = Integer.parseInt(attributes.get("Y"));
			}

			for (int i = 0; i < data.size(); i++) {
				List<String> subList = data.get(i);
				dataset.addValue(Double.parseDouble(subList.get(1)), xaxis, subList.get(0));

			}

			JFreeChart barChart = ChartFactory.createBarChart(chartTitle, xaxis, yaxis, dataset,
					PlotOrientation.VERTICAL, true, true, false);

			ChartUtilities.saveChartAsPNG(new File(imageName), barChart, width, height);

			Image image = new Image(new File(imageName), height, width, xcod, ycod);

			return image;
		}

		catch (Exception e) {
			return null;
		}
	}


}
