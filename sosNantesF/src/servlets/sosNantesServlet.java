package servlets;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.*;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.*;
import javax.mail.*;
import javax.mail.internet.*;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class sosNantesServlet extends HttpServlet {
	
	  static {
	        ObjectifyService.register(beans.AlertBean.class); // Fait connaître votre classe-entité à Objectify
	        ObjectifyService.register(beans.AlertsBean.class); // Fait connaître votre classe-entité à Objectify
	        ObjectifyService.register(classes.AlertClass.class); 
	        ObjectifyService.register(classes.UserClass.class); 
	    }
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
					
		    UserService userService = UserServiceFactory.getUserService();
	        User user = userService.getCurrentUser();
	        
	        //SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
			//Initialisation de la date J
			String dateJour = formatter.format(new Date());
			//ajout de l'heure
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
			String texte_date = sdf.format(new Date());
			dateJour+= " "+texte_date;

	        
	        // Si le membre est connecté (compte google)
	        if (user != null) {
	          // Si il s'agit de sa première connexion	        
	          if(ofy().load().type(classes.UserClass.class).filter("id",user.getUserId()).list().isEmpty()) {
	           
	           // ajout d'un nouveau membre 
	        	  classes.UserClass m = new classes.UserClass(user.getUserId(),user.getEmail());
	           ofy().save().entity(m); // enregistrement du membre sur le datastore	
	            	
		            try {
		            	// envoi d'un mail de bienvenue
		                Properties props = new Properties();
		                Session session = Session.getDefaultInstance(props, null);
		                 
		                String message = "  Merci de votre inscription sur SoS Nantes. Vous pouvez maintenant ajouter et suivre vos alertes et vos abonements.";
		                 
		                Message msg = new MimeMessage(session);
		                msg.setFrom(new InternetAddress("tilwing@gmail.com", "SoS Nantes"));
		                msg.addRecipient(Message.RecipientType.TO,
		                                 new InternetAddress(user.getEmail(), user.getNickname()));
		                msg.setSubject("Bienvenue sur SoS Nantes !");
		                msg.setText(message);
		                Transport.send(msg);
		            } catch (MessagingException e) {
		                e.printStackTrace();
		            }
		            try {
						this.getServletContext().getRequestDispatcher("index.jsp").forward(req, resp);
					} catch (ServletException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	          } else {
	        	  	// Récupération des alertes récentes
		        	List<classes.AlertClass> acts = ofy().load().type(classes.AlertClass.class).filter("date >", dateJour).order("date").limit(5).list();
		        	req.setAttribute( "acts", acts );       		
	        	  
	        	  try {
	  					this.getServletContext().getRequestDispatcher("index.jsp").forward(req, resp);
	  				} catch (ServletException e) {
	  				
	  					e.printStackTrace();
	  				}
	          }
	        } else {
	            resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
	        }
	        
	    }
	}
