package beans;

import java.io.Serializable;

import classes.AlertClass;

import com.googlecode.objectify.annotation.*;

@Entity
@Index
public class AlertBean implements Serializable {
	@Id AlertClass alert;
	
	public AlertBean() {
		alert = null;
	}
	
	public AlertClass getAlert() {
		return alert;
	}
	
	public void setAlert(AlertClass model) {
			if (model != null){
				alert = model;
			}			
	}
	
	public void setId(Integer i){
		alert.setId(i);
	}
	
	public Integer getId(){
		return alert.getId();
	}
	
	public void setDate(String d){
		alert.setDate(d);
	}
	
	public String getDate(){
		return alert.getDate();
	}
	
	public void setMailNom(String n){
		alert.setUserMail(n);
	}
	
	public String getMailUser(){
		return alert.getUserMail();
	}
	
	public void setNom(String n){
		alert.setNom(n);
	}
	
	public String getNom(){
		return alert.getNom();
	}
	
	public void setNumRue(String numr){
		alert.setNumRue(numr);
	}
	
	public String getNumRue(){
		return alert.getNumRue();
	}
	
	public void setNomRue(String nomr){
		alert.setNomRue(nomr);
	}
	
	public String getNomRue(){
		return alert.getNomRue();
	}
	
	public void setComplementAdresse(String compl){
		alert.setComplementAdresse(compl);
	}
	
	public String getComplementAdresse(){
		return alert.getComplementAdresse();
	}
	
	public void setCodePostal(String cp){
		alert.setCodePostal(cp);
	}
	
	public String getCodePostal(){
		return alert.getCodePostal();
	}
	
	public void setVille(String v){
		alert.setVille(v);
	}
	
	public String getVille(){
		return alert.getVille();
	}
	
	public void setLat(float la){
		alert.setLat(la);
	}
	
	public float getLat(){
		return alert.getLat();
	}
	
	public void setLon(float lo){
		alert.setLon(lo);
	}
	
	public float getLon(){
		return alert.getLon();
	}
	
	public void setDescription(String d){
		alert.setDescription(d);
	}
	
	public String getDescription(){
		return alert.getDescription();
	}
	
	public void setType(String t){
		alert.setType(t);
	}
	
	public String getType(){
		return alert.getType();
	}
	
	public void like(String mail){
		alert.like(mail);
	}
	
	public void dislike(String mail){
		alert.dislike(mail);
	}
	
	public Integer getLike(){
		return alert.getLike();
	}
	
	public Integer getDislike(){
		return alert.getDislike();
	}
	/*public boolean nameIsDefault() {
		return "Unknown user".equals(getName());
	}*/
	
}
