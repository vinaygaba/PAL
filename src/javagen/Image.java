import java.io.File;

public class Image {
	
	private File file;
	private int height;
	private int width;
	private int XCood;
	private int YCood;


	public Image(File file, int height, int width, int xcood, int ycood)
	{
		this.file = file;
		this.height = height;
		this.width = width;
		this.XCood = xcood;
		this.YCood = ycood;
	}
	
	public File getFile() {
		return file;
	}
	public void setFile(File file) {
		this.file = file;
	}
	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getXCood() {
		return XCood;
	}
	public void setXCood(int xCood) {
		XCood = xCood;
	}
	public int getYCood() {
		return YCood;
	}
	public void setYCood(int yCood) {
		YCood = yCood;
	}

}