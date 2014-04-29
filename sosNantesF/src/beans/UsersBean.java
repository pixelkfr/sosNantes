package beans;

import java.io.Serializable;
import java.util.ArrayList;

import com.google.appengine.api.users.User;

import classes.UserClass;

public class UsersBean implements Serializable {
	ArrayList<UserClass> users;
	ArrayList<UserClass> moderateur;
	
	public UsersBean() {
		users = new ArrayList<UserClass>();
		moderateur = new ArrayList<UserClass>();
		addUser(new UserClass("anonpremier@gmail.com", "modo anonyme 1er"));// Specifier les modérateurs initiaux
		beModo(new UserClass("anonpremier@gmail.com", "modo anonyme 1er"));
		addUser(new UserClass("tilwing@gmail.com", "modo anonyme 1er"));// Specifier les modérateurs initiaux
		beModo(new UserClass("tilwing@gmail.com", "modo anonyme 1er"));
	}
	
	public boolean addUser(UserClass newUser) {
		if(!newUser.isInArray(users)) {
			return users.add(newUser);
		}
		return false;
	}
	
	public void removeUser(UserClass ancientUser) {
		if(containsUser(ancientUser)) {
			users.remove(ancientUser.indexInArray(users));
		}
	}
	public void removeUser(String mail) {
		users.remove(getUser(mail));
	}
	/**
	 * Give new rights to someone.
	 * @param newModo
	 */
	public void beModo(UserClass newModo){
		if(containsUser(newModo)) {
			if(!containsModo(newModo)) {
				moderateur.add(newModo);
			}
		}
	}
	
	public boolean beModo(String mail){
		for(UserClass us:users){
			if(us.getMail()==mail){
				for(UserClass usm:moderateur){
					if(usm.getMail()==mail){
						return false;
					}
					return true;
				}
			}
		}
		return false;
	}
	
	public boolean containsUser(UserClass user) {
		return user.isInArray(users);
	}
	
	public boolean containsModo(UserClass user) {
		return user.isInArray(moderateur);
	}
	
	public boolean containsModo(String mail) {
		for(UserClass us:moderateur){
			if(us.getMail()==mail){
				return true;
			}
		}
		return false;
		}
	
	public String getUserString(int i) {
		if(i < users.size())
			return users.get(i).toString();
		else
			return null;
	}
	
	public String getModoString(int i) {
		if(i < moderateur.size())
			return moderateur.get(i).toString();
		else
			return null;
	}
	
	public String getModoMail(int i) {
		if(i < moderateur.size())
			return moderateur.get(i).getMail();
		else
			return null;
	}
	
	/**
	 * get the position of a user in the list through his mail adress.
	 * @param mail
	 * @return
	 */
	public UserClass getUser(String mail) {
		for(int i=0;i<users.size();i++) {
			if(mail.equals(users.get(i).getMail())) {
				return users.get(i);
			}
		}
		return null;
	}
	
	public int getSize() {
		return users.size();
	}
	
	public int getSizeModo() {
		return moderateur.size();
	}
}