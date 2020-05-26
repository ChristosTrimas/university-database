package dbIntergration;

import java.io.UnsupportedEncodingException;

public class dbAppLauncher {

	public static void main(String[] args) throws UnsupportedEncodingException 
	{
		
		dbApp db = new dbApp();
		String linkEstablished = db.promptConnection(); // Initial menu
		
		if (linkEstablished.compareTo("y") == 0)
			db.exec(); 
		
		System.out.println("Bye!");
	}
}
