package dbIntergration;

import java.awt.Choice;
import java.io.Console;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Random;
import java.util.Scanner;

public class dbApp {

	// a connection entity.
	Connection conn;
	
	public dbApp() 
	{
		//init. to null upon creation.
		conn = null;
	}
	
	public void dbConnect (String ipAddr, int port, String dbName, String username, String password) {
		try {
			
			// Check if postgres driver is loaded
     		Class.forName("org.postgresql.Driver");
     		
     		
     		// Establish connection with the database and prompt the user.
     		conn = DriverManager.getConnection("jdbc:postgresql://"+ipAddr+":"+port+"/"+dbName,username,password);
     		System.out.println("Connection Established!");
     		
     		// Disable autocommit feature, only user gets to choose if a commit is made.
     		conn.setAutoCommit(false);
     		System.out.println("Autocommit feature is now turned off!");
     		
     		
		} catch(Exception e) {
            e.printStackTrace();
		}
	}
	
	
	/*
	 * UTILITY FUNCTIONS FOR UN/COMMITING ON DB or CHECKING FEATURES.
	 */
	
	
	/**
	 * Commits all changes on the connected DB.
	 */
	public void db_commit() 
	{
		
		// try commiting.
		try 
		{
			
			conn.commit();
			System.out.println("Changes committed!");
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * If possible rolls back any uncommited change.
	 */
	public void db_abort() 
	{
		//try rolling back changes.
		try 
		{
		
			conn.rollback();
			System.out.println("Uncommitted changes cancelled!");
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}

	/**
	 * Terminates an established connection with DB. All uncommited changes are rolled back.
	 */
	public void closeConnection()
	{
		try 
		{
			System.out.println("Closing connection...");
			db_abort();
			conn.close();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}
	
	
	
	/*
	 * I/O and USER INTERFERENCE FUNCTIONS
	 */
	
	
	
	
	public String promptConnection() 
	{
		Scanner menuScanner = new Scanner(System.in);
		String ch = "";
		System.out.println("Welcome!");
		
		while(ch.compareTo("y") != 0 && ch.compareTo("n") != 0)
		{
			System.out.println("Would you like to connect to database? [y/n]");
			try
			{
				ch = menuScanner.nextLine().trim();
				
			
				//attempt connection
				if (ch.compareTo("y") == 0)
				{
				
					System.out.println("Type \"<database-name> <username> <password>\" splited with space [case sensitive input, only localhost allowed]");
					String args = menuScanner.nextLine().trim();
					dbConnect("localhost",5432,args.split(" ")[0], args.split(" ")[1], args.split(" ")[2]);
				}
			}
			catch (InputMismatchException e) 
			{
				System.out.println("Invalid input! Type [y/n].");
				
			}
		}
		return ch;
	}
	
	/**
	 * Waits the enter key from I/O.
	 */
	public void waitForEnter() 
	{
		Scanner in = new Scanner(System.in);
		System.out.println("Press Enter to continue...");
		in.nextLine();
	}
	
	public void exec() throws UnsupportedEncodingException {
		Scanner sc = new Scanner(System.in);
		int ch = -1;
		
		while(ch != 0){
			try{
				//print options, scan user choice, throw line leftover.
				printMenu();
				ch = sc.nextInt();
				sc.nextLine();
				
				switch (ch) 
				{
					case 1:	
						System.out.println("Already Connected");
						break;
					case 2: 
						db_commit();
						break;
					case 3: 
						db_abort();
						break;
				case 4: 
						listStudents();
						break;
				case 5: 
						listStudentGrades();
						break;
				
				case 0: closeConnection();
						break;
				default: System.out.println("Choice out of range! Please type from 0 to 7!");
				}
			}
			catch (InputMismatchException e) {
				System.out.println("Invalid input! Please type a number from 0 to 7!");
				sc.nextLine();
			}
		}
	}
	
	/**
	 * List the students enrolled in a specific course, in a specific year and a semester. Only those approved in course will be shown.
	 * @throws UnsupportedEncodingException
	 */
	private void listStudents() throws UnsupportedEncodingException 
	{
		Scanner sc = new Scanner(System.in);
		PreparedStatement state; 
		try 
		{
			// better call a function rather spit the query out raw. I've left the data types exposed, I imagine u wont inject my SQL would you?
			String query = "SELECT	*"
							+"FROM get_enrolled_students(?::integer, ?::text, ?::character(7))"
							+"ORDER BY am" ;
			
			state = conn.prepareStatement(query);
			
			
			System.out.println("Insert Academic year:");
			String yr = sc.nextLine().trim();
			
			System.out.println("Insert Academic season [winter/spring]:");
			String acadSeason = sc.nextLine().trim();
			
			System.out.print("Insert Course Code:");
			String cCode = sc.nextLine();
			
			
			state.setInt(1, Integer.parseInt(yr));
			state.setString(2, acadSeason);
			state.setString(3, cCode);
			
			//execute.
			ResultSet result = state.executeQuery();
			
				
			// if there is something retrieved.
			while (result.next())
			{
				System.out.println(result.getRow()+" First Name:" + result.getString(2)+ " Last Name: "+result.getString(3) + "AM:" + result.getString(1));
			}

		}
		
		catch (SQLException e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			waitForEnter();
		}
	}
		
	private void listStudentGrades() throws UnsupportedEncodingException 
	{
		Scanner sc = new Scanner(System.in);
		PreparedStatement state;
		PreparedStatement modState;
		int semesterSerial = -1;
		String sAM = null, yr,acadSeason;
		ArrayList <String> course = new ArrayList<String>();
		ArrayList <Savepoint> previousSaves = new ArrayList<Savepoint>();
		try 
		{
			// better call a function rather spit the query out raw. I've left the data types exposed, I imagine u wont inject my SQL would you?
			String query = "SELECT	*"
							+"FROM get_student_grades(?::integer, ?::text, ?::text)"
							+"ORDER BY c_code" ;
			
			state = conn.prepareStatement(query);
			
			
			System.out.println("Insert Academic year:");
			yr = sc.nextLine().trim();
			
			System.out.println("Insert Academic season [winter/spring]:");
			acadSeason = sc.nextLine().trim();
			
			System.out.print("Insert Student AM:");
			sAM = sc.nextLine();
			
			
			state.setInt(1, Integer.parseInt(yr));
			state.setString(2, acadSeason);
			state.setLong(3, Integer.parseInt(sAM));
			
			//execute.
			ResultSet result = state.executeQuery();
			
			
			// if there is something retrieved.
			while (result.next())
			{	
				//remember whats important.
				int currRow = result.getRow();
				semesterSerial = result.getInt("s_num");
				
				course.add(currRow-1, result.getString(4));
				System.out.println(currRow+"\tCourse: "+course.get(currRow-1) +" Lab Grade:" + result.getString(2)+ " Exam Grade: "+result.getString(1));
			}
			
			
			
			
		
			
		}
		
		catch (SQLException e) 
		{
			e.printStackTrace();
		} 
		
		
		// modify section 
		int modChoice = -2;
		int saves = 0;
		
		//keep modifying
		do 
		{
			System.out.println("Type a row to modify or 0 to exit (-1 to rollback)");
			modChoice = sc.nextInt();
			sc.nextLine();
			
			if(modChoice != 0 && modChoice != -1) 
			{
				System.out.println("Type <lab_grade> <exam_grade>:");
				String grade = sc.nextLine().trim();
				
				try {
					String query = "UPDATE	\"Register\" "
							+ "SET	exam_grade = ?, lab_grade = ? "
							+ "WHERE	amka = (SELECT	amka FROM \"Student\" WHERE am = ?) AND course_code = ? AND serial_number = ?";
					
					modState = conn.prepareStatement(query);
					
					modState.setInt(1, Integer.parseInt(grade.split(" ")[0]));
					modState.setInt(2, Integer.parseInt(grade.split(" ")[1]));
					modState.setString(3, sAM);
					modState.setString(4, course.get(modChoice-1));
					modState.setInt(5, semesterSerial);
					
					//increase count, save the save point.
					saves++;
					previousSaves.add(conn.setSavepoint());
					
					
					int rowCount = modState.executeUpdate();
					System.out.println(rowCount + " row(s) updated! Commit to finalize changes!");
				} catch (SQLException e1)
				{
					e1.printStackTrace();
				} 
			}
			else if(modChoice == -1) 
			{
				//roll back the changes one by one.
				
				if(saves > 0 )
				{
					try 
					
					{
							System.out.println("Im here");
						
							conn.rollback(previousSaves.get(saves-1));
							saves--;
						
					} catch (SQLException e) 
					{
							// TODO Auto-generated catch block
							e.printStackTrace();
					}
				}
				else
					System.out.println("You have reverted every change that had been made");
			}
				
				
			
			
		} while(modChoice != 0);
		
		
		
	}

	
	public void modifyGrade(String student_am, String course_code, int serial_number,int lab_grade ,int  exam_grade, ResultSet res) {
		
		PreparedStatement statement;
		try {
			String query = "UPDATE	\"Register\" "
					+ "SET	exam_grade = ?, lab_grade = ? "
					+ "WHERE	amka = (SELECT	amka FROM \"Student\" WHERE am = ?) AND course_code = ? AND serial_number = ?";
			
			statement = conn.prepareStatement(query);
			
			statement.setInt(1, exam_grade);
			statement.setInt(2, lab_grade);
			statement.setString(3, student_am);
			statement.setString(4, course_code);
			statement.setInt(5, serial_number);
			int rowCount = statement.executeUpdate();
			System.out.println(rowCount + " row(s) updated! Commit to finalize changes!");
		} catch (SQLException e1) {
			e1.printStackTrace();
		} finally {
			waitForEnter();
		}
	}
	
	protected void printMenu() {
		System.out.println("Type a command: 1-5 or 0 - quit");
		System.out.println("(1) Connect on a database.");
		System.out.println("(2) Commit transactions");
		System.out.println("(3) Abort transactions");
		System.out.println("(4) List students enrolled in a specific course.");
		System.out.println("(5) Print grade list of a student for a given semester");
		System.out.println("(0) Exit (any uncommitted transactions will be aborted - rolled back!)");
	}
	

}
