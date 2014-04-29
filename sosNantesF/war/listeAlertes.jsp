<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
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

	
if (request.getParameter("rue") != null) {
	String s="/listeAlertes.jsp?mode=rue&val="+request.getParameter("choixcarte");
	response.sendRedirect(s);
}

if (request.getParameter("type") != null) {
	String s="/listeAlertes.jsp?mode=type&val="+request.getParameter("choixcarte");
	response.sendRedirect(s);
}
} else {	// Go back to the index if the user isn't logged in
response.sendRedirect("/mapNonConnecte.jsp");
}

%>

<html>
<head>
<link rel="stylesheet" type="text/css" href="perso.css" />
<title>SOS Nantes - Liste Alertes</title>
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
        		<li><a href="/MesAlertes.jsp">Mes Alertes</a></li>
        		<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
        		<li><a href="/profil.jsp">Gerer mon profil</a></li>
        		<li><a href="APropos.jsp">A Propos</a></li>
        	<a type="button" style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
			</ul>

        </div><!--/.navbar-collapse -->
   </div>
</div>
						

<div class="container-fluid" id="contenuP">
<div class="avertissement"><%= message %></div>
	<div class="row">
<% String vars=request.getQueryString(); %>	  
<% String mode=""; %>
<% String val=""; %>	   		 						
   		 			<!-- Recuperation et formatage des modes de filtrage<à partir de l'adresse -->			
<% if(!(vars==null)){%>
	<% vars=vars.replace('&', ' '); %>
	<% vars=vars.replace("mode=",""); %>
	<% vars=vars.replace("val=",""); %>
	<% vars=vars.replace("%20"," "); %>
	<% mode= vars.substring(0, vars.indexOf(" ")); %>
	<% val= vars.substring(vars.indexOf(" ")+1, vars.length()); %>
<%} %>	
			<div class="col-md-9">
			<h2>Liste des alertes</h2>
			
			<%int j=0; %>	     	
<% if(mode.equals("rue")){%>   
		<h2><%=val.replace("%20", " ")%></h2>
			<%for(int i=0;i<alerts.getSize();i++){ %>			
				<% if(j%4==0){%>
				<%j=1; %>
				<div class="row">
				<%} %>
				<%if(alerts.getAlert(i).getNomRue().equals(val)){;%>			
				<%j=j+1; %>								
				<!--******************* Affichage des alertes en liste *************************-->
					<div class="col-md-4">
						<div class="thumbnail">
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/listeAlertes.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
						</div>
					</div>
					<!--******************** Fin - Affichage des alertes en liste *********************-->
				<%if(j==4 || (1+i)==alerts.getSize()){ %>
				</div><% } %>
				<%} %>								
			<%} %>
<%} %>	
<%if(mode==""){%> 
			<%for(int i=0;i<alerts.getSize();i++){ %>
				<% if(i%3==0){%>
				<div class="row"><%} %>				
					<div class="col-md-4">
						<div class="thumbnail">						
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/listeAlertes.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
						</div>
					</div>
				<%if((i+1)%3==0 || (1+i)==alerts.getSize()){ %>
				</div><% } %>				
			<%} %>
<%} %>
<%if(mode.equals("type")){%> 
			<%for(int i=0;i<alerts.getSize();i++){ %>			
				<% if(j%4==0){%>
				<%j=1; %>
				<div class="row">
				<%} %>
				<%if(alerts.getAlert(i).getType().equals(val)){;%>			
				<%j=j+1; %>								
					<div class="col-md-4">
						<div class="thumbnail">
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
							<div class="form-inline">
								<form method="post" action="/listeAlertes.jsp">					
								<p class="btn btn-default"><%=alerts.getAlert(i).getLike()%> </p>	
								<input  name="id"  type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="like" class="btn btn-success">Approuver</button>

		    					<p class="btn btn-default"><%=alerts.getAlert(i).getDislike()%>	</p>
								<input  name="id" type="hidden" value="<%=alerts.getAlert(i).getId()%>" />
								<button type="submit" name="dislike" class="btn btn-warning">Désapprouver</button>
		    					</form>
	    					</div>
					</div>
					</div>
				<%if(j==4 || (1+i)==alerts.getSize()){ %>
				</div><% } %>
				<%} %>								
			<%} %>
<%} %>	
			</div>


	

	
		<div class="col-md-3">
  			<div class="form-group">
	     		 <a class="btn btn-primary btn-lg btn-block" href="map.jsp">Voir la carte des alertes</a>	
	     		 
	     		     		 					     		 						     		 					
	     	</div>
	     	<h2>Filtrer les alertes</h2>
	     	<div class="form-group">
		     	<div class="form-inline">
			     	<form method="post" action="/listeAlertes.jsp">
						<input name="choixcarte" class="form-control" type="text" placeholder="Entrer une rue"></input>
						<button class="btn btn-default" name="rue" type="submit">Filtrer par rue</button>
	    			</form>				    
				</div>
			</div>
			<div class="form-group">
		     	<div class="form-inline">
					<form method="post" action="/listeAlertes.jsp">
						<select class="form-control" required name="choixcarte">
						  <option>Degradation</option>
						  <option>Dechets</option>
						  <option>Danger</option>
						  <option>Animaux</option>
						  <option>Voiture</option>
						</select>
						<button class="btn btn-default" name="type" type="submit">Filtrer par type</button>
	    			</form>
    			</div>
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