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

<title>SOS Nantes - A Propos</title>
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
          <a class="navbar-brand" href="index.jsp"><img src="img/logo.png" style="margin-top:-8px;" /></a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
					<%
					UserService userService = UserServiceFactory.getUserService();
					User user = userService.getCurrentUser();
					%>	
					<% if (user == null) { %>
					<li><a href="index.jsp">Retourner à l'accueil</a></li>
					<a type="button" style="margin-top: 8px;" class="btn btn-primary" href="<%= userService.createLoginURL("/map.jsp") %>">Se connecter</a>
						
					<% }
					else { %>
					<li><a href="/map.jsp">Retourner à la carte</a></li>
					<li><a href="/mesAlertes.jsp">Mes Alertes</a></li>
					        		<li><a href="/addAlert.jsp">Ajouter une alerte</a></li>
					        		<li><a href="/profil.jsp">Gerer mon profil</a></li>
					<a type="button" style="margin-top: 8px;" class="btn btn-warning" href="<%= userService.createLogoutURL("/index.jsp") %>">Se déconnecter</a>
					<% } %>
			</ul>
        </div><!--/.navbar-collapse -->
      </div>
    </div>
    

<div class="container" id="contenuP">
	<h1>A Propos</h1>
			<p>SOS Nantes est une application web réalisée dans le cadre du cours d'application web du Master ATAL de l'université de Nantes.</p>
			<p>Cette application a pour but de pouvoir signaler des incidents ayant lieu sur Nantes et ses alentours, afin de pouvoir remonter les informations aux institutions compétentes et d'avertir les habitants qui le souhaitent par mail.</p>
			<p>Auteurs de l'application : DAUREU Marie-Charlotte et AUFFRET Davy, Intervenant de cours : Pascal Molli</p>
			<p>Le code source de cette application est disponible sur <a href="https://github.com/tilwing/sosNantes">Github</a>.</p>
	
	<h2>Pourquoi utiliser ce site ?</h2>
			<p>Des incidents se rencontrent à Nantes, mais ne sont pas toujours réglés rapidement par les autorités compétentes (dégradation sur un mur de votre rue, déchets aux pieds de votre immeuble, panneau de signalisation sur la chaussée..).</p>
			<p>Ce site a pour but d'avertir ces institutions compétentes afin que les problèmes soient résolus. Les utilisateurs de ce site peuvent s'abonner aux rues afin d'être avertis en cas de problème.</p>
	
	<h2>Comment utiliser ce site ?</h2>
			<p>Connectez-vous simplement avec votre compte Google pour commencer.</p>
			<p>Ajoutez des alertes, modifiez vos préférences dans le profil, ou observez les alertes des autres utilisateurs en navigant simplement aux travers des menus !</p>
	
	<h2>Que puis-je faire précisément sur ce site ?</h2>
			<p>- Signaler un incident dans Nantes dans l'onglet "ajouter une alerte".</p>
			<p>- Visionner toutes les alertes des utilisateurs sur une carte ou dans une liste, en les filtrant par rue ou par type.</p>
			<p>- Donner votre avis sur la pertinence des alertes des autres utilisateurs pour plus de fiabilité, en cliquant sur les boutons d'approbations.</p>
			<p>- Supprimer vos alertes une fois résolues.</p>
			<p>- S'abonner à vos rues préférées afin d'être signalé dès qu'un incident est déclaré.</p>
			<p>- A tout moment vous pouvez supprimer votre compte si l'envie de nous quitter vous en prend. Cela supprimera votre adresse des listes de diffusions pour les abonnements aux rues.</p>

	<h2>A venir prochainement :</h2>
		<p>- La possibilité d'ajouter des photos de vos alertes.</p>
		<p>- La possibilité d'ajouter des commentaires aux alertes.</p>
		<p>- La possibilité d'ajouter une photo de profil utilisateur.</p>
		<p>- L'ajout d'un tchat utilisateur et d'un forum afin de pouvoir mieux connaître la communauté du site.</p>
	
	<h2>Signaler un problème :</h2>
	<p>Il est possible de rencontrer quelques erreurs au sein de cette application, ou bien de penser que des fonctionnalités sont manquantes.</p>
	<p>Pour ceci, merci de contacter un administrateur afin d'améliorer les versions suivantes.</p>
	<p  class="btn btn-default"><a href="mailto:micha.daureu@gmail.com">Envoyer un message !</a></p>
	
	<h2>Coté programmation...</h2>
	
	<h4>Fonctionnalités entièrement implémentées</h4>

   <p>-  Inscription sur le site par une adresse gmail.</p>
   <p>-  Modification du pseudo utilisateur.</p>
   <p>-  Désinscription du site et des listes de diffusion.</p>
   <p>-  Ajout d'alertes et suppressions de ses alertes uniquement.</p>
   <p>- Inscription/désinscription à des rues.</p>
   <p>- Affichage des informations sur une alerte par un simple clic sur la carte.</p>
   <p>- Affichage des alertes en liste, et filtrage possible par nom de rue et par type d'alerte</p>
   <p>-  Envoi de mails dans les cas suivants: Inscription/désinscription sur le site, abonnement à une rue, ajout d'une alerte dans une rue suivie, suppression d'une alerte dans une rue suivie, désinscription du site.</p>

<h4>Fonctionnalités partiellement implémentées</h4>

    Complétion automatique pour les adresses.

<h4>Fonctionnalités non implémentées</h4>

    <p>- Possibilité d'ajout d'images pour les alertes.</p>
	
</div>

	 <footer>
	 	<div class="f">
        <p>&copy; Daureu Marie-Charlotte, Auffret Davy 2014 - Code source : <a href="https://github.com/tilwing/sosNantes">Github</a></p>
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