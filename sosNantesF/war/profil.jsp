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
<% String message=" "; %>
<%-- Checking if the user is logged in or not --%>	
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
boolean badEventCreationArgs = false;
if (user != null) {

// changer nom utilisateur
if (request.getParameter("change") != null) {
		//currentUser.setName("nom modifié");
		currentUser.setName(request.getParameter("change"));
}

//se desinscrire du site
if (request.getParameter("suppression") != null) {
	diffusion.removeUser(user.getEmail());
	users.removeUser(user.getEmail());
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

if (request.getParameter("abonneRue") != null) {
	diffusion.inscriptionRue(request.getParameter("rueA"), user.getEmail());
}


if (request.getParameter("desabonneRue") != null) {
	diffusion.desabonneRue(request.getParameter("rueD"), user.getEmail());
}

}

else {	// Go back to the index if the user isn't logged in
response.sendRedirect(userService.createLogoutURL("/index.jsp"));
}

%>

<html>
<head>
<link href="perso.css" rel="stylesheet">
<title>SOS Nantes - Mon Profil</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
</head>

<body>

 <div class="navbar navbar-inverse navbar-fixed-top" >
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
        		<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
        		<li><a href="APropos.jsp">A Propos</a></li>
        		<a type="button" style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
			</ul>

        </div><!--/.navbar-collapse -->
   </div>
</div>

<div class="container-fluid" id="contenuP">
	  <div class="avertissement"><%= message %></div>
	  <div class="row">
	  		<div class="col-md-1">
	  		</div>
  			<div class="col-md-3">
  				<h2>Mon Profil : <% out.print(currentUser.getName());%></h2>
  				<p><img src="img/slide3.jpg"/></p>	
				<form method="post" class="form-inline" action="/profil.jsp">
			    <input type="text" class="form-control" placeholder="Nouveau pseudo" name="change"/>
			    <button type="submit" class="btn btn-info">Changer le pseudo</button>
			    </form>
			    <form class="post" method="post" action="/profil.jsp">
			  	<input type="hidden" name="suppression"/>
			    <button type="submit" name="suppression" class="btn btn-danger">Supprimer mon profil</button>
				</form>
  			</div>
  			<div class="col-md-3">
  				<h2>Gestion de mes abonnements</h2></br>
			    <form method="post" class="form-inline" action="/profil.jsp">
				</b><input type="text" class="form-control" placeholder="Entrer un nom de rue" name="rueA"/>
				<button type="submit" name="abonneRue" class="btn btn-info">M'abonner à une rue</button>
			    </form>
			    </br>
			   <form method="post" class="form-inline" action="/profil.jsp">
				</b><input type="text" class="form-control" placeholder="Entrer un nom de rue" name="rueD"/>
				<button type="submit" name="desabonneRue" class="btn btn-info">Me désabonner d'une rue</button>
			    </form>
			    </br>
			    <p>Attention, si vous effectuez des actions mais qu'aucun changement ne se passe dans la liste ci contre, c'est que le nom de rue entré n'est pas correct.</p>
			 </div>
			 <div class="col-md-4">
  				<h2>Vous suivez actuellement les rues suivantes :</h2>

				<% Integer v=diffusion.mesAbonnements(user.getEmail()).size();Integer i=0;%>
					<%for(String s: diffusion.mesAbonnements(user.getEmail())){ %>			
						<% if(i%3==0){%>
								<div class="row">
						<%} %>						
					<div class="col-md-4">
						<div class="thumbnail">
							<P><%= s %></P>
						</div>
					</div>
				<%i=i+1;if(i%3==0 || (i)==v){ %>
				</div><% } %>
				<%} %>								
  			</div>
  			<div class="col-md-1">
	  		</div>
	</div>
	  
	
     
     

</div> <!-- fin container -->

	   <footer>
	   <div class="f">
        <p>&copy; Daureu Marie-Charlotte, Auffret Davy 2014</p>
    	</div>
      </footer>     
        <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>

</body>
</html>