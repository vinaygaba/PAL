public class Line {

	private String text;
	private String font;
	private int xcod;
	private int ycod;
	private int fontSize;
	private int width;
	private String remainingText;

	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getFont() {
		return font;
	}
	public void setFont(String font) {
		this.font = font;
	}
	public int getXcod() {
		return xcod;
	}
	public void setXcod(int xcod) {
		this.xcod = xcod;
	}
	public int getYcod() {
		return ycod;
	}
	public void setYcod(int ycod) {
		this.ycod = ycod;
	}
	public int getFontSize() {
		return fontSize;
	}
	public void setFontSize(int fontSize) {
		this.fontSize = fontSize;
	}

	public String getRemainingText() {
		return remainingText;
	}

	public void setRemainingText(String remainingText) {
		this.remainingText = remainingText;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getWidth() {
		return width;
	}


}
