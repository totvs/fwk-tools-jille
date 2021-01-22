package com.word;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Calendar;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.xmlbeans.SimpleValue;
import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;

public class ChangeFormFields {

   public static void main(String[] args)throws Exception {
	   new ChangeFormFields().run();
   }
   
   public void run() throws Exception {
	   long tempo = Calendar.getInstance().getTimeInMillis();
	   this.fillFormField();
	   System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
   }
   
   private void fillFormField() throws Exception {
	   String file = "c:/tm/POIFormField.docx";
	   String newFile = "c:/tm/POIFormField-changed.docx";
	   
	   // abre o arquivo de template para preencher os formFields
	   XWPFDocument document = new XWPFDocument(new FileInputStream(file));

	   // efetua a troca dos campos pelos valores desejados
	   this.replaceFormFieldText(document, "pkNome", "aaaaaaaaaaaaaaaaaaaaaaaa");
	   this.replaceFormFieldText(document, "pkEndereco", "bbbbbbbbbbbbbbbbbbbbbbbbbb");
	   this.replaceFormFieldText(document, "pkTelefone", "(47) 99999-99.99");
	   this.replaceFormFieldText(document, "pkCep", "89.999-999");

	   // define o arquivo de saida
	   FileOutputStream out = new FileOutputStream(newFile);

	   // grava o conteudo alterado no novo arquivo
	   document.write(out);
	   document.close();
	   out.close();

	   System.out.println(ChangeFormFields.class.getName() + " - " + newFile + " alterado com sucesso!!!");
   }

   private void replaceFormFieldText(XWPFDocument document, String ffname, String text) {
	   boolean foundformfield = false;
	   // obtem todas as tabelas do documento
	   for (XWPFTable tbl : document.getTables()) {
		   // obtem todas as linhas da tabela
		   for (XWPFTableRow row : tbl.getRows()) {
			   // obtem todas as celulas de cada linha da tabela
			   for (XWPFTableCell cell : row.getTableCells()) {
				   // obtem todos os paragrafos de cada celula da tabela
				   for (XWPFParagraph paragraph : cell.getParagraphs()) {
					   // obtem os runs de cada paragrafo da celula
					   for (XWPFRun run : paragraph.getRuns()) {
						   // define um novo cursor
						   XmlCursor cursor = run.getCTR().newCursor();
						   // localiza uma informacao dentro do xml
						   cursor.selectPath("declare namespace w='http://schemas.openxmlformats.org/wordprocessingml/2006/main' .//w:fldChar/@w:fldCharType");
						   while(cursor.hasNextSelection()) {
							   cursor.toNextSelection();
							   XmlObject obj = cursor.getObject();
							   if ("begin".equals(((SimpleValue)obj).getStringValue())) {
								   cursor.toParent();
								   obj = cursor.getObject();
								   obj = obj.selectPath("declare namespace w='http://schemas.openxmlformats.org/wordprocessingml/2006/main' .//w:ffData/w:name/@w:val")[0];
								   if (ffname.equals(((SimpleValue)obj).getStringValue())) {
									   foundformfield = true;
								   } else {
									   foundformfield = false;
								   }
							   } else if ("end".equals(((SimpleValue)obj).getStringValue())) {
								   if (foundformfield) return;
								   foundformfield = false;
							   }
						   }
						   if (foundformfield && run.getCTR().getTList().size() > 0) {
							   // seta o novo valor para o formField
							   run.getCTR().getTList().get(0).setStringValue(text);
//							   System.out.println(run.getCTR());
						   }
					   }
				   }
			   }
		   }
	   }
   }
}
