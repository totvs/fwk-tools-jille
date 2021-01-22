package com.word;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Calendar;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;

public class ChangeFormVariables {

   public static void main(String[] args)throws Exception {
	   new ChangeFormVariables().run();
   }
   
   public void run() throws Exception {
	   long tempo = Calendar.getInstance().getTimeInMillis();
	   this.fillFormVar();
	   System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
   }
   
   private void fillFormVar() throws FileNotFoundException, IOException, URISyntaxException {
	   String file = "c:/tm/POIFormVar.docx";
	   String newFile = "c:/tm/POIFormVar-changed.docx";

	   // le o arquivo de template existente
	   XWPFDocument docx = new XWPFDocument(new FileInputStream(file));
	   
	   // realiza a troca das variaveis por um novo valor
	   this.replaceVariableText(docx, "pkNome", "Joao da Silva");
	   this.replaceVariableText(docx, "pkEndereco", "Rua x numero 1234");
	   this.replaceVariableText(docx, "pkTelefone", "1234-56.78");
	   this.replaceVariableText(docx, "pkCep", "89.000-000");
	   
	   // grava o novo documento ja com as variaveis alteradas
	   docx.write(new FileOutputStream(newFile));      
	   docx.close();
	   System.out.println(ChangeFormVariables.class.getName() + " - " + newFile + " alterado com sucesso!!!");
   }
   
   private void replaceVariableText(XWPFDocument document, String ffname, String newValue) {
	   // lemos todas as tabelas existentes no documento
	   for (XWPFTable tbl : document.getTables()) {
		   // lemos todas as linhas da tabela
		   for (XWPFTableRow row : tbl.getRows()) {
			   // lemos todas as celulas daa tabela
			   for (XWPFTableCell cell : row.getTableCells()) {
				   // obtemos todos os paragrafos de cada celula da tabela
				   for (XWPFParagraph p : cell.getParagraphs()) {
					   // obtemos a lista de runs de cada paragrafo para poder alterar o seu conteudo 
					   for (XWPFRun run : p.getRuns()) {
						   // pegamos o valor atual da celula
						   String oldText = run.getText(0);
//						   System.out.println("0-oldText=" + oldText + " - ffname=" + ffname + " - " + oldText.indexOf(ffname));
						   // se o nome procurado estiver dentro da celula, efetuamos a troca de conteudo
						   if (oldText.indexOf(ffname) > -1) {
//							   System.out.println("alterado para =" + newValue);
							   // grava o novo conteudo da celula
							   run.setText(newValue, 0);
						   }
					   }
				   }
			   }
		   }
	   }
   }
}
