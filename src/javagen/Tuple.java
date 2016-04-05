import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

public class Tuple {

	private PDDocument document;
	private PDPage page;

  public Tuple(PDDocument document, PDPage page) {
		super();
		this.document = document;
		this.page = page;
	}

	public PDDocument getDocument() {
		return document;
	}
	public void setDocument(PDDocument document) {
		this.document = document;
	}
	public PDPage getPage() {
		return page;
	}
	public void setPage(PDPage page) {
		this.page = page;
	}



}
