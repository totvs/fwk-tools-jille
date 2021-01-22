package com.word;

import java.io.FileInputStream;
import java.util.Calendar;

import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

public class ReadWordText {

   public static void main(String[] args)throws Exception {
	   new ReadWordText().run();
   }
   
   public void run() throws Exception {
	   long tempo = Calendar.getInstance().getTimeInMillis();
	   this.readDocument();
	   System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
   }

   @SuppressWarnings("resource")
   private void readDocument() throws Exception {
	   String file = "c:/tm/POICreateWordDocument.docx";

	   // abre o documento ja existente
	   XWPFDocument docx = new XWPFDocument(new FileInputStream(file));
      
	   // le o conteudo do documento
	  XWPFWordExtractor we = new XWPFWordExtractor(docx);
	  
	  // mostra o conteudo do documento
      System.out.println(we.getText());
      
      // fecha o arquivo
      docx.close();
      System.out.println(ReadWordText.class.getName() + " - " + file + " lido com sucesso!!!");
   }
}
