//
//  File.swift
//  Bato Bato Pick
//
//  Created by Jarvis Vizconde on 2/27/23.
//

import Foundation

func SwitchCase(player : String , comp : String) -> String {
    
   
    
    
    switch true {
        
    case (player == "rock"  && comp == "scissors" ) : return("you win")
     
    case (player == "rock"  && comp == "paper" ) : return("defeat")
        
    case (player == "rock"  && comp == "rock" ) : return("draw")
        
        
        
    case (player == "paper"  && comp == "scissors" ) : return("defeat")
     
    case (player == "paper"  && comp == "paper" ) : return("draw")
        
    case (player == "paper"  && comp == "rock" ) : return("you win")
        
        
        
    case (player == "scissors"  && comp == "scissors" ) : return("draw")
     
    case (player == "scissors"  && comp == "paper" ) : return("you win")
        
    case (player == "scissors"  && comp == "rock" ) : return("defeat")
        
        
        
        
        
        
    default:
        return("ERROR")
        
        

    }
    
    
    
}
