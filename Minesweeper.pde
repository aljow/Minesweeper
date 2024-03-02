import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines= new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean locked = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    //first call to new that initializes empty apartments 
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    
    setMines();
}
public void setMines()
{
    while(mines.size() < 5 /*this will eventually be a var to determine the amount of bombs*/) {
      int r = (int)(Math.random()*NUM_ROWS);
      int c = (int)(Math.random()*NUM_COLS);
      if (!mines.contains(buttons[r][c])) {
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
       displayWinningMessage();
}
public boolean isWon()
{
    for (int i = 0; i < buttons.length; i++) {
      for (int j = 0; j < buttons[i].length; j++) {
        if (buttons[i][j].clicked == false) {
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    stroke(255,0,0);
    textSize((float)20);
    for (int i = 0; i < buttons.length; i++) {
      for (int j = 0; j < buttons[i].length; j++) {
        if (mines.contains(buttons[i][j])) {
           buttons[i][j].clicked = true;
        } else {
          buttons[i][j].clicked = false;
        }
      }
    }
    buttons[1][NUM_COLS/2].setLabel("Y");
    buttons[2][NUM_COLS/2].setLabel("o");
    buttons[3][NUM_COLS/2].setLabel("u");
    buttons[5][NUM_COLS/2].setLabel("L");
    buttons[6][NUM_COLS/2].setLabel("o");
    buttons[7][NUM_COLS/2].setLabel("s");
    buttons[8][NUM_COLS/2].setLabel("e");
}
public void displayWinningMessage()
{
    stroke(0,255,0);
    textSize((float)20);
    buttons[2][NUM_COLS/2].setLabel("Y");
    buttons[3][NUM_COLS/2].setLabel("o");
    buttons[4][NUM_COLS/2].setLabel("u");
    buttons[6][NUM_COLS/2].setLabel("W");
    buttons[7][NUM_COLS/2].setLabel("i");
    buttons[8][NUM_COLS/2].setLabel("n");
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = col-1; i <= col+1; i++) {
      for (int j = row-1; j <=row+1; j++) {
        if (!(i == col && j == row)) {
          if (isValid(j,i) == true && mines.contains(buttons[j][i])) {
            numMines++;
          }
        } 
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if (isWon() == false && locked == false) {
          if (flagged == false) {
            clicked = true;
          }
          if (mouseButton == RIGHT) {
            if (flagged == false) {
              flagged = true;
            } else {
              flagged = false;
            }
          } else if (mines.contains(buttons[myRow][myCol])) {
            locked = true;
            displayLosingMessage();
          } else if (countMines(myRow,myCol) > 0) {
            setLabel(countMines(myRow,myCol));
          } else {
            if (isValid(myRow,myCol-1) == true && buttons[myRow][myCol-1].clicked == false) {
                  buttons[myRow][myCol-1].mousePressed();
            } 
            if (isValid(myRow-1,myCol) == true && buttons[myRow-1][myCol].clicked == false) {
                  buttons[myRow-1][myCol].mousePressed();
            } 
            if (isValid(myRow+1,myCol) == true && buttons[myRow+1][myCol].clicked == false) {
                  buttons[myRow+1][myCol].mousePressed();
            } 
            if (isValid(myRow,myCol+1) == true && buttons[myRow][myCol+1].clicked == false) {
                  buttons[myRow][myCol+1].mousePressed();
            } 
            if (isValid(myRow+1,myCol+1) == true && buttons[myRow+1][myCol+1].clicked == false) {
                  buttons[myRow+1][myCol+1].mousePressed();
            } 
            if (isValid(myRow-1,myCol+1) == true && buttons[myRow-1][myCol+1].clicked == false) {
                  buttons[myRow-1][myCol+1].mousePressed();
            } 
            if (isValid(myRow-1,myCol-1) == true && buttons[myRow-1][myCol-1].clicked == false) {
                  buttons[myRow-1][myCol-1].mousePressed();
            } 
            if (isValid(myRow+1,myCol-1) == true && buttons[myRow+1][myCol-1].clicked == false) {
                  buttons[myRow+1][myCol-1].mousePressed();
            } 
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0,0,250);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
