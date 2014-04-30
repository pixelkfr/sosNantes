<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="classes.UserClass" %>
<%@ page import="classes.Mailer" %>
<%@ page import="classes.AlertClass" %>

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />
<jsp:useBean id="currentUser" scope="session" class="beans.UserBean" />
<jsp:useBean id="alerts" scope="application" class="beans.AlertsBean"/>
<jsp:useBean id="alert" scope="application" class="beans.AlertBean"/>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
<% String message=" "; %>
<%-- Checking if the user is logged in or not --%>	
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
boolean badEventCreationArgs = false;
if (user != null) {
	
	if (request.getParameter("like") != null) {
		if(!alerts.getAlertById(request.getParameter("id")).getUserMail().equals(user.getEmail())){
			alerts.like(request.getParameter("id"),user.getEmail());
		}
		else{
			message="Vous ne pouvez pas approuver l'une de vos alertes.";
		}
	}

	//-1
	if (request.getParameter("dislike") != null) {
		if(!alerts.getAlertById(request.getParameter("id")).getUserMail().equals(user.getEmail())){
			alerts.dislike(request.getParameter("id"),user.getEmail());
		}
		else{
			message="Vous ne pouvez pas désapprouver l'une de vos alertes.";
		}
	}

// Adding the user to the users list, and putting him in the session bean (if necessary)	
pageContext.setAttribute("user", user);
if (users.addUser(new UserClass(user.getEmail()))) {
Properties props = new Properties();
Mailer newEvent = new Mailer(Session.getDefaultInstance(props, null),
"Bienvenue sur le site. "+System.getProperty("line.separator")+"Vous voila à présent membre de SOS Nantes"+System.getProperty("line.separator")+"Abonnez vous à une rue pour en recevoir les actuallités",
user.getEmail(),
user.getEmail(),
"Inscription sur SOS Nantes!");
}
currentUser.setUser(users.getUser(user.getEmail()), user.getEmail());

// changer nom utilisateur
if (request.getParameter("change") != null) {
		//currentUser.setName("nom modifié");
		currentUser.setName(request.getParameter("change"));
}

//se desinscrire du site
if (request.getParameter("suppression") != null && request.getParameter("suppression").equals("true")) {
	users.removeUser(new UserClass(user.getEmail()));
	Properties props = new Properties();
	Mailer fullEvent = new Mailer(Session.getDefaultInstance(props, null),
	"vous venez de vous desinscrire !"+System.getProperty("line.separator")+
	"=============================================================================="+System.getProperty("line.separator")+
	"Fix My Str33t ",
	currentUser.getMail(),
	currentUser.getMail(),
	"a bientot");	
	response.sendRedirect(userService.createLogoutURL("/index.jsp"));
	
}

if (request.getParameter("mail") != null) {
	Properties props = new Properties();
	Mailer fullEvent = new Mailer(Session.getDefaultInstance(props, null),
	"Ceci est un mail utilisé pour tester les fonctionnalités de jsp!"+System.getProperty("line.separator")+
	"=============================================================================="+System.getProperty("line.separator")+
	"Fix My Str33t ",
	currentUser.getMail(),
	currentUser.getMail(),
	"une petite ligne de code pour les ataux");	
}
} else {	// Go back to the index if the user isn't logged in
	response.sendRedirect("/index.jsp");
}

%>

<html>
<head>
<!-- GESTION DE LA CARTE -->
	<script type="text/javascript">
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
<% for (int i=0;i<alerts.getSize();i++){ %>
			 var feature = new OpenLayers.Feature.Vector(
					new OpenLayers.Geometry.Point(<%=alerts.getAlert(i).getLon()%>,<%=alerts.getAlert(i).getLat()%>).transform(epsg4326, projectTo),
					{description:'<%= alerts.getAlert(i).getDescription() %>' , nom:'<%= alerts.getAlert(i).getNom() %>' , type:'<%= alerts.getAlert(i).getType() %>', adresse: '<%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%>' , date: '<%=alerts.getAlert(i).getDate()%>', approbations: '<%=alerts.getAlert(i).getLike()%>' , desapprobations: '<%=alerts.getAlert(i).getDislike()%>' , id: '<%=alerts.getAlert(i).getId()%>'} ,
					{externalGraphic: 'marqueur.png', graphicHeight: 70, graphicWidth: 50, graphicXOffset:-35, graphicYOffset:-70  }
				);    
			vectorLayer.addFeatures(feature);
<%}%>
   
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
          '<div class="markerContent" style="text-align:center;">'+feature.attributes.nom+'</br>'+feature.attributes.type+'</div>',
          null,
          true,
          function() { controls['selector'].unselectAll(); }
      );
      //feature.popup.closeOnMove = true;
      map.addPopup(feature.popup);
     
     document.getElementById('infoAlerte').innerHTML="<h2>Details sur l'alerte</h2><p><b>Nom :</b> "+feature.attributes.nom+"</p><p><b>Description :</b> "+feature.attributes.description+"</p><p><b>Type :</b> "+feature.attributes.type+"</p><p><b>Adresse :</b> "+feature.attributes.adresse+"</p><p><b>Date :</b> "+feature.attributes.date+"</p><p><b>Approbations : </b>"+feature.attributes.approbations+"</p><p><b>Désapprobations : </b>"+feature.attributes.desapprobations+"</p>";
     document.getElementById('infoAlerte2').innerHTML=('<form method="post" action="/map.jsp"><input  name="id" type="hidden" value="'+feature.attributes.id+'" /><button type="submit" name="like" class="btn btn-success">Approuver</button>  <button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button></form>');
    }

    function destroyPopup(feature) {
      feature.popup.destroy();
      feature.popup = null;
    }
    
    map.addControl(controls['selector']);
    controls['selector'].activate();
      
	  }
	</script>

<link rel="stylesheet" type="text/css" href="perso.css" />
    <script src="OpenLayers.js"></script>
   
<title>SOS Nantes - Carte</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
</head>

<body onload="document.getElementById('basicMap').style.height='90%';init();">

 <div class="navbar navbar-inverse navbar-fixed-top" >
    <div class="container">
        <div class="navbar-header">
          <button type="button" style="margin-top: 8px;" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.jsp"><img src="img/logo.png" style="margin-top: -8px;"/></a>
        </div>
        <div class="navbar-collapse collapse">
        	 <ul class="nav navbar-nav navbar-right">
        		<li><a href="/mesAlertes.jsp">Mes Alertes</a></li>
        		<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
        		<li><a href="/profil.jsp">Gerer mon profil</a></li>
        		<li><a href="/APropos.jsp">A Propos</a></li>
        	<a type="button" style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>	
			</ul>

        </div><!--/.navbar-collapse -->
   </div>
</div>

<div class="container-fluid" id="contenuP">
	<div class="row">

		<div class="col-md-9">	
       		 <div id="basicMap"></div>	
		</div>
		
		<div class="col-md-3">
	     	<form>
	     		<div class="form-group">
	     			 <a class="btn btn-primary btn-lg btn-block" href="listeAlertes.jsp">Voir la liste des alertes</a>
	     		</div>
			</form>
			<div class="avertissement"><%= message %></div>
			<div id="infoAlerte">
				<p>Selectionnez une alerte sur la carte pour plus d'informations sur celle-ci.</p>
			</div>
			<div id="infoAlerte2">
				
				<h2>Dernières alertes</h2>
				<% if(alerts.getSize()==0){
					%>
					<p>Il n'y a pas d'alertes récentes.</p>
				<% 
				}
				else if(alerts.getSize()==1){ int i=0;
						%>
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/map.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
						<%
					}
				else if(alerts.getSize()==2){ int i=0; int j=1; 
					%>
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/map.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
	    					
							<p><b>Nom :</b> <%=alerts.getAlert(j).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(j).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(j).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(j).getNumRue()%> <%=alerts.getAlert(j).getNomRue()%> <%=alerts.getAlert(j).getComplementAdresse()%> <%=alerts.getAlert(j).getCodePostal()%> <%=alerts.getAlert(j).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(j).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/map.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(j).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(j).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(j).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(j).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
					
					<%
					}
				
					else{
						
						for(int i=(alerts.getSize())-3;i<alerts.getSize();i++){ %>
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/map.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
						<%  }
						
					}
				
				
				%>
				
				
				
			</div>
 		</div>
 		
	</div>

	 <footer>
	 <div class="f">
        <p>&copy; Daureu Marie-Charlotte, Auffret Davy 2014</p>
     </div>
      </footer>  
</div> <!-- fin container -->

        <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>

</body>
</html>