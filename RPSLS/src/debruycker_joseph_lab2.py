# CSCI 305
# Lab 2:  Python
# March 2015
# Joseph DeBruycker
# 01213128
#
# This Python module is a program that creates a variation of the Rock-Paper-Scissors
# game called Rock-Paper-Scissors-Lizard-Spock.  It first implements classes to represent
# each of the five elements of the game and how they interact with each other element.
# It then goes on to implement classes for various A.I. "players," as well as an interface
# for human players.  Finally the program provides a menu and interface for running and
# playing this game.

import random


# A parent class for the different elements of the game.  It implements methods 
# each game element will need:  a constructor that sets the element name, a method
# to return that name, and a virtual method that each game element will implement
# to determine their interaction with each of the other elements.
class Element:
    def __init__(self, myName):
        self._name = myName
        
    def name(self):
        return self._name
    
    def compareTo(self, opponent):
        raise NotImplementedError("Not yet implemented")
    
    
# The first element, rock, which wins against scissors and lizard but loses to paper and spock    
class Rock(Element):
    def compareTo(self, opponent):
        if opponent.name() == "rock":
            return "Rock equals Rock", "Tie"
        elif opponent.name() == "paper":
            return "Paper covers Rock", "Lose"
        elif opponent.name() == "scissors":
            return "Rock crushes Scissors", "Win"
        elif opponent.name() == "lizard":
            return "Rock crushes Lizard", "Win"
        elif opponent.name() == "spock":
            return "Spock vaporizes Rock", "Lose"
        else:
            print("Uh oh, invalid element!")
            
            
# The second element, paper, which wins against rock and spock but loses to scissors and lizard           
class Paper(Element):
    def compareTo(self, opponent):
        if opponent.name() == "rock":
            return "Paper covers Rock", "Win"
        elif opponent.name() == "paper":
            return "Paper equals Paper", "Tie"
        elif opponent.name() == "scissors":
            return "Scissors cut Paper", "Lose"
        elif opponent.name() == "lizard":
            return "Lizard eats Paper", "Lose"
        elif opponent.name() == "spock":
            return "Paper disproves Spock", "Win"
        else:
            print("Uh oh, invalid element!")
            
            
# The third element, scissors, which wins against paper and lizard but loses to rock and spock            
class Scissors(Element):
    def compareTo(self, opponent):
        if opponent.name() == "rock":
            return "Rock crushes Scissors", "Lose"
        elif opponent.name() == "paper":
            return "Scissors cut Paper", "Win"
        elif opponent.name() == "scissors":
            return "Scissors equals Scissors", "Tie"
        elif opponent.name() == "lizard":
            return "Scissors decapitate Lizard", "Win"
        elif opponent.name() == "spock":
            return "Spock smashes Scissors", "Lose"
        else:
            print("Uh oh, invalid element!")
            
            
# The fourth element, lizard, which wins against paper and spock but loses to scissors and rock            
class Lizard(Element):
    def compareTo(self, opponent):
        if opponent.name() == "rock":
            return "Rock crushes Lizard", "Lose"
        elif opponent.name() == "paper":
            return "Lizard eats Paper", "Win"
        elif opponent.name() == "scissors":
            return "Scissors decapitate Lizard", "Lose"
        elif opponent.name() == "lizard":
            return "Lizard equals Lizard", "Tie"
        elif opponent.name() == "spock":
            return "Lizard poisons Spock", "Win"
        else:
            print("Uh oh, invalid element!")
            
            
# The fifth element, spock, which wins against rock and scissors but loses to paper and lizard            
class Spock(Element):
    def compareTo(self, opponent):
        if opponent.name() == "rock":
            return "Spock vaporizes Rock", "Win"
        elif opponent.name() == "paper":
            return "Paper disproves Spock", "Lose"
        elif opponent.name() == "scissors":
            return "Spock smashes Scissors", "Win"
        elif opponent.name() == "lizard":
            return "Lizard poisons Spock", "Lose"
        elif opponent.name() == "spock":
            return "Spock equals Spock", "Tie"
        else:
            print("Uh oh, invalid element!")
            
            
###SELF-CHECK##################            
# rock = Rock('rock')
# paper = Paper('paper')
# print (rock.compareTo(paper))
# print (paper.compareTo(rock))
# print (rock.compareTo(rock))
###############################


# This code instantiates each element and stores the created objects in a list for later use
rock = Rock('rock')
paper = Paper('paper')
scissors = Scissors('scissors')
lizard = Lizard('lizard')
spock = Spock('spock')

moves = [rock, paper, scissors, lizard, spock]


# A parent class for the A.I. players of the game.  These players will have a name 
# and a method to access that name, as well as a method that defines how they will 
# choose their moves when playing
class Player:
    def __init__(self, myName):
        self._name = myName.strip()
        
    def name(self):
        return self._name
    
    def play(self):
        raise NotImplementedError("Not yet implemented")
        

# Always plays Lizard        
class StupidBot(Player):
    def play(self):
        return moves[3]
    

# Plays a random move
class RandomBot(Player):
    def play(self):
        return moves[random.randint(0,4)]


# Plays each move in a cycle
class IterativeBot(Player):
    i = -1
    
    def play(self):
        self.i += 1
        if self.i == 5: self.i = 0
        return moves[self.i]

    
# Plays the move his opponent played last; plays scissors on the first move
class LastPlayBot(Player):
    nextMove = 2
    
    def getNextMove(self, opponentMove):
        self.nextMove = opponentMove
        
    def play(self):
        return moves[self.nextMove]   
    

# Provides a menu for a human player to make move choices    
class Human(Player):
    def play(self):
        print ("  " + self.name() + "'s turn:")
        print ("  (1) : Rock")
        print ("  (2) : Paper")
        print ("  (3) : Scissors")
        print ("  (4) : Lizard")
        print ("  (5) : Spock")
        
        while True:
            try:
                x = int(input(" Enter your move: "))
                if (x > 0 and x < 6): break
                else: print("  Invalid move.  Please try again.")
            except ValueError:
                print("  Not even close baby!")
        
        return moves[x-1]


# The ultimate in RPSLS A.I. Technology.  It never loses!
class MyBot(Player):
    def play(self):
        return object # A.I. is handled below in main...
    
    
###SELF CHECK#####################
# p1 = StupidBot('StupidBot')
# p2 = RandomBot('RandomBot')
# p3 = IterativeBot('IB')
# p4 = Human('Dude')
# p5 = LastPlayBot('Copycat')
##################################



# The main script of this module runs the game, asking the user to choose which players
# will face off in a battle of RPSLP.  The game is then simulated (or played, if the user
# chooses human players) and the game results are displayed.
if __name__ == "__main__":
    
    # Variable for scorekeeping
    p1wins = 0
    p2wins = 0
    
    # Welcome message
    print ("Welcome to Rock, Paper, Scissors, Lizard, Spock, implemented by Joe DeBruycker\n")
    
    # A.I. menu
    print ("Please choose two players:")
    print ("   (1) Human")
    print ("   (2) StupidBot")
    print ("   (3) RandomBot")
    print ("   (4) IterativeBot")
    print ("   (5) LastPlayBot")
    print ("   (6) MyBot\n")
    
    # Choose player 1
    while True:
        try:
            p1 = int(input("Select player 1: "))
            if (p1 > 0 and p1 < 7): break
            else: print("Invalid selection.  Please try again.")
        except ValueError:
            print("Not even close baby!\n")
    
    if p1 == 1:
        p1name = input("Enter Player 1's name: ")   
        p1 = Human(p1name)
    elif p1 == 2:
        p1 = StupidBot('StupidBot')
    elif p1 == 3:
        p1 = RandomBot('RandomBot')
    elif p1 == 4:
        p1 = IterativeBot('IterativeBot')
    elif p1 == 5:
        p1 = LastPlayBot('LastPlayBot')
    elif p1 == 6:
        input("WARNING! ARE YOU SURE YOU WANT TO UNLEASH THE DOOMBOT? (y/n) ")
        print("TOO LATE, YOUR FATE IS SEALED!\n")
        p1 = MyBot('DoomBot')
    
    # Choose player 2
    while True:
        try:
            p2 = int(input("Select player 2: "))
            if (p2 > 0 and p2 < 7): break
            else: print("Invalid selection.  Please try again.")
        except ValueError:
            print("Not even close baby!\n")    

    if p2 == 1:
        p2name = input("Enter Player 2's name: ")   
        p2 = Human(p2name)
    elif p2 == 2:
        p2 = StupidBot('StupidBot')
    elif p2 == 3:
        p2 = RandomBot('RandomBot')
    elif p2 == 4:
        p2 = IterativeBot('IterativeBot')
    elif p2 == 5:
        p2 = LastPlayBot('LastPlayBot')
    elif p2 == 6:
        if p1.name() == 'DoomBot':
            print ("\nDoomBot VS DoomBot!  The universe implodes!  ")
            raise SystemExit('ByeBye!')
        input("WARNING! ARE YOU SURE YOU WANT TO UNLEASH THE DOOMBOT? (y/n) ")
        print("TOO LATE, YOUR FATE IS SEALED!")
        p2 = MyBot('DoomBot')
    
    
    # The battle begins!
    print ("\n" + p1.name() + " vs " + p2.name() + ". Go!")
    
    # 5 rounds...
    for i in range(5):
        print("\nRound " + str(i+1) + ":")
        
        # Determine initial moves
        p1move = p1.play()
        p2move = p2.play()
        
        # A.I. logic for Doombot always copies the opponent's current move
        if p1.name() == 'DoomBot': p1move = p2move
        if p2.name() == 'DoomBot': p2move = p1move
        
        # A.I. logic for LastPlayBot copies the opponent's last move
        if p1.name() == 'LastPlayBot': p1.getNextMove(moves.index(p2move))
        if p2.name() == 'LastPlayBot': p2.getNextMove(moves.index(p1move))
        
        # Display the moves            
        print ("  " + p1.name() + " chooses " + p1move.name())
        print ("  " + p2.name() + " chooses " + p2move.name())
        
        # Display the results and keep score
        result = p1move.compareTo(p2move)
        print ("  " + result[0])
        if result[1] == "Win":
            print("  " + p1.name() + " won the round")
            p1wins += 1
        elif result[1] == "Tie":
            print("  Round was a tie")
        else:
            print("  " + p2.name() + " won the round")
            p2wins += 1
            
            
    # Print the results of the match
    print ("\nThe score is " + str(p1wins) + " to " + str(p2wins))
    if (p1wins > p2wins):
        print (p1.name() + " is the winner!")
    elif (p2wins > p1wins):
        print (p2.name() + " is the winner!")
    else:
        print ("Game was a draw.")
        if (p1.name() == "DoomBot" or p2.name() == "DoomBot"):
            print ("DoomBot never loses!! Bahahaha!!")
    print ("\nGoodbye!")
    