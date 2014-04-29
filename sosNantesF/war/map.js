
	  function init() {

		
			map = new OpenLayers.Map({
				div: "basicMap",
				controls: [
					new OpenLayers.Control.TouchNavigation({
						dragPanOptions: {
							enableKinetic: true
						}
					}),
					new OpenLayers.Control.Zoom(),
					new OpenLayers.Control.Navigation({mouseWheelOptions: {interval: 400}})],
				fractionalZoom: true
			});
			map.addLayer(new OpenLayers.Layer.OSM());
		 
			// coordonnées
			var lonLat = new OpenLayers.LonLat(-1.5533581,47.2183506).transform(
					new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
					map.getProjectionObject() // to Spherical Mercator Projection
				  );
			// zoom
			var zoom=13;
			//center aux coordonnées avec le zoom
			map.setCenter (lonLat, zoom);
			
			
			var vectorLayer = new OpenLayers.Layer.Vector("Overlay");


			map.addControls([
			new OpenLayers.Control.PanPanel(),
			new OpenLayers.Control.ZoomPanel()/*,
					new OpenLayers.Control.Navigation(),
					new OpenLayers.Control.PanZoomBar(null, null, 100, 50)*/
			]);
			
			
			
			epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
			projectTo = map.getProjectionObject(); //The map projection (Spherical Mercator)
			
			
			// ajouter des markers sur la carte
			// modifier logo de l'image et dimensions
			 var feature = new OpenLayers.Feature.Vector(
					new OpenLayers.Geometry.Point(-1.561259,47.239074).transform(epsg4326, projectTo),
					{description:'<center>Probl&egrave;me de signalisation<br><i>Bd Gabriel Lauriol</i></center>'} ,
					{externalGraphic: 'img/marker.png', graphicHeight: 70, graphicWidth: 70, graphicXOffset:-35, graphicYOffset:-70  }
				);    
			vectorLayer.addFeatures(feature);
			
			var feature = new OpenLayers.Feature.Vector(
					new OpenLayers.Geometry.Point(-1.5533581,47.2183506).transform(epsg4326, projectTo),
					{description:'This is the value of<br>the description attribute'} ,
					{externalGraphic: 'img/marker3.png', graphicHeight: 70, graphicWidth: 70, graphicXOffset:-35, graphicYOffset:-70  }
				);    
			vectorLayer.addFeatures(feature);



   
    map.addLayer(vectorLayer);
 
    // gestion de l'ouverture fermeture des popups
    //Add a selector control to the vectorLayer with popup functions
    var controls = {
      selector: new OpenLayers.Control.SelectFeature(vectorLayer, { onSelect: createPopup, onUnselect: destroyPopup })
    };

    function createPopup(feature) {
      feature.popup = new OpenLayers.Popup.FramedCloud("pop",
          feature.geometry.getBounds().getCenterLonLat(),
          null,
          '<div class="markerContent">'+feature.attributes.description+'</div>',
          null,
          true,
          function() { controls['selector'].unselectAll(); }
      );
      //feature.popup.closeOnMove = true;
      map.addPopup(feature.popup);
    }

    function destroyPopup(feature) {
      feature.popup.destroy();
      feature.popup = null;
    }
    
    map.addControl(controls['selector']);
    controls['selector'].activate();
      
	  }