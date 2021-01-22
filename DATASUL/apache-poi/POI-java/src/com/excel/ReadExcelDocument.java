package com.excel;

import java.io.File;
import java.util.Calendar;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ReadExcelDocument {
	 
	public static void main(String[] args)throws Exception {
		new ReadExcelDocument().run();
	}
   
	public void run() throws Exception {
		long tempo = Calendar.getInstance().getTimeInMillis();
    	readExcelFile();
		System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
    }
    
    private void readExcelFile() throws Exception {
    	//String file = "c:/tm/POISf0419.xlsx";
    	String file = "c:/tm/POICreateExcelDocument.xlsx";

		// abre o arquivo Excel (.xls or .xlsx)
		Workbook workbook = WorkbookFactory.create(new File(file));

		// Obtem o total de planilhas existentes no arquivo
		System.out.println("Workbook possui " + workbook.getNumberOfSheets() + " planilhas ");

		// Obtem os nomes das planilhas
		System.out.println("Nomes das Planilhas:");
		for(Sheet sheet: workbook) {
			System.out.println("- " + sheet.getSheetName());
		}

		// Obtem a planilha 0
		Sheet sheet = workbook.getSheetAt(0);

		// formata o conteudo da celula para string
		DataFormatter dataFormatter = new DataFormatter();

		// Le os dados da planilha
		System.out.println("Lendo as linhas e colunas da planilha:");
		for (Row row: sheet) {
			for(Cell cell: row) {
				String cellValue = dataFormatter.formatCellValue(cell);
				System.out.print(cellValue + "\t");
			}
			System.out.println();
		}

		// fecha a planilha
		workbook.close();
    }
}
