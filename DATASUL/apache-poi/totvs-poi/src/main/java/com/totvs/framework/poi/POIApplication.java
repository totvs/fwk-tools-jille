package com.totvs.framework.poi;

import javax.ws.rs.ApplicationPath;

import org.glassfish.jersey.CommonProperties;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.wadl.WadlFeature;

@ApplicationPath("/")
public class POIApplication extends ResourceConfig {

	public POIApplication() {
		register(WadlFeature.class);
		register(JacksonFeature.class);
		register(MultiPartFeature.class);
		property(CommonProperties.FEATURE_AUTO_DISCOVERY_DISABLE, true);
	}
}
