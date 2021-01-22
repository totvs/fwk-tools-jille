package com.totvs.framework;

import java.util.Properties;

import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;
import javax.servlet.ServletRegistration;

import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.ws.transport.http.MessageDispatcherServlet;

import com.totvs.framework.properties.ContextProperty;
import com.totvs.framework.properties.TOTVSProperties;
import com.totvs.framework.properties.TOTVSProperty;
import com.totvs.sso.SSOFilter;

/**
 * Inicializa o framework WEB do Spring utilizando o arquivo
 * "WEB-INF/spring-config.xml".
 * 
 * @author roger.steuernagel
 */
public class WebAppInitializer implements WebApplicationInitializer {
	
	/**
	 * Configura o framework WEB e adiciona o servlet do Spring
	 * 
	 * @param container O contexto WEB da aplicação
	 */
	@Override
	public void onStartup(ServletContext container) {

		AnnotationConfigWebApplicationContext appContext = new AnnotationConfigWebApplicationContext();
	    appContext.register(AppConfig.class);
		ServletRegistration.Dynamic rest = container.addServlet("totvs-poi", new DispatcherServlet(appContext));
		rest.setLoadOnStartup(1);
		rest.addMapping("/*");

		ConfigurableEnvironment env = appContext.getEnvironment();
		
		Properties ctxProps = new Properties();
		for(ContextProperty ctxProp : ContextProperty.values()){
			String propValue = (String) env.getProperty(ctxProp.toString());
			if (propValue != null && propValue.toString().length() > 0) {
				ctxProps.put(ctxProp.toString(), propValue);
			}
		}
		
		try {
			TOTVSProperties totvsProperties = new TOTVSProperties(env);
			String appServerURL = env.getProperty(TOTVSProperty.APPSERVER.toString());
			if (appServerURL != null) {
				// 1- Propriedades do banco de dados devem sobrepor qualquer insercao de prop do arquivo .xml,
				// exceto as prop do item 2
				env.getPropertySources().addFirst(totvsProperties);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 2- Propriedades especificas do contexto deve ter prioridade sobre do banco de dados
		env.getPropertySources().addFirst(new PropertiesPropertySource("ContextProperties", ctxProps));
		
		// 3- Remove as propriedades 'adicionais' do arquivo que nao estao na lista do 'ContextProperty'
		env.getPropertySources().remove("jndiProperties");
		
		container.setAttribute("Environment", appContext.getEnvironment());
	}
}