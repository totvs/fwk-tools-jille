package com.excel;

import java.io.File;
import java.util.Calendar;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellReference;

public class ChangeFormulaExcel {
	 
	private Workbook wb;
	
	public static void main(String[] args)throws Exception {
		new ChangeFormulaExcel().run();
	}
   
	public void run() throws Exception {
		long tempo = Calendar.getInstance().getTimeInMillis();
    	this.readExcelFile();
		System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
    }
    
    private void readExcelFile() throws Exception {
    	//String file = "c:/tm/POISf0419.xlsx";
    	String file = "c:/tm/POICreateExcelDocument.xlsx";

		// abre o arquivo Excel (.xls or .xlsx)
		this.wb = WorkbookFactory.create(new File(file));

		// Obtem o total de planilhas existentes no arquivo
		System.out.println("Workbook possui " + this.wb.getNumberOfSheets() + " planilhas ");

		// Obtem os nomes das planilhas
		System.out.println("Nomes das Planilhas:");
		for(Sheet sheet: this.wb) {
			System.out.println("- " + sheet.getSheetName());
			if (sheet.getSheetName().equalsIgnoreCase("Pagina Principal")) {
				Row row = sheet.getRow(4);
				Cell cell1 = row.getCell(3);
				Cell cell2 = row.getCell(4);

				System.out.println("\tAlterado valor da celula D5 de " + cell1.getNumericCellValue() + " para 4444"); 
				System.out.println("\tAlterado valor da celula E5 de " + cell2.getNumericCellValue() + " para 5555"); 
				System.out.println("\tFormula F5 = " + row.getCell(5).getCellFormula()); 

				cell1.setCellValue(4444);
				cell2.setCellValue(5555);

				System.out.print("\tResultado = " + cell1.getNumericCellValue() + " + " + cell2.getNumericCellValue() + " = "); 
				System.out.println(this.getFormulaValue(sheet, "F5"));
			}
		}

		// fecha a planilha
		this.wb.close();
    }
    
    private String getFormulaValue(Sheet sheet, String celula) {
		FormulaEvaluator evaluator = this.wb.getCreationHelper().createFormulaEvaluator();
		String cellRet = null;

    	CellReference cellReference = new CellReference(celula); // pass the cell which contains the formula
        Row row = sheet.getRow(cellReference.getRow());
        Cell cell = row.getCell(cellReference.getCol());
        CellValue cellValue = evaluator.evaluate(cell);

        if (cellValue.getCellType() == CellType.BOOLEAN) {
            cellRet = String.valueOf(cellValue.getBooleanValue());
        } else if (cellValue.getCellType() == CellType.NUMERIC) {
            cellRet = String.valueOf(cellValue.getNumberValue());
        } else if (cellValue.getCellType() == CellType.STRING) {
            cellRet = cellValue.getStringValue();
        } else if (cellValue.getCellType() == CellType.BLANK) {
        	cellRet = "";
        } else if (cellValue.getCellType() == CellType.ERROR) {
        	cellRet = "";
        } 
		return cellRet;
    }
}
