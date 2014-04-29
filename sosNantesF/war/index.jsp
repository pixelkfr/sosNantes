<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<jsp:useBean id="alerts" scope="application" class="beans.AlertsBean"/>
<jsp:useBean id="alert" scope="application" class="beans.AlertBean"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="bootstrap/ico/favicon.ico">

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
	<link rel="stylesheet" type="text/css" href="perso.css" />

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="bootstrap/js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

<title>SOS Nantes - Accueil</title>
</head>
<body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.jsp"><img src="img/logo.png" style="margin-top: -8px;"/></a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
					<%
					UserService userService = UserServiceFactory.getUserService();
					User user = userService.getCurrentUser();
					%>	
					<% if (user == null) { %>
						<li><a href="APropos.jsp">A Propos</a></li>
						<a style="margin-top: 8px;" type="button" class="btn btn-primary" href="<%= userService.createLoginURL("/map.jsp") %>">Se connecter</a>
					<% }
					else { %>
					<li><a href="/map.jsp">Retourner à la carte</a></li>
					<li><a href="/mesAlertes.jsp">Mes Alertes</a></li>
					<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
					<li><a href="/profil.jsp">Gerer mon profil</a></li>
					<li><a href="APropos.jsp">A Propos</a></li>
					
					<a style="margin-top: 8px;" type="button" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
					<% } %>
			</ul>
        </div><!--/.navbar-collapse -->
      </div>
    </div>
    
     <!-- Carousel
    ================================================== -->
    <div id="myCarousel" class="carousel slide" data-ride="carousel">
      <!-- Indicators -->
      <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
        <div class="item active">
          <img  alt="First slide">
          <div class="container">
            <div class="carousel-caption">
            	<h1>Bienvenue sur le site <img src="img/logo.png"/></h1>
              <p>Un problème dans votre rue ? Une dégradation dans votre quartier, un arbre tombé sur la chaussée ? Prévenez rapidement les institutions compétentes en déclarant votre problème sur ce site !</p>
            </div>
          </div>
        </div>
        <div class="item">
          <img data-src="holder.js/900x500/auto/#666:#6a6a6a/text:Second slide" alt="Second slide">
          <div class="container">
            <div class="carousel-caption">
            
            	<div class="row">
				  <div class="col-md-6"><h1>Alertez-nous !</h1>
			     <p>Connectez-vous simplement avec votre compte Google pour commencer et signalez-nous des problèmes rencontré sur Nantes.</p></div>
				  <div class="col-md-6"><img src="img/slide2.jpg"/></div>
				</div>
                
            </div>
          </div>
        </div>
        <div class="item">
          <img  alt="Third slide">
          <div class="container">
            <div class="carousel-caption">
             	<h1><img src="img/logo.png"/></h1>
             	<p>Une solution à apporter pour tous vos problèmes de quartier.</p></br>
             	<button type="button" href="APropos.jsp" class="btn btn-info">Plus d'informations</button>
            </div>
          </div>
        </div>
      </div>
      <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
      <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
    </div><!-- /.carousel -->

    <div class="container-fluid">
      			<div class="row">
		      				<div class="col-md-2"></div>
						  <div class="col-md-5"><img src="img/slide1.jpg" style="max-width:100%;"/></div>
						  <div class="col-md-3">		
						  		<h1>SOS Nantes</h1>
						  		<p><i>Une solution à apporter à vos problèmes de quartier.</i></p>
						  		<h2>Pourquoi utiliser ce site ?</h2>
						  		<p>- Alerter la communauté d'incidents sur Nantes !</p>
						  		<p>- Suivre les alertes de vos rues préférées directement par mail.</p>
						  		<p>- Donner votre avis sur la pertinence des alertes des autres utilisateurs.</p>
						  		<p>- Et bien d'autres choses encore, n'attendez plus !</p>
						  		<h3>Connectez vous pour commencer !</h3>
						  </div>
						  <div class="col-md-2"></div>
				</div>
    </div>

	 <footer>
	 <div class="f">
		 <p>Pour en savoir plus sur l'application et ses fonctionnalités, veuillez lire la section <a href="APropos.jsp">A Propos</a> de ce site.</p>
        <p>&copy; Daureu Marie-Charlotte, Auffret Davy 2014.</p>
      </div>
      </footer>  
    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>

</body>
</html>