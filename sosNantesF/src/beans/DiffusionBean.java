package beans;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;

public class DiffusionBean implements Serializable{
	TreeMap<String,ArrayList<String>> listeDiffusion;
	
	public DiffusionBean(){
		listeDiffusion = new TreeMap<String,ArrayList<String>>();
		initialisation();
	}
	
	public void initialisation(){
		String chaine="";
		String fichier ="listeRueInit.txt";
		try{
			InputStream ips=new FileInputStream(fichier); 
			InputStreamReader ipsr=new InputStreamReader(ips, "UTF-8");
			BufferedReader br=new BufferedReader(ipsr);
			String ligne;
			while ((ligne=br.readLine())!=null){
				addRue(ligne);
			}
			br.close(); 
		}		
		catch (Exception e){
			System.out.println(e.toString());
		}
	}
	
    public List<String> getData(String query) {
        String rue = null;
        List<String> matched = new ArrayList<String>();
        for(String key: listeDiffusion.keySet()) {
            rue = key.toLowerCase();
            if(rue.startsWith(query)) {
                matched.add(key);
            }
        }
        return matched;
    }

	public void removeUser(String mail){
		for (String s:listeDiffusion.keySet()){
			if(listeDiffusion.get(s).contains(mail)){
				listeDiffusion.get(s).remove(mail);
			}
		}
	}
	public boolean existeRue(String rue){
		return listeDiffusion.containsKey(rue);
	}
	
	public void addRue(String rue){
		if(!listeDiffusion.containsKey(rue)){
			listeDiffusion.put(rue, new ArrayList<String>());
		}
	}
	
	/**
	 * Renvoie la liste des rues connues
	 * @return
	 */
	public Set<String> getListeRue(){
		return listeDiffusion.keySet();
	}
	
	/**
	 * Supprime une rue de la liste et renvoie la liste des abonnés.
	 * @param rue
	 * @return
	 */
	public ArrayList<String> removeRue(String rue){
		if(listeDiffusion.containsKey(rue)){
			ArrayList<String> temp=listeDiffusion.get(rue);
			listeDiffusion.remove(rue);
			return temp;
		}
		return new ArrayList<String>();
	}
	/**
	 * renvoie la liste des abonnés à une rue.
	 * @param rue
	 * @return
	 */
	public ArrayList<String> listeAbonne(String rue){
		if(listeDiffusion.containsKey(rue)){
			ArrayList<String> temp=listeDiffusion.get(rue);
			return temp;
		}
		return new ArrayList<String>();
	}
	/**
	 * Inscrit un utilisateur a une liste de diffusion, renvoie vrai en cas de réussite.
	 * @param rue
	 * @param email
	 * @return
	 */
	
    public boolean inscriptionRue(String rue, String email){
        if(listeDiffusion.containsKey(rue)){
                if(!listeDiffusion.get(rue).contains(email)){
                        listeDiffusion.get(rue).add(email);
                }
        }
        else{
                addRue(rue);
                listeDiffusion.get(rue).add(email);
        }
        return true;
}
	
	/**
	 * Desabonne un utilisateur a une liste de diffusion, renvoie vrai en cas de réussite.
	 * @param rue
	 * @param email
	 * @return
	 */
	public boolean desabonneRue(String rue, String email){
		if(listeDiffusion.containsKey(rue)){
			if(listeDiffusion.get(rue).contains(email)){
				listeDiffusion.get(rue).remove(email);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Renvoie la liste des gens abonnes a la rue donnee en entre.
	 * @param rue
	 * @return
	 */
	public ArrayList<String> liste(String rue){
		if(listeDiffusion.containsKey(rue)){
			return listeDiffusion.get(rue);
		}
		return new ArrayList<String>();
	}
	
	public ArrayList<String> mesAbonnements(String mail){
		ArrayList<String> retour = new ArrayList<String>();
		for(String s:listeDiffusion.keySet()){
			if(listeDiffusion.get(s).contains(mail)){
				retour.add(s);
			}
		}		
		return retour;
	}
	
	public String toString(){
		String renvoie="";
		for(String rue: listeDiffusion.keySet()){
			renvoie+=rue+System.getProperty("line.separator");
				for(String abonne: listeDiffusion.get(rue)){
					renvoie+=abonne+"  ";
				}
				renvoie+=System.getProperty("line.separator"); 
		}
		return renvoie;
	}
	
	public int getSize(){
		return listeDiffusion.size();
	}
}