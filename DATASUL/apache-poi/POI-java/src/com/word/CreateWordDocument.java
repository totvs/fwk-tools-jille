package com.word;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Calendar;

import org.apache.poi.xwpf.usermodel.Borders;
import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.UnderlinePatterns;
import org.apache.poi.xwpf.usermodel.VerticalAlign;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;

public class CreateWordDocument {

   public static void main(String[] args)throws Exception {
	   new CreateWordDocument().run();
   }
   
   public void run() throws Exception {
	   long tempo = Calendar.getInstance().getTimeInMillis();
	   this.createDocument();
	   System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
   }

   private void createDocument() throws Exception {
	   String newFile = "c:/tm/POICreateWordDocument.docx"; 

	   // cria um documento em branco
	   XWPFDocument document = new XWPFDocument(); 
      
	   // Cria o stream para gravacao do arquivo
	   FileOutputStream out = new FileOutputStream(new File(newFile));
        
	   // cria um novo paragrafo
	   XWPFParagraph paragraph = document.createParagraph();
      
	   // define a borta inferior do paragrafo
	   paragraph.setBorderBottom(Borders.BASIC_BLACK_DASHES);
        
	   // define a borda esquerda do paragrafo
	   paragraph.setBorderLeft(Borders.BASIC_BLACK_DASHES);
        
	   // define a borda direita para o paragrafo
	   paragraph.setBorderRight(Borders.BASIC_BLACK_DASHES);
        
	   // define a borda superior para o paragrafo
	   paragraph.setBorderTop(Borders.BASIC_BLACK_DASHES);
      
	   // cria um run para o paragrafo
	   XWPFRun run = paragraph.createRun();
      
	   // adiciona o texto do paragrafo
	   run.setText("Este documento tem como objetivo demonstrar a utilizacao do java para a cricacao de arquivos do word. \n"
			   + "Aqui temos um exemplo de um paragrafo com bordas em volta no documento.");

	   // cria um tabela
	   XWPFTable table = document.createTable();
		
	   // cria a 1a. linha
	   XWPFTableRow tableRow1 = table.getRow(0);
	   tableRow1.getCell(0).setText("col 1, lin1");
	   tableRow1.addNewTableCell().setText("col 2, lin 1");
	   tableRow1.addNewTableCell().setText("col 3, lin 1");
		
	   // cria a 2a. linha
	   XWPFTableRow tableRow2 = table.createRow();
	   tableRow2.getCell(0).setText("col 1, lin 2");
	   tableRow2.getCell(1).setText("col 2, lin 2");
	   tableRow2.getCell(2).setText("col 3, lin 2");
		
	   // cria a 3a. linha
	   XWPFTableRow tableRow3 = table.createRow();
	   tableRow3.getCell(0).setText("col 1, lin 3");
	   tableRow3.getCell(1).setText("col 2, lin 3");
	   tableRow3.getCell(2).setText("col 3, lin 3");

	   // cria um novo paragrafo
	   paragraph = document.createParagraph();

	   // define o fonte Bold e Italic
	   XWPFRun paragraph1Run1 = paragraph.createRun();
	   paragraph1Run1.setBold(true);
	   paragraph1Run1.setItalic(true);
	   paragraph1Run1.setText("Estilo de fonte 1");
	   paragraph1Run1.addBreak();
        
	   // define a posicao do texto
	   XWPFRun paragraph1Run2 = paragraph.createRun();
	   paragraph1Run2.setText("Estilo de fonte 2");
	   paragraph1Run2.setTextPosition(50);
 
	   // define o tamanho da fonte, tracado e sobrescrito para o texto
	   XWPFRun paragraph1Run3 = paragraph.createRun();
	   paragraph1Run3.setStrikeThrough(true);
	   paragraph1Run3.setFontSize(30);
	   paragraph1Run3.setSubscript(VerticalAlign.SUBSCRIPT);
	   paragraph1Run3.setText("Diferentes estilos de fontes");
      
	   // cria outro paragrafo
	   paragraph = document.createParagraph();
	   paragraph.setAlignment(ParagraphAlignment.RIGHT);
	   run = paragraph.createRun();
	   run.setText("Este documento tem como objetivo demonstrar a utilizacao do java para a cricacao de arquivos do word. \n"
			   + "Aqui temos um exemplo de um paragrafo alinhado pela direita.");
        
	   // cria outro paragrafo
	   paragraph = document.createParagraph();
	   paragraph.setAlignment(ParagraphAlignment.CENTER);
	   run = paragraph.createRun();
	   run.setText("Este documento tem como objetivo demonstrar a utilizacao do java para a cricacao de arquivos do word. \n"
			   + "Aqui temos um exemplo de um paragrafo centralizado.");

	   // cria outro paragrafo
	   paragraph = document.createParagraph();
	   paragraph.setAlignment(ParagraphAlignment.BOTH);

	   run = paragraph.createRun();
	   run.setColor("00CC44");
	   run.setFontFamily("Courier");
	   run.setFontSize(14);
	   run.setTextPosition(20);
	   run.setUnderline(UnderlinePatterns.DOT_DOT_DASH);
	   run.setText("Este documento tem como objetivo demonstrar a utilizacao do java para a cricacao de arquivos do word. \n"
			   + "Aqui temos um exemplo de um paragrafo justificado com outro tipo de fonte e tracejado.");

	   // grava o arquivo do documento
	   document.write(out);
	   document.close();
	   out.close();
	   System.out.println(CreateWordDocument.class.getName() + " - " + newFile + " gravado com sucesso!!!");
   }
}