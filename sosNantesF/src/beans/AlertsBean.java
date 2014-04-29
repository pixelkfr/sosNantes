package beans;

import java.io.Serializable;
import java.util.ArrayList;

import classes.AlertClass;

import com.googlecode.objectify.annotation.*;

@Entity
@Index
public class AlertsBean implements Serializable {
	ArrayList<AlertClass> alerts;
	@Id Integer id;
	
	public AlertsBean() {
		alerts = new ArrayList<AlertClass>();
		id=0;
	}
	
	public Integer newId() {
		id+=1;
		return id;
	}
	
	public boolean isCode(String cp){
		Integer code;
	try{
			code=Integer.valueOf(cp);
	}
	catch(Exception e){
		return false;
	}
	return true;
	}
	
	public boolean addAlert(Integer i,String us,String n, String numr, String nomr, String ca, String cp, String v,String la,String lo,String d,String t,String date) {
		float lat;float lot;
	try{
			lat=Float.valueOf(la);
			lot=Float.valueOf(lo);			
	}
	catch(Exception e){
		id-=1;
		return false;
	}
	alerts.add(new AlertClass(i,us,n,numr, nomr, ca, cp, v,lat,lot,d,t,date));
	return true;
	}

	/**
	 * Suprime une alerte par son identifiant
	 * @param i
	 * @return
	 */
	public boolean deleteAlert(String i) {//verifier si Integer
		Integer in;
		try{
			in=Integer.valueOf(i);
		}
		catch(Exception e){
			id-=1;
			return false;
		}
		for(int j=0;j<getSize();j++) {
			if(alerts.get(j).getId() == Integer.valueOf(i)){
				alerts.remove(j);
			}
		}
		return true;
	}
	
	public boolean containsAlert(AlertClass alert) {
		return alert.isInArray(alerts);
	}
	
	public boolean containsAlert(String i) {
		Integer in;
		try{
			in=Integer.valueOf(i);
		}
		catch(Exception e){
			id-=1;
			return false;
		}
		for(AlertClass al: alerts){
			if(al.getId()==in){
				return true;
			}
		}
		return false;
	}
	
	public AlertClass getAlertById(String i) {
		Integer in;
		try{
			in=Integer.valueOf(i);
		}
		catch(Exception e){
			id-=1;
			return null;
		}
		for(AlertClass al: alerts){
			if(al.getId()==in){
				return al;
			}
		}
		return null;
	}
	
	public String getAlertString(AlertClass alert) {
		if(containsAlert(alert)){
			return "id: "+alerts.get(alert.indexInArray(alerts)).getId() +"userNom: "+alerts.get(alert.indexInArray(alerts)).getUserMail() +" nom : "+ alerts.get(alert.indexInArray(alerts)).getNom()+" numéro de rue : "+ alerts.get(alert.indexInArray(alerts)).getNumRue()+ " nom de rue : "+ alerts.get(alert.indexInArray(alerts)).getNomRue()+ " complement d'adresse: "+ alerts.get(alert.indexInArray(alerts)).getComplementAdresse()+ " code postal: "+ alerts.get(alert.indexInArray(alerts)).getCodePostal()+ " ville: "+ alerts.get(alert.indexInArray(alerts)).getVille()+" lat :"+alerts.get(alert.indexInArray(alerts)).getLat()+" lat :"+ alerts.get(alert.indexInArray(alerts)).getLon()+" description : "+ alerts.get(alert.indexInArray(alerts)).getDescription()+" type : "+ alerts.get(alert.indexInArray(alerts)).getType();
			//return alerts.get(alert.indexInArray(alerts)).toString();
		}
		return null;
	}
		
	public AlertClass getAlert(AlertClass alert) {
		if(containsAlert(alert)){
			return alerts.get(alert.indexInArray(alerts));
		}
		return null;
	}
	
	public AlertClass getAlert(int i) {
		if(i<getSize()){
			return alerts.get(i);
		}
		return null;
	}
	
	public int getSize() {
		return alerts.size();
	}
	
	public void like(String id, String mail){
		getAlertById(id).like(mail);
	}
	
	public void dislike(String id, String mail){
		getAlertById(id).dislike(mail);
	}
	
	public Integer getLike(String id){
		return getAlertById(id).getLike();
	}
	
	public Integer getDisike(String id){
		return getAlertById(id).getDislike();
	}
}
