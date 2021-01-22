package com.totvs.framework.poi;

import java.io.StringReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.poi.ss.usermodel.Workbook;
import org.json.simple.JSONObject;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import com.totvs.framework.util.ConvertXmlToXlsx;

@EnableWebMvc
@RestController
@RequestMapping("/poi")
public class POIResource {
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "/teste")
	public JSONObject teste(
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("executando");
		JSONObject jo = new JSONObject();
		jo.put("OK", true);
		return jo;
	}

	@RequestMapping(
			method = RequestMethod.POST, value = "/generateExcel", 
			consumes = { MediaType.TEXT_PLAIN_VALUE })
	public void generateExcel(
			@RequestBody String xmlData,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		long tempo = Calendar.getInstance().getTimeInMillis();
		
		System.out.println(">>>> inicio generateExcel - xmlData (bytes)=" + xmlData.length());

		DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd_HHmmss");
        String currentDateTime = dateFormatter.format(new Date());
        String filename = "totvs_" + currentDateTime + ".xlsx";

		response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);

		Workbook wb = null;
		try {
	        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
	        DocumentBuilder builder = factory.newDocumentBuilder();  
	        Document doc = builder.parse(new InputSource(new StringReader(xmlData)));

			ConvertXmlToXlsx conv = new ConvertXmlToXlsx();
			wb = conv.readXmlData(doc); 
		} catch (Exception e) {
			e.printStackTrace();
		}
        
		if (wb != null) {
			ServletOutputStream outputStream = response.getOutputStream();
			wb.write(outputStream);
			wb.close();
			outputStream.close();
		}
		System.out.println(">>>> Final generateExcel - Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
	}
}
