package ths.project.common.entity;

/**
 * 导出Excel的图片类
 * @author liangdl
 * @since 2017-6-23
 */
public class Image {
	/** 图片字符串 **/
	private String base64;
	/** Sheet页索引，从0开始 **/
	private int sheetIndex;
	/** 开始行，从0开始 **/
	private int startRow = 0;
	/** 开始列，从0开始 **/
	private int startCell = 0;
	/** 宽度 **/
	private int width;
	/** 高度 **/
	private int height;
	
	/**
	 * 构造方法
	 * @param base64 图片字符串
	 * @param sheetIndex Sheet页索引，从0开始
	 * @param startRow 开始行，从0开始
	 * @param startCell 开始列，从0开始
	 * @param width 宽度列数
	 * @param height 高度行数
	 */
	public Image(String base64, int sheetIndex, int startRow, int startCell, int width, int height) {
		super();
		this.base64 = base64;
		this.sheetIndex = sheetIndex;
		this.startRow = startRow;
		this.startCell = startCell;
		this.width = width;
		this.height = height;
	}
	
	/**
	 * 构造方法
	 * @param base64 图片字符串
	 * @param sheetIndex Sheet页索引，从0开始
	 * @param width 宽度列数
	 * @param height 高度行数
	 */
	public Image(String base64, int sheetIndex, int width, int height) {
		super();
		this.base64 = base64;
		this.sheetIndex = sheetIndex;
		this.width = width;
		this.height = height;
	}

	public String getBase64() {
		return base64;
	}

	public void setBase64(String base64) {
		this.base64 = base64;
	}

	public int getSheetIndex() {
		return sheetIndex;
	}

	public void setSheetIndex(int sheetIndex) {
		this.sheetIndex = sheetIndex;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getStartCell() {
		return startCell;
	}

	public void setStartCell(int startCell) {
		this.startCell = startCell;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

}
