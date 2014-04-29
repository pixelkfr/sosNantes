<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Date" %>
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
<%@ page import="classes.AlertClass" %>
<%@ page import="classes.UserClass" %>
<%@ page import="classes.Mailer" %>

<jsp:useBean id="users" scope="application" class="beans.UsersBean" />
<jsp:useBean id="currentUser" scope="session" class="beans.UserBean" />
<jsp:useBean id="alerts" scope="application" class="beans.AlertsBean"/>
<jsp:useBean id="alert" scope="application" class="beans.AlertBean"/>
<jsp:useBean id="diffusion" scope="application" class="beans.DiffusionBean"/>
<% String message=" "; %>
    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

<%-- Checking if the user is logged in or not --%>	
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
boolean badEventCreationArgs = false;
if (user != null) {

	pageContext.setAttribute("user", user);

	if (request.getParameter("signaler") != null) {
		//if(diffusion.getListeRue().contains(request.getParameter("nomRue"))){
		if(alerts.isCode(request.getParameter("codePostal"))){

			java.util.Date now = new java.util.Date();
			java.sql.Date dat = new java.sql.Date(now.getTime());
			String date =dat.toString();
			if(alerts.addAlert(alerts.newId(),userService.getCurrentUser().getEmail(),request.getParameter("nom"),request.getParameter("numRue"),request.getParameter("nomRue"),request.getParameter("complementAdresse"),request.getParameter("codePostal"),request.getParameter("ville"),request.getParameter("lat"),request.getParameter("lon"),request.getParameter("description"),request.getParameter("type"),date)){
				
				  for(String mail: diffusion.listeAbonne(request.getParameter("nomRue"))){
                      Properties props = new Properties();
                      Mailer newEvent = new Mailer(Session.getDefaultInstance(props, null),
                      "Vous recevez ce message car vous êtes abonnées à la liste de diffusion de la rue ."+request.getParameter("adresse")+System.getProperty("line.separator")+
                      "Une nouvelle alerte est arrivée"+
                      "=============================================================================="+System.getProperty("line.separator"),
                      mail,
                      mail,
                      "Suppression d'alerte Sos.");
              }
				
				
				
				response.sendRedirect("/map.jsp");
			}
			else{
				message="Les informations entrées sont invalides. Veuillez vérifier vos coordonnées. </br> Si l'erreur persiste, merci de contacter un administrateur dans la page A Propos."; 
			}
		}
			else{
				message="Les informations entrées sont invalides. Veuillez vérifier le code postal entré. </br> Si l'erreur persiste, merci de contacter un administrateur dans la page A Propos."; 
			}
		
		}

		}
		/*
		else{
			 message="Le nom de rue est innexistant dans la base de donnée. Veuillez vérifier votre entrée. </br> Si l'erreur persiste, merci de contacter un administrateur dans la page A Propos."; 
		}*/
/*	if(users.containsModo(currentUser.getUser())){
		
	}*/


else {	// Go back to the index if the user isn't logged in
response.sendRedirect(userService.createLogoutURL("/index.jsp"));
}

%>

<html>
<head>
<link rel="stylesheet" type="text/css" href="perso.css" />
<title>Ajouter une alerte</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
</head>

<body>

 <div class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.jsp"><img src="img/logo.png" style="margin-top: -8px;"/></a>
        </div>
        <div class="navbar-collapse collapse">
        	 <ul class="nav navbar-nav navbar-right">
        		<li><a href="/map.jsp">Retourner à la carte</a></li>
        		<li><a href="/mesAlertes.jsp">Mes Alertes</a></li>
        		<li><a href="/profil.jsp">Gerer mon profil</a></li>
        		<li><a href="APropos.jsp">A Propos</a></li>
       <a type="button"  style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
			</ul>

        </div><!--/.navbar-collapse -->
   </div>
</div>

<div class="container">
	<div class="contentAddAlert">
<div class="avertissement"><%= message %></div>
    <form class="form-horizontal" method="post" action="/addAlert.jsp">
    	<div class="row">
    	<h2>Ajouter une alerte</h2>
    		<div class="col-md-5">
    			 <div class="form-group">
    			 		Nom de l'alerte :<br/>
						<input type="text" class="form-control" required name="nom" placeholder="nom"/><br/>
						Description de l'alerte :
						<textarea class="form-control" name="description" rows="3"></textarea><br/>
						Type d'alerte :
						<select class="form-control" required name="type">
						  <option>Degradation</option>
						  <option>Dechets</option>
						  <option>Danger</option>
						  <option>Animaux</option>
						  <option>Voiture</option>
						</select>
						<br/>Coordonnées :<br/>
						<input type="text" required class="form-control" name="lon" placeholder="longitude, ex : -1.567145"/><br/>
						<input type="text" required class="form-control" name="lat" placeholder="latitude, ex : 47.246799"/><br/>
					</div>
			</div>
			<div class="col-md-2"></div>
			<div class="col-md-5">
				<div class="form-group">
						Adresse :<br/>
						<input type="text" required class="form-control" name="numRue" placeholder="numero de rue"/><br/>
						<input type="text" required class="form-control" name="nomRue" placeholder="nom de rue"/><br/>			
						<input type="text" class="form-control" name="complementAdresse" placeholder="complément d'adresse"/><br/>
						<input type="text" required class="form-control" name="codePostal" placeholder="code postal"/><br/>
						<input type="text" required class="form-control" name="ville" placeholder="ville"/><br/>
						
   				 </div>
   				 <button type="submit" class="btn btn-success" name="signaler">Signaler</button>
			</div>
			
		</div>
    </form>
    
      <footer>
      <div class="f">
        <p>&copy; Daureu Marie-Charlotte, Auffret Davy 2014</p>
      </div>
      </footer>
      
      </div>
    </div> <!-- /container -->
 
</body>

</html>