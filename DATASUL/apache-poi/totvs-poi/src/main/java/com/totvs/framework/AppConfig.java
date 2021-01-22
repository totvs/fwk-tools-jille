package com.totvs.framework;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
 
@Configuration
@ComponentScan(basePackages = "com.totvs.framework")
public class AppConfig {

	@Bean(name = "multipartResolver")
	public CommonsMultipartResolver createMultipartResolver() {
	    CommonsMultipartResolver resolver=new CommonsMultipartResolver();
	    resolver.setMaxUploadSizePerFile(-1);
	    return resolver;
	}
}