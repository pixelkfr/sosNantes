package beans;

import java.io.Serializable;

import classes.UserClass;

import com.googlecode.objectify.annotation.*;
@Entity
@Index
public class UserBean implements Serializable {
	UserClass user;
	
	public UserBean() {
		user = null;
	}
	
	public UserClass getUser() {
		return user;
	}
	
	public void setUser(UserClass model, String mail) {
			if (model != null)
				user = model;
			else
				user = new UserClass(mail);
	}
	
	public String getName() {
		return user.getName();
	}
	
	public String getMail() {
		return user.getMail();
	}
	
	public void setName(String n) {
		user.setName(n);
	}
	
	public void setMail(String m) {
		user.setMail(m);
	}
	
	public boolean nameIsDefault() {
		return "Unknown user".equals(getName());
	}
	
}