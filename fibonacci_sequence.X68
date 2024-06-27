*------------------------------------------------------------
* Title      :Fibonacci Sequence 
* Written by :Shivangi Prajapati
* Date       :01/05/20
* Description:Calculates the terms of a fibonacci sequence 
*             the user is asked to enter the first 2 terms 
*             of the sequence and the number of terms wnated
*------------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
          lea      intro,A1
          bsr      display
          
          lea      numTermMsg,a1
          bsr      display
          bsr      userInput
          sub.b    #2,d1
          move.b   d1,elements
          
*         display message and get first number
          lea      firstNumMsg,a1  
          bsr      display            #branch to subroutine
          bsr      userInput
          move.l   d1,firstNum        #first number is stored 

*         display message and get second number
                 
          lea      secondNumMsg,a1
          bsr      display            #branch to subroutine
          bsr      userInput
          move.l   d1,secondNum
          
*         display the first 2 terms 
          
          lea      termMsg,A1
          bsr      display 
          move.l   firstNum,d1
          move     #3,d0
          trap     #15
          lea      newLine,a1
          bsr      display

          move.l   secondNum,d1
          move     #3,d0
          trap     #15
          lea      newLine,a1
          bsr      display    


    

addition:    
*         add the two numbers and store them in sum
          move.l   secondNum,d1
          add.l    firstNum,d1
          move.l   d1,sum
         
*         exchange the values for next sum
          move.l   secondNum,firstNum
          move.l   sum,secondNum
          
*         display the terms          
          move     #3,d0
          move.l   sum,d1
          move.l   sum,d2
          trap     #15
          lea      newLine,a1
          bsr      display
          
*check if required numbers of terms are displayed or not, if yes than final message is displayed 
*else next term is calculated 
          sub.b    #1,elements
          move.b   elements, d1
          cmp.b    #0,elements
          beq      finalMessage
          bra      addition
          bra      end  
         
* the last line must jump to end otherwise the functions will be displayed 
*fuction to get user input
userInput: 
          move     #4,d0
          trap     #15
          rts   
finalMessage:
          lea     newLine,a1
          bsr     display
          lea     finalMsg,a1
          bsr     display
          rts  
            
display:
          move    #14,d0
          trap    #15
          rts 
  
end       STOP    #$2000




    
* Put variables and constants here
intro	        dc.b    $0D,$0A,$09,$09,$09,$09,$09
                dc.b	'------------------------------',$0D,$0A,$09,$09,$09,$09,$09
                dc.b	'      Fibonacci Sequence      ',$0D,$0A,$09,$09,$09,$09,$09
                dc.b	'------------------------------',$0D,$0A,$0D,$0A,0	           
sum 	        ds.l	1	reserve word of memory for sum2
firstNumMsg     dc.b	'Enter First Number: ',0	null terminated string
secondNumMsg    dc.b    'Enter Second Number: ',0
numTermMsg      dc.b    'Enter the number of terms wanted: ',0
finalMsg        dc.b    'The sequence has terminated!',$D,$A,0
termMsg         dc.b    'The terms are:',$D,$A,0
firstNum        ds.l    1
secondNum       ds.l    1
elements        dc.b    10

newLine         dc.b    $0D,$0A,0
    
           END    START        ; last line of source









*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
