package com.excel;

public class TestExcel {

	public static void main(String[] args) throws Exception{
		new CreateExcelDocument().run();
		new ReadExcelDocument().run();
		new ConvertXmlToXlsx().run();
		new ChangeFormulaExcel().run();
	}
}
