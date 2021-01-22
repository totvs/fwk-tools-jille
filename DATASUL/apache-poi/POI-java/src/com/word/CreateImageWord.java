package com.word;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Calendar;

import org.apache.poi.util.Units;
import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;

public class CreateImageWord {

   public static void main(String[] args)throws Exception {
	   new CreateImageWord().run();
   }
   
   public void run() throws Exception {
	   long tempo = Calendar.getInstance().getTimeInMillis();
	   this.createImage();
	   System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
   }
   
   private void createImage() throws Exception {
	   String newFile = "c:/tm/POICreateImageWord.docx";
	   String imageFile = "c:/tm/totvs.png";

	   // Cria um documento em branco
	   XWPFDocument document = new XWPFDocument(); 
	      
	   // Especifica o arquivo de saida onde sera gravado o documento do word
	   FileOutputStream out = new FileOutputStream(new File(newFile));
	   
	   // cria um paragrafo para conter a imagem 
	   XWPFParagraph image = document.createParagraph();
	   
	   // define o alinhamento desse paragrafo
	   image.setAlignment(ParagraphAlignment.LEFT);
	   
	   // cria um run no paragrafo para adicionar a imagem
	   XWPFRun imageRun = image.createRun();
	   
	   // especifica o posicionamento desse run
	   imageRun.setTextPosition(0);
       
	   // carrega a imagem e joga dentro do documento
	   Path imagePath = Paths.get(Paths.get(imageFile).toUri());
	   imageRun.addPicture(Files.newInputStream(imagePath),
			   XWPFDocument.PICTURE_TYPE_PNG, imagePath.getFileName().toString(),
			   Units.toEMU(50), Units.toEMU(50));	   

	   // cria um novo paragrafo para texto
	   XWPFParagraph paragraph = document.createParagraph();
	   
	   // define um outro alinhamento para o paragrafo
	   paragraph.setAlignment(ParagraphAlignment.BOTH);
	   
	   // cria um run para o paragrafo
	   XWPFRun run = paragraph.createRun();
	   
	   // adiciona o texto do paragrafo
	   run.setText("Este documento tem como objetivo demonstrar a utilizacao do java para a cricacao de arquivos do word. \n"
			   + "Aqui temos um exemplo de uma imagem embutida no documento.");
	   
	   // grava o novo arquivo do word criado
	   document.write(out);
	   document.close();
	   out.close();
	   System.out.println(CreateImageWord.class.getName() + " - " + newFile + " criado com sucesso!!!");
   }
}