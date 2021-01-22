package com.excel;

import java.io.File;
import java.io.FileOutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.PrintSetup;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ConvertXmlToXlsx {
	private Workbook wb = null;
	private Map<String, Sheet> wsList = new HashMap<String, Sheet>();
	private Map<String, CellStyle> stList = new HashMap<String, CellStyle>();

	public static void main(String[] args)throws Exception {
		new ConvertXmlToXlsx().run();
	}
   
	public void run() throws Exception {
		long tempo = Calendar.getInstance().getTimeInMillis();
		String file = "c:/tm/POIPlanilha.xml";
		this.readXmlData(file);
		System.out.println("Tempo gasto = " + (Calendar.getInstance().getTimeInMillis() - tempo) + " ms");
	}

	/**
	 * Le o xml
	 * @param fileName
	 * @throws Exception
	 */
	private void readXmlData(String fileName) throws Exception {
        System.out.println("Converting -> " + fileName);
        
        File xmlFile = new File(fileName);

        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
        Document doc = dBuilder.parse(xmlFile);

        this.wb = new XSSFWorkbook();

        // le os estilos
        this.readStyles(doc);
        
        // cria as sheets
        this.createSheets(doc);
       
        // cria as celulas da planilha
        this.createCells(doc);

        String newFile = fileName.replace(".xml", ".xlsx");
        
        System.out.println("Creating -> " + newFile);

        FileOutputStream fileOut = new FileOutputStream(newFile);
        this.wb.write(fileOut);
        this.wb.close();
        fileOut.close();

        System.out.println("Convertion completed!");
    }
    
    /**
     * Le os estilos e monta a lista de estilos para as celulas
     * @param doc
     */
    private void readStyles(Document doc) {
        System.out.print("Read Styles... ");
        NodeList sList = doc.getElementsByTagName("Style");
        for (int i = 0; i < sList.getLength(); i++) {
            Node node = sList.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                // <Style ss:ID="Default" ss:Name="Normal"> ou <Style ss:ID="s21">
            	String styleID = this.getAttribute(node, "ss:ID");
            	//prop.put("styleName", this.getAttribute(node, "ss:Name"));

        		CellStyle style = this.wb.createCellStyle();

            	Element element = (Element) node;
    			if (element.hasChildNodes()) {
                	NodeList chList = element.getChildNodes();
                    for (int j = 0; j < chList.getLength(); j++) {
                        Node chNode = chList.item(j);
                        String chType = chNode.getNodeName();
                        if (chNode.getNodeType() == Node.ELEMENT_NODE) {
                        	Element chElement = (Element) chNode;
                            if (chType.equalsIgnoreCase("Font")) {
                            	// <Font x:Family="Swiss" ss:Bold="1"/>
                            	String familyAt = this.getAttribute(chNode, "x:Family");
                            	String boldAt = this.getAttribute(chNode, "ss:Bold");
                            	if (familyAt.length() > 0 || boldAt.length() > 0) {
                            		Font font = this.wb.createFont();
                            		if (familyAt.length() > 0) font.setFontName(familyAt);
                            		if (boldAt.length() > 0) font.setBold(boldAt.equals("1"));
                            		style.setFont(font);
                            	}
                        	}
	                        if (chType.equalsIgnoreCase("Interior")) {
	                            // <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
	                        	String colorAt = this.getAttribute(chNode, "ss:Color");
	                        	String patternAt = this.getAttribute(chNode, "ss:Pattern");
	                      		if (colorAt.length() > 0) {
	                      			style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		                    		if (patternAt.length() > 0 && patternAt.equalsIgnoreCase("Solid")) {
		                    			style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		                    		}
	                    		}
	                        }
	                        if (chType.equalsIgnoreCase("Alignment")) {
	                            // <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
	                        	String horiz = this.getAttribute(chNode, "ss:Horizontal");
	                        	String vert = this.getAttribute(chNode, "ss:Vertical");
	                        	if (horiz.length() > 0) {
	                        		horiz = horiz.toLowerCase();
	                        		switch (horiz) {
	                        			case "center":
	                                        style.setAlignment(HorizontalAlignment.CENTER);
	                                        break;
	                        			case "left":
	                                        style.setAlignment(HorizontalAlignment.LEFT);
	                                        break;
	                        			case "right":
	                                        style.setAlignment(HorizontalAlignment.RIGHT);
	                                        break;
	                        			case "justify":
	                                        style.setAlignment(HorizontalAlignment.JUSTIFY);
	                                        break;
	                        		}
	                        	}
	                    		if (vert.length() > 0) {
	                        		vert = vert.toLowerCase();
	                    			switch (vert) {
	                    				case "bottom":
	                                		style.setVerticalAlignment(VerticalAlignment.BOTTOM);
	                                		break;
	                    				case "center":
	                                		style.setVerticalAlignment(VerticalAlignment.CENTER);
	                                		break;
	                    				case "justify":
	                                		style.setVerticalAlignment(VerticalAlignment.JUSTIFY);
	                                		break;
	                    				case "top":
	                                		style.setVerticalAlignment(VerticalAlignment.TOP);
	                                		break;
	                    			}
	                        	}
	                        }
	                        if (chType.equalsIgnoreCase("NumberFormat")) {
	                            // <NumberFormat ss:Format="######0.00"/>
	                        	String format = this.getAttribute(chNode, "ss:Format");
	                        	if (format.length() > 0) {
	                        		XSSFDataFormat sfFormat = (XSSFDataFormat) this.wb.createDataFormat();
	                        		style.setDataFormat(sfFormat.getFormat(format));
	                        	}
	                        }
	                        if (chType.equalsIgnoreCase("Borders")) {
	                        	// <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	                        	NodeList bdList = chElement.getChildNodes();
	                            for (int k = 0; k < bdList.getLength(); k++) {
	                                Node bdNode = bdList.item(k);
	                                String bdType = bdNode.getNodeName();
	                                if (bdNode.getNodeType() == Node.ELEMENT_NODE) {
	                                    if (bdType.equalsIgnoreCase("Border")) {
	                                        // <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	                                    	String position = this.getAttribute(bdNode, "ss:Position");
	                                    	String lineStyle = this.getAttribute(bdNode, "ss:LineStyle");
	                                    	// String weight = this.getAttribute(bdNode, "ss:Weight");
	                                    	if (position.length() > 0) {
	                                    		position = position.toLowerCase();
	                                    		BorderStyle bs = BorderStyle.NONE;
	                                    		lineStyle = lineStyle.toLowerCase();
	                                    		if (lineStyle.equalsIgnoreCase("Continuous")) {
		                                    		bs = BorderStyle.THIN;
	                                    		}
	                                    		
	                                    		switch (position) {
		                                    		case "bottom":
		                                    			style.setBorderBottom(bs);
			                                    	    style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		                                    			break;
		                                    		case "left":
		                                    			style.setBorderLeft(bs);
			                                    	    style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		                                    			break;
		                                    		case "right":
		                                    			style.setBorderRight(bs);
		                                    			style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		                                    			break;
		                                    		case "top":
		                                    			style.setBorderTop(bs);
			                                    	    style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		                                    			break;
	                                    		}
	                                    	}
	                                    }
	                                }
	                            }
                            }
                    	}
                    }
    			}
    			this.stList.put(styleID, style);
            }
        }
        System.out.println(this.stList.size() + " !");
    }

    /**
     * Cria as sheets do excel e guarda na wsList
     * @param doc
     */
    private void createSheets(Document doc) {
        System.out.print("Read Sheets... ");
        NodeList wsNList = doc.getElementsByTagName("Worksheet");
        for (int i = 0; i < wsNList.getLength(); i++) {
            Node node = wsNList.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) node;
                
                // le os nomes das tabs para criar os sheets
            	String sheetName = element.getAttribute("ss:Name");

            	if (sheetName == null) sheetName = "Tab" + i;
        		
            	Sheet sheet = this.wb.createSheet(sheetName);

            	// landscape
        		PrintSetup printSetup = sheet.getPrintSetup();
        		printSetup.setLandscape(new Boolean(true));

            	// fittopage
        		sheet.setFitToPage(new Boolean(true));
        		
            	// horizontalcenter
        		sheet.setHorizontallyCenter(new Boolean(true));
        		sheet.setVerticallyCenter(new Boolean(true));

        		// ajusta o cabecalho
        		NodeList headerList = element.getElementsByTagName("Header");
        		if (headerList != null  && headerList.getLength() > 0) {
        			String headerMargin = this.getAttribute(headerList.item(0), "x:Margin");
        			if (headerMargin != null) printSetup.setHeaderMargin(Double.parseDouble(headerMargin));
        		}
        		
        		// ajusta o rodape
        		NodeList footerList = element.getElementsByTagName("Footer");
        		if (footerList != null  && footerList.getLength() > 0) {
        			String footerMargin = this.getAttribute(footerList.item(0), "x:Margin");
        			if (footerMargin != null) printSetup.setFooterMargin(Double.parseDouble(footerMargin));
        		}
        		
        		// ajusta as margens de impressao
        		NodeList marginsList = element.getElementsByTagName("PageMargins");
        		if (marginsList != null  && marginsList.getLength() > 0) {
        			String pageMarginBottom = this.getAttribute(marginsList.item(0), "x:Bottom");
        			String pageMarginLeft = this.getAttribute(marginsList.item(0), "x:Left");
        			String pageMarginRight = this.getAttribute(marginsList.item(0), "x:Right");
        			String pageMarginTop = this.getAttribute(marginsList.item(0), "x:Top");
        			if (pageMarginBottom != null) sheet.setMargin(Sheet.BottomMargin, Double.parseDouble(pageMarginBottom));
        			if (pageMarginLeft != null) sheet.setMargin(Sheet.LeftMargin, Double.parseDouble(pageMarginLeft));
        			if (pageMarginRight != null) sheet.setMargin(Sheet.RightMargin, Double.parseDouble(pageMarginRight));
        			if (pageMarginTop != null) sheet.setMargin(Sheet.TopMargin, Double.parseDouble(pageMarginTop));
        		}
        		
        		// ajusta o pageBreaks
        		NodeList zoomList = element.getElementsByTagName("PageBreakZoom");
        		if (zoomList != null  && zoomList.getLength() > 0) {
        			// String pageBreakZoom = zoomList.item(0).getTextContent();
        			// System.out.println("pageBreakZoom = " + pageBreakZoom);
        			sheet.setAutobreaks(true);
        		}

            	this.wsList.put(sheetName, sheet);
            }
        }
        System.out.println(this.wsList.size() + " !");
    }
    
    /**
     * Retorna o atributo de um determinado node
     * @param node
     * @param attrib
     * @return
     */
    private String getAttribute(Node node, String attrib)  {
        Element element = (Element) node;
    	String result = element.getAttribute(attrib);
    	return result;
    }

    /**
     * Cria as celulas
     * @param doc
     */
    private void createCells(Document doc) {
        System.out.print("Read Cells... ");
        int totCell = 0;
        int totRow = 0;
        NodeList wsNList = doc.getElementsByTagName("Worksheet");
        for (int i = 0; i < wsNList.getLength(); i++) {
            Node node = wsNList.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) node;
                
                // le os nomes das tabs para criar os sheets
            	String sheetName = element.getAttribute("ss:Name");

            	if (sheetName == null) sheetName = "Tab" + i;
        		
            	Sheet sheet = (Sheet) this.wsList.get(sheetName);

                NodeList tbList = element.getElementsByTagName("Table").item(0).getChildNodes();
                for (int j = 0; j < tbList.getLength(); j++) {
                    Node tbNode = tbList.item(j);
                    if (tbNode.getNodeType() == Node.ELEMENT_NODE) {
                    	Element tbElement = (Element) tbNode;
                    	if (tbNode.getNodeName().equalsIgnoreCase("Column")) {
                    		int colIndex = Integer.parseInt(this.getAttribute(tbNode, "ss:Index")) - 1;
                    		String colAutoFit = this.getAttribute(tbNode, "ss:AutoFitWidth");
                    		String colWidth = this.getAttribute(tbNode, "ss:Width");

                    		if (colWidth != null && colWidth.length() > 0) {
                				sheet.setColumnWidth(colIndex, Integer.parseInt(colWidth) * 50);
                    		}
                    		if (colAutoFit != null && colAutoFit.length() > 0 && colAutoFit.equals("1")) {
                    			sheet.autoSizeColumn(colIndex);
                    		}
                    	}
                    	if (tbNode.getNodeName().equalsIgnoreCase("Row")) {
                    		int rowIndex = Integer.parseInt(this.getAttribute(tbNode, "ss:Index")) - 1;
                    		Row row = sheet.createRow(rowIndex);
                    		totRow++;
                            NodeList celList = tbElement.getElementsByTagName("Cell");
                            for (int k = 0; k < celList.getLength(); k++) {
                                Node celNode = celList.item(k);
                                if (celNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element celElement = (Element) celNode;
                            		int celIndex = Integer.parseInt(this.getAttribute(celNode, "ss:Index")) - 1;
                            		String celStyle = this.getAttribute(celNode, "ss:StyleID");
                            		String celMerge = this.getAttribute(celNode, "ss:MergeAcross");

                            		CellStyle cs = this.stList.get(celStyle);
                            	    
                            		Node data = celElement.getChildNodes().item(0);
                            		String dataType = this.getAttribute(data, "ss:Type").toLowerCase();
                            		String dataValue = celElement.getChildNodes().item(0).getTextContent();
                            		
                            		// ajusta o merge das celulas
                            		if (celMerge != null && celMerge.length() > 0) {
                            			CellRangeAddress cra = new CellRangeAddress(
                            					rowIndex, rowIndex, celIndex,
                            					celIndex + Integer.parseInt(celMerge));
                            			sheet.addMergedRegion(cra);
                            		}

                            		// cria a celula e atribui o valor
                            		Cell cell = row.createCell(celIndex);
                            		totCell++;
                            		cell.setCellStyle(cs);
                            		switch (dataType) {
                            			case "string":
                                    		cell.setCellValue(dataValue);
                                    		break;
                            			case "boolean":
                                    		cell.setCellValue(dataValue.equalsIgnoreCase("true"));
                                    		break;
                            			case "number":
                                       		cell.setCellValue(Double.parseDouble(dataValue));
                                    		break;
                            			case "datetime":
                            				LocalDateTime ldt = LocalDateTime.parse(dataValue);
                                       		cell.setCellValue(ldt);
                                    		break;
                            			case "date":
                            				SimpleDateFormat sdf = new SimpleDateFormat();
                            				Date dt;
                            				try {
                            					dt = sdf.parse(dataValue);
                            					cell.setCellValue(dt);
                            				} catch (ParseException e) {
                            					// se nao conseguir fazer o parser da data, assume como string
                            					cell.setCellValue(dataValue);
                            				}
                            				break;
                            		}
                                }
                            }
                    	}
                    }
                }
            }
        }
        System.out.println("rows " + totRow + " Cells " + totCell + " !");
    }
}

/*
<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:html="http://www.w3.org/TR/REC-html40">
   <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
      <Author></Author>
      <LastAuthor></LastAuthor>
      <LastPrinted>2005-10-18T09:43:42Z</LastPrinted>
      <Created>2005-10-18T09:41:43Z</Created>
      <Company>Totvs S.A.</Company>
      <Version>15.00</Version>
   </DocumentProperties>
   <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
      <DownloadComponents/>
      <LocationOfComponents HRef="/"/>
   </OfficeDocumentSettings>
   <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
      <WindowHeight>2970</WindowHeight>
      <WindowWidth>11340</WindowWidth>
      <WindowTopX>0</WindowTopX>
      <WindowTopY>0</WindowTopY>
      <ActiveSheet>0</ActiveSheet>
      <ProtectStructure>False</ProtectStructure>
      <ProtectWindows>False</ProtectWindows>
   </ExcelWorkbook>
   <Styles>
      <Style ss:ID="Default" ss:Name="Normal">
      <Alignment ss:Vertical="Bottom"/>
      <Borders/>
      <Font/>
      <Interior/>
      <NumberFormat/>
      <Protection/>
   </Style>
   <Style ss:ID="m21">
      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Font x:Family="Swiss" ss:Bold="1"/>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s21">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Font x:Family="Swiss" ss:Bold="1"/>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s25b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
      <NumberFormat ss:Format="######0.00"/>
   </Style>
   <Style ss:ID="s26">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <NumberFormat ss:Format="dd/mm/yy;@"/>
   </Style>   
   <Style ss:ID="s22">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s22b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s23">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s23b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s24">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s24b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s25">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s25b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s26">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s26b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s27">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s27b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s28">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s28b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   <Style ss:ID="s29">
      <Borders>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s29b">
      <Borders>
         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>
         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
      <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>
   </Style>
   <Style ss:ID="s30">
      <Borders>
         <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
      </Borders>
   </Style>
   </Styles>
   <Worksheet ss:Name="Tab1">
      <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="1048500" x:FullColumns="1" x:FullRows="1">
         <Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="60"/>
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="60"/>
         <Row ss:Index="2">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:StyleID="m21"><Data ss:Type="String">title1</Data></Cell>
         </Row>
         <Row ss:Index="3">
            <Cell ss:Index="1" ss:StyleID="s21"><Data ss:Type="String">c1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s21"><Data ss:Type="String">c2</Data></Cell>
         </Row>
         <Row ss:Index="4">
            <Cell ss:Index="1" ss:StyleID="s23"><Data ss:Type="String">1x1x1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String">1x1x2</Data></Cell>
         </Row>
         <Row ss:Index="5">
            <Cell ss:Index="1" ss:StyleID="s22b"><Data ss:Type="String">1x2x1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s24b"><Data ss:Type="String">1x2x2</Data></Cell>
         </Row>
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.4"/>
            <Footer x:Margin="0.4"/>
            <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"
                         x:Right="0.78740157499999996" x:Top="0.984251969"/>
         </PageSetup>
         <PageBreakZoom>100</PageBreakZoom>
         <Selected/>
      </WorksheetOptions>
   </Worksheet>
   <Worksheet ss:Name="Tab2">
      <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="1048500" x:FullColumns="1" x:FullRows="1">
         <Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="60"/>
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="60"/>
         <Row ss:Index="2">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:StyleID="m21"><Data ss:Type="String">title2</Data></Cell>
         </Row>
         <Row ss:Index="3">
            <Cell ss:Index="1" ss:StyleID="s21"><Data ss:Type="String">c1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s21"><Data ss:Type="String">c2</Data></Cell>
         </Row>
         <Row ss:Index="4">
            <Cell ss:Index="1" ss:StyleID="s27"><Data ss:Type="String">2x1x1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s29"><Data ss:Type="String">2x1x2</Data></Cell>
         </Row>
         <Row ss:Index="5">
            <Cell ss:Index="1" ss:StyleID="s26b"><Data ss:Type="String">2x2x1</Data></Cell>
            <Cell ss:Index="2" ss:StyleID="s28b"><Data ss:Type="String">2x2x2</Data></Cell>
         </Row>
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.4"/>
            <Footer x:Margin="0.4"/>
            <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"
                         x:Right="0.78740157499999996" x:Top="0.984251969"/>
         </PageSetup>
         <PageBreakZoom>100</PageBreakZoom>
      </WorksheetOptions>
   </Worksheet>
</Workbook>
*/

/* fim */
