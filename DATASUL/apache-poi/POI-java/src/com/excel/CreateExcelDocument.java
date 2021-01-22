package com.excel;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CreateExcelDocument {

	private XSSFWorkbook wb;
	private List<String> cabList;
	private JSONArray ja;

	public static void main(String[] args)throws Exception {
		new CreateExcelDocument().run();
	}
   
	public void run() throws Exception {
		long tempo = Calendar.getInstance().getTimeInMillis();
		this.createExcelFile();
		System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
	}

	@SuppressWarnings("unchecked")
	private void createExcelFile() throws IOException {
		String file = "C:/tm/POICreateExcelDocument.xlsx";

		// define o cabecalho 
		this.cabList = new ArrayList<String>();
		this.cabList.add("Nome");
		this.cabList.add("Endereco");
		this.cabList.add("Estado Civil");
		this.cabList.add("Valor1");
		this.cabList.add("Valor2");
		this.cabList.add("Total");
				
		// define a lista de dados
		this.ja = new JSONArray();
		this.ja.add(this.addItem("Joao", "Rua x no. y", "89.200-000", "true", "10", "50"));
		this.ja.add(this.addItem("Maria", "Rua yyy", "89.000-000", "false", "20", "60"));
		this.ja.add(this.addItem("Pedro", "Rua kkk", "89.100-000", "false", "30", "70"));
		this.ja.add(this.addItem("Manuel", "Rua zzz", "89.300-000", "true", "40", "80"));
		
		// cria a planilha em branco
		this.wb = new XSSFWorkbook();
        
		this.createSheet("Pagina Principal", true);
		this.createSheet("Pagina Secundaria", false);

		// grava a planilha em arquivo
		File excel = new File(file);
		FileOutputStream fos = new FileOutputStream(excel);
		this.wb.write(fos);
		this.wb.close();

        System.out.println(file + " criado com sucesso!!!");
	}        
        
    private void createSheet(String title, boolean change) {
        // define o nome do folder da planilha
        XSSFSheet sheet = this.wb.createSheet(title);

        // ajusta informacoes da planilha
		sheet.setFitToPage(new Boolean(true));
		sheet.setHorizontallyCenter(new Boolean(true));
		sheet.setVerticallyCenter(new Boolean(true));

		int rowCount = 0;
		int celCount = 0;
		Cell cell = null;
		
		// monta o cabecalho
		Row row = sheet.createRow(rowCount++);
		
		// cria uma nova linha e especifica o cabecalho com o respectivo estilo
		for (String data: cabList) {
			cell = row.createCell(celCount);
			cell.setCellStyle(this.getBoldStyle());
			cell.setCellValue(data + (change?"1":"2"));
			sheet.autoSizeColumn(celCount++);
		}
		
		// monta os dados da planilha
		for (Object obj : ja.toArray()) {
			JSONObject jo = (JSONObject)obj;
			celCount = 0;

			// cria uma nova linha
			row = sheet.createRow(rowCount++);
			
			// cria as celulas da linha
			cell = row.createCell(celCount++);
    		cell.setCellValue((String)jo.get("nome") + (change?"1":"2"));
    		cell = row.createCell(celCount++);
    		cell.setCellValue((String)jo.get("endereco") + (change?"1":"2"));
    		cell = row.createCell(celCount++);
    		if (Boolean.parseBoolean((String)jo.get("casado"))) {
        		cell.setCellValue("Casado" + (change?"1":"2"));
    		} else {
        		cell.setCellValue("Solteiro" + (change?"1":"2"));
    		}
    		cell = row.createCell(celCount++);
    		cell.setCellValue(Double.parseDouble((String)jo.get("valor1")) + (change?1:2));
    		cell = row.createCell(celCount++);
    		cell.setCellValue(Double.parseDouble((String)jo.get("valor2")) + (change?1:2));
    		cell = row.createCell(celCount++);
    		cell.setCellFormula("D" + rowCount + "+E" + rowCount);
		}

		// cria uma nova linha para o total geral
		row = sheet.createRow(rowCount++);
		cell = row.createCell(4);
		cell.setCellValue("TOTAL GERAL" + (change?1:2));
		cell = row.createCell(5);
		cell.setCellFormula("SUM(F1:F" + (rowCount - 1) + ")");
    }

	@SuppressWarnings("unchecked")
	private JSONObject addItem(String nome, String endereco, String cep, String casado, String vl1, String vl2) {
		JSONObject jo = new JSONObject();
		jo.put("nome", nome);
		jo.put("endereco", endereco);
		jo.put("cep", cep);
		jo.put("casado", casado);
		jo.put("valor1", vl1);
		jo.put("valor2", vl2);
		return jo;
	}
	
	private CellStyle getBoldStyle() {
		// monta o estilo das celulas
		CellStyle style = this.wb.createCellStyle();
		// define o tipo de fonte
   		Font font = this.wb.createFont();
        font.setBold(true);
        style.setFont(font);
        
        // define o preenchimento
		style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        // define o alinhamento
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        // define as bordas
		style.setBorderBottom(BorderStyle.NONE);
		style.setBorderLeft(BorderStyle.NONE);
		style.setBorderRight(BorderStyle.NONE);
		style.setBorderTop(BorderStyle.NONE);
	    style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());

	    return style;
	}
}
