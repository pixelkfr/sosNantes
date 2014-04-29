package classes;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.SortedSet;
import java.util.TreeSet;
import com.googlecode.objectify.annotation.*;

@Entity
@Index
public class AlertClass implements Serializable{
	
	@Id Integer id;
	String userMail;
	String nom;	
	String numRue;
	String nomRue;
	String complementAdresse;
	String codePostal;
	String ville;
	float lat;		//latitude de l'alerte
	float lon;		//longitude de l'alerte
	String description;
	String type;	//type de l'alerte // ! enumeration ?
	String date;
	Integer like;
	Integer dislike;
	SortedSet<String> vote;
	
	 private AlertClass() {} // Obligatoire pour Objectify
	
	public AlertClass(Integer i,String us,String n, String numr, String nomr, String compl, String cp, String v, float la,float lo,String d,String t, String dat) {
		id=i;
		userMail=us;
		nom=n;	
		numRue=numr;
		nomRue=nomr;
		complementAdresse=compl;
		codePostal=cp;
		ville=v;
		lat=la;	//latitude de l'alerte
		lon=lo;	//longitude e l'alerte
		description=d;
		type=t;	//type de l'alerte
		date=dat;
		like=0;
		dislike=0;
		vote =new TreeSet<String>();
	}
	
	/**
	 * Soutenir l'alerte.
	 */
	public void like(String mail){
		if(!vote.contains(mail)){
			vote.add(mail);
			like+=1;
		}
	}
	
	/**
	 * Donenr une opion negative à l'alerte.
	 */
	public void dislike(String mail){
		if(!vote.contains(mail)){
			vote.add(mail);
			dislike+=1;
		}
	}
	
	public Integer getLike(){
		return like;
	}
	
	public Integer getDislike(){
		return dislike;
	}
	
	public void setId(Integer i){
		id=i;
	}
	
	public Integer getId(){
		return id;
	}
	public void setUserMail(String m){
		userMail=m;
	}
	
	public String getUserMail(){
		return userMail;
	}
	
	public void setNom(String n){
		nom=n;
	}
	
	public String getNom(){
		return nom;
	}
	
	public void setDate(String d){
		date=d;
	}
	
	public String getDate(){
		return date;
	}
	
	public void setNumRue(String numr){
		numRue=numr;
	}
	
	public String getNumRue(){
		return numRue;
	}
	public void setNomRue(String nomr){
		nomRue=nomr;
	}
	
	public String getNomRue(){
		return nomRue;
	}
	public void setComplementAdresse(String compl){
		complementAdresse=compl;
	}
	
	public String getComplementAdresse(){
		return complementAdresse;
	}
	public void setCodePostal(String cp){
		codePostal=cp;
	}
	public void setVille(String v){
		ville=v;
	}
	
	public String getVille(){
		return ville;
	}
	public String getCodePostal(){
		return codePostal;
	}
	public void setLat(float la){
		lat=la;
	}
	
	public float getLat(){
		return lat;
	}
	
	public void setLon(float lo){
		lon=lo;
	}
	
	public float getLon(){
		return lon;
	}
	public void setDescription(String d){
		description=d;
	}
	
	public String getDescription(){
		return description;
	}
	public void setType(String t){
		type=t;
	}
	
	public String getType(){
		return type;
	}
	
	public int indexInArray(ArrayList<AlertClass> array) {
		for(Integer i=0;i<array.size();i++) {
			if(id.equals(array.get(i).getId()))
				return i;
		}
		return -1;
	}
	
	public boolean isInArray(ArrayList<AlertClass> array) {
		for(Integer i=0;i<array.size();i++) {
			if(id.equals(array.get(i).getId()))
				return true;
		}
		return false;
	}

}
