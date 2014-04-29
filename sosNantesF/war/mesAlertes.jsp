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
<jsp:useBean id="diffusion" scope="application" class="beans.DiffusionBean"/>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

<%-- Checking if the user is logged in or not --%>	
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
boolean badEventCreationArgs = false;
if (user != null) {
	
	
	//retire une alerte et previent les personnes inscrites à la rue correspondant à l'alerte, ne peut être fait que par la personne ayant créé l'alerte ou un modo.
	if (request.getParameter("RetireAlerte") != null) {
		if(alerts.containsAlert(request.getParameter("sup"))){
			//if((alerts.getAlertById(request.getParameter("sup")).getUserMail()==user.getEmail())||(users.containsModo(user.getEmail()))){
			//if(alerts.getAlertById(request.getParameter("sup")).getUserMail()==currentUser.getMail()){
			if(users.containsModo(currentUser.getMail())||((alerts.getAlertById(request.getParameter("sup")).getUserMail()).equalsIgnoreCase(currentUser.getMail()))){
				for(String mail: diffusion.listeAbonne(alerts.getAlertById(request.getParameter("sup")).getNomRue())){
					Properties props = new Properties();
					Mailer newEvent = new Mailer(Session.getDefaultInstance(props, null),
					"Vous recevez ce message car vous êtes abonnées à la liste de diffusion de la rue . "+request.getParameter("adresse")+System.getProperty("line.separator")+
					"Une alerte vient d'être supprimé"+
					"=============================================================================="+System.getProperty("line.separator"),
					mail,
					mail,
					"Suppression d'alerte Sos.");
				}
				alerts.deleteAlert(request.getParameter("sup"));
			}
		}

	}
	

} else {	// Go back to the index if the user isn't logged in
response.sendRedirect(userService.createLogoutURL("/index.jsp"));
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
        		<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
        		<li><a href="/profil.jsp">Gerer mon profil</a></li>
        		<li><a href="APropos.jsp">A Propos</a></li>
        	<a type="button" style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
			</ul>

        </div><!--/.navbar-collapse -->
   </div>
</div>

<div class="container-fluid" id="contenuP">
	<div class="row">
	
			<div class="col-md-12">
			<h2>Liste de mes alertes</h2>
			<%int j=0; %>
			<%for(int i=0;i<alerts.getSize();i++){ %>
				<% if(j%4==0){%>
				<%j=1; %>
				<div class="row">
				<%} %>
				<% if(alerts.getAlert(i).getUserMail().equals(user.getEmail())){%>
				<%j=j+1; %>								
					<div class="col-md-4">
						<div class="thumbnail">
						
							<p><b>Nom :</b> <%=alerts.getAlert(i).getNom() %></p>
							<p><b>Date :</b> <%=alerts.getAlert(i).getDate()%></p>
							<p><b>Type :</b> <%=alerts.getAlert(i).getType()%></p>
							<p><b>Adresse :</b> <%=alerts.getAlert(i).getNumRue()%> <%=alerts.getAlert(i).getNomRue()%> <%=alerts.getAlert(i).getComplementAdresse()%> <%=alerts.getAlert(i).getCodePostal()%> <%=alerts.getAlert(i).getVille()%></p>
							<p><b>Description :</b> <%=alerts.getAlert(i).getDescription()%></p>
						    <form class="form-inline" method="post" action="/mesAlertes.jsp">
						    	<p class="btn btn-default">Approbations : <%=alerts.getAlert(i).getLike()%> </p>	
		    					<p class="btn btn-default">Désapprobations : <%=alerts.getAlert(i).getDislike()%>	</p>
								<input type="hidden" name="sup" value="<%=alerts.getAlert(i).getId()%>"/>
								<button type="submit" name="RetireAlerte" class="btn btn-danger">supprimer une alerte</button>
    						</form>
						</div>
					</div>
				<%if(j==4 || (1+i)==alerts.getSize()){ %>
				</div><% } %>
				<%} %>								
			<%} %>
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