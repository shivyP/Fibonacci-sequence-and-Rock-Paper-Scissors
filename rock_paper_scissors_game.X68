*-----------------------------------------------------------
* Title      :Rock Paper Scissors
* Written by :Shivangi Prajapati
* Date       :01/05/21
* Description:Rock, Paper, Scissors game where the players 
*             have 3 rounds and the one who wins most of them 
*             wins the game. The players will be aslo asked 
*             to enter their name.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*Put program code here
*----------------------------------------
*player 1 will win when P1- P2 = -1 or 2 
*player 2 will win when P1- P2 = 1 or -2  
*TIE will be when P1-P2 = 0 
*----------------------------------------  
*-------- display message --------
game:        bsr       clearScreen
             lea       arrayScore,A3   #A3 reserved for array
*          introduction message         
             lea       intro,A1         
             bsr       display
*          instructions
             lea       description,a1
             bsr       display 
*-------- Gets the name of the Players ------------
*          player 1
              bsr      newLine 
              lea      PlayerMsg1,a1
              bsr      display     
              lea      name1,A1
              bsr      getName
           
*          player 2 
              bsr      newLine         
              lea      PlayerMsg2,a1
              bsr      display  
              lea      name2,A1
              bsr      getName
           

*          game message
              bsr      newLine 
              lea      newGame,A1
              bsr      display 
           
*          user Input           
              bra     playerOne
           
getName:      move    #2,d0
              trap    #15
              rts
        
user:         bsr     display         #display finction called 
              lea     dots,a1
              bsr     display
              bsr     userInput
              rts 
           
display:      move    #14,d0
              trap    #15
              rts
          
           
userInput:    move    #4,d0
              trap    #15
              rts

newLine:      lea     line,A1
              bsr     display
              rts
         
*-------- Game start, gets user input ------------
          
playerOne:    bsr     newLine 
              lea     name1,a1        #first player,load the address of the message to display
              bsr     user            #for user input
              move    #1,d2           #save player id for returning to the function
              bsr     validation      #validation fucntion called 
              move    #0,d2
              move.b  d1,player1      #save the value in a variable
         
           
playerTwo:    bsr     newLine 
              lea     name2,a1        #second player, load the address of the message to display
              bsr     user            #for user input    
              bsr     validation      #validation function called 
              move.b  d1,player2      #save the user input in the variable 
              bra     winner          #check who won the game

          
*-------- Validate user Input ------------     
validation:   cmp.b   #1,d1         
              blt     error           #user input cannot be less than 1
              cmp.b   #3,d1
              bhi     error           #user input cannot be more than 3
              rts                     #return if conditions are not met which means user input is accepted 



error:        bsr     newLine
              lea     errMsg,A1       #display error message
              bsr     display
              cmp.b   #1,d2           #look for the player id 
              beq     playerOne       #if player 1, than ask player 1 again
              bra     playertwo       #else ask player 2


*-------- Find the winner of the round ------------ 
*player 1 will win when P1- P2 = -1 or 2 
*player 2 will win when P1- P2 = 1 or -2  
*TIE will be when P1-P2 = 0
*A3 only for array
*--------------------------------------------------

winner:       move.b  player2,d1      #move the player2 choice in d1
              sub.b   d1,player1      #perform player1-player2 operation 
               
            *look for -1 or 2
              cmp.b   #0,player1
              beq     tie
              cmp.b   #$ff,player1    #compare to see if is -1
              beq     playerWon1      #if yes than player 1 won
              cmp.b   #2, player1     #compare if 2
              beq     playerWon1      #if yes than player 1 won
              bsr     newLine
              lea     winnerMsg2,A1   #else player 2 won 
              move.b  #2,wonPlayer    #save player ID
              bsr     display 
              bra     scoring
              rts
*-------- Tie case -------------------------- 
tie:          bsr     newLine 
              lea     tieMsg,A1
              bsr     display
              bsr     newLine 
              lea     newGame,A1
              bsr     display
              bra     playerOne
          
*-------- Player 1 winning message ------------                      
playerWon1:   bsr     newLine 
              lea     winnerMsg1,A1    
              bsr     display
              move.b  #1,wonPlayer    #save player ID
            
           
*-------- Assigning scores ------------------          
scoring:      tst.b   (A3)            #check if array location is empty
              beq     addScore        #if not than add the value
              move.b  (a3),d1         #move in d1 
              move.b  d1,(A3)+        #move back in array and point to next element
              bra     scoring   


addScore:     move.b  wonPlayer,d1    #get player ID
              move.b  d1,(A3)         #save in array
              sub.b   #1,limitGame    #once added reduce the number of attempts left
              tst.b   (limitGame)     #check the number of limits left 
              beq     finalScores     #if no than end game 
              lea     newGame,A1      #else display next game message
              bsr     display
              bra     playerOne       #start the next round

     
*-------- Final Scoring ---------------------     
          
finalScores:  bsr     newLine 
              lea     finalMsg,A1     #display attempts finished message
              bsr     display
              move.b  #0,d2           #d2 keeps the counting for player 1
              move.b  #0,d3           #d3 keeps counting for player 2
              lea     arrayScore,A3 
              
              
counting:     tst.b   (A3)            #checking array to find which player has won the game 
              beq     displayScore    #if zero mens end of array
              move.b  (a3),d1
              cmp.b   #1,(A3)         #check if the location has 1, player 1 ID 
              beq     scores        
              add.b   #1,d3           #increase count for player 2
              move.b  d1,(A3)+        #check next location
              bra     counting

scores:       add.b   #1,d2           #increase the count for player 1 
              move.b  d1,(A3)+        #next location
              bra     counting 
              
*-------- Display socres and final winner ------------
 
displayscore: cmp.b   d2,d3           #if d2 greater means player 1 won ,else player 2
              bhi     finalWinner     #if greater condition
              bsr     newLine 
              lea     endWinner,A1    #display player 1 winning message
              bsr     display
              lea     name1,A1
              bsr     display
              bra     playAgain
                            
              
finalWinner:  bsr     newLine 
              lea     endWinner,A1    #display player 2 winning message
              bsr     display
              lea     name2,A1
              bsr     display
              
              
*-------- Ask if they want to play again ------------
             
playAgain:    bsr     newLine 
              lea     playAgainMsg,A1  #ask for new game 
              bsr     display
              move    #5,d0
              trap    #15
              cmp.b   #$79,d1          #if yes 
              bne     end              #if anything diffrent from y
          
              move.b  #3,limitGame     #reset attempts to 3
              lea     arrayScore,A3    #reset the score array to 0s
              move.b  #0,(A3)
              move.b  #0,(1,A3)
              move.b  #0,(2,A3)
              beq     game             #restart the game
              
                                      
              
              
clearScreen:  move    #11,d0
              move    #$FF00,d1
              trap    #15
              rts

end:          lea     message,a1
              bsr     display
              Stop    #$2000           #end of game 


              







* Put variables and constants here
intro	     dc.b    $0D,$0A,$09,$09,$09,$09
             dc.b	'------------------------------',$0D,$0A,$09,$09,$09,$09
             dc.b	'      Rock Paper Scissors ',$0D,$0A,$09,$09,$09,$09
             dc.b	'------------------------------',$0D,$0A,$0D,$0A,$09,$09,$09,$09
	         dc.b   'You will have 3 rounds to play',$0D,$0A,$09,$09,$09,$09
	         dc.b 	'Enter your names Please!',$0D,$0A,$0D,$0A,$09,$09,$09,$09,0

description  dc.b   'Instructions to Play: Scissors(1), Paper(2), Rock(3)',$0D,$0A,$0D,$0A,0
playerMsg1   dc.b   'Player 1 name: ',0
playerMsg2   dc.b   'Player 2 name: ',0


newGame      dc.b   $0D,$0A,$09,$09,$09,$09 
             dc.b   '========== Game ==========',$0D,$0A,0
dots         dc.b   ' : ',0 //gurda questo
winnerMsg1   dc.b   'Player 1 Won!!!',0
winnerMsg2   dc.b   'Player 2 Won!!!',0
tieMsg       dc.b   'Is a tie!!',$0D,$0A,0
errMsg       dc.b   'Invalid Option! Try agian!',$0D,$0A,0
finalMsg     dc.b   $0D,$0A,$0D,$0A,$09,$09,$09,$09 
             dc.b   '**** Attemps finished! ****',$0D,$0A,0
             
endWinner    dc.b   $0D,$0A,$09,$09,$09,$09 
             dc.b   'The Winner is ',0
           
playAgainMsg dc.b   $0D,$0A,$0D,$0A,$09,$09,$09,$09 
             dc.b   'Do you want to play again: yes (y), no(n):',0
             
message      dc.b   $0D,$0A,$0D,$0A,$09,$09,$09,$09
             dc.b   'Thank You for playing!!',$0D,$0A,0
             
player1      ds.b   1
player2      ds.b   1
name1        ds.l   3
name2        ds.l   3
arrayScore   dc.b   0,0,0
wonPlayer    ds.b   1
limitGame    dc.b   3
line         dc.b   $09,$09,$09,$09,0



    END    START        ; last line of source

 




*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
