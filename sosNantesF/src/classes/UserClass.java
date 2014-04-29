package classes;

import java.io.Serializable;
import java.util.ArrayList;
import java.io.Serializable;

import classes.UserClass;

import com.googlecode.objectify.annotation.*;
@Entity
@Index
public class UserClass implements Serializable{
	String mail;
	String name;

	
	public UserClass(String n, String m) {
		mail = n;
		name = m;
	}
	
	public UserClass(String m) {
		mail = m;
		name = "Unknown user";
	}
	
	public String getName() {
		return name;
	}
	
	public String getMail() {
		return mail;
	}
	
	public void setName(String n) {
		if(n != null)
			name = n;
	}
	
	public void setMail(String m) {
		mail = m;
	}
	
	public String toString() {
		return new String(name+" : "+mail);
	}
	
	public boolean isInArray(ArrayList<UserClass> array) {
		for(int i=0;i<array.size();i++) {
			if(mail.equals(array.get(i).getMail()))
				return true;
		}
		return false;
	}
	
	public int indexInArray(ArrayList<UserClass> array) {
		for(int i=0;i<array.size();i++) {
			if(mail.equals(array.get(i).getMail()))
				return i;
		}
		return -1;
	}
	
	public boolean equals(UserClass user) {
		return mail.equals(user.getMail());
	}	

}