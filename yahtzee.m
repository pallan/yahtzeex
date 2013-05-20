//
//  yahtzee.m
//  YahtzeeX
//
//  Created by pallan on Mon Nov 26 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "Yahtzee.h"
#import "DieValuesCell.h"

@implementation Yahtzee

/* *******************************



********************************* */
- (Yahtzee *) init {
    //NSLog(@"*** - (Yahtzee *)init ***");
    self = [super init];
    
    [self setIsLowerFull:NO];
    [self setIsUpperFull:NO];
    [self setHasAYahtzee:NO];
    
    return self;
}

- (void) dealloc {
    [super dealloc];
}

/* *******************************



********************************* */
- (void) setHasAYahtzee:(BOOL)value {
   
    hasAYahtzee = value;
}

- (BOOL) hasAYahtzee {
    return hasAYahtzee;
}

- (void) setIsUpperFull:(BOOL)value {
   
    isUpperFull = value;
}

- (BOOL) isUpperFull {
    return isUpperFull;
}

- (void) setIsLowerFull:(BOOL)value {
   
    isLowerFull = value;
}

- (BOOL) isLowerFull {
    return isLowerFull;
}
/* *******************************



********************************* */
- (int) checkForThreeOfAKind:(NSMatrix *)diceMatrix {
    int		i, dieValues[5], temp;
    BOOL	sorted = FALSE;
    
    //NSLog(@"*** (int) checkForThreeOfAKind:");
    for (i=0; i < 5; i++) {
        dieValues[i] = [[diceMatrix cellAtRow:i column:0] dieValue];
        //NSLog(@"Die Value (pre-sort): %d", dieValues[i]);
    }

   while (!sorted) {
      sorted = TRUE;

      for (i=0;i<4;i++) {
         if (dieValues[i] > dieValues[i+1]) {
            temp = dieValues[i];
            dieValues[i] = dieValues[i+1];
            dieValues[i+1] = temp;
            sorted  = FALSE;
         }
      }
   }

     if 	((dieValues[0] == dieValues[1]) && (dieValues[1] == dieValues[2])) return [self diceTotal:(NSMatrix *)diceMatrix]; 
     else if 	((dieValues[1] == dieValues[2]) && (dieValues[2] == dieValues[3])) return [self diceTotal:(NSMatrix *)diceMatrix];
     else if 	((dieValues[2] == dieValues[3]) && (dieValues[3] == dieValues[4])) return [self diceTotal:(NSMatrix *)diceMatrix];
     else	return 0;
}
/* *******************************



********************************* */
-(int) checkForFourOfAKind:(NSMatrix *)diceMatrix {
    int		i, dieValues[5], temp;
    BOOL	sorted = FALSE;
    
    //NSLog(@"*** (int) checkForFourOfAKind:");
    
    for (i=0; i < 5; i++) {
        dieValues[i] = [[diceMatrix cellAtRow:i column:0] dieValue];
    }

   while (!sorted) {
      sorted = TRUE;

      for (i=0;i<4;i++) {
         if (dieValues[i] > dieValues[i+1]) {
            temp = dieValues[i];
            dieValues[i] = dieValues[i+1];
            dieValues[i+1] = temp;
            sorted  = FALSE;
         }
      }
   }

     if 	((dieValues[0] == dieValues[1]) && (dieValues[1] == dieValues[2]) && (dieValues[2] == dieValues[3])) return [self diceTotal:(NSMatrix *)diceMatrix]; 
     else if 	((dieValues[1] == dieValues[2]) && (dieValues[2] == dieValues[3]) && (dieValues[3] == dieValues[4])) return [self diceTotal:(NSMatrix *)diceMatrix];
     else	return 0;

}

/* *******************************



********************************* */
-(int) checkForFullHouse:(NSMatrix *)diceMatrix {
    int one, two, three, four, five;

   // NSLog(@"*** (int) checkForFullHouse:");
    
    one = [[diceMatrix cellAtRow:0 column:0] dieValue];
    two = [[diceMatrix cellAtRow:1 column:0] dieValue];
    three = [[diceMatrix cellAtRow:2 column:0] dieValue];
    four = [[diceMatrix cellAtRow:3 column:0] dieValue];
    five = [[diceMatrix cellAtRow:4 column:0] dieValue];
    
    if      ((one == two)&&(two == three)&&(four == five))   return 25;
    else if ((one == two)&&(two == four)&&(three == five))   return 25;
    else if ((one == two)&&(two == five)&&(three == four))   return 25;
    else if ((one == three)&&(three == four)&&(two == five)) return 25;
    else if ((one == three)&&(three == five)&&(two == four)) return 25;
    else if ((one == four)&&(four == five)&&(two == three))  return 25;
    else if ((two == three)&&(three == four)&&(one == five)) return 25;
    else if ((two == three)&&(three == five)&&(one == four)) return 25;
    else if ((two == four)&&(four == five)&&(one == three))  return 25;
    else if ((three == four)&&(four == five)&&(one == two))  return 25;
    else                                                     return 0;

}
/* *******************************



********************************* */
-(int) checkForSmallStraight:(NSMatrix *)diceMatrix {

    int dieValues[5], i, temp;
    BOOL sorted = FALSE;

    //NSLog(@"*** (int) checkForSmallStraight:");

    for (i=0; i < 5; i++) {
        dieValues[i] = [[diceMatrix cellAtRow:i column:0] dieValue];
    }

   while (!sorted) {
      sorted = TRUE;

      for (i=0;i<4;i++) {
         if (dieValues[i] > dieValues[i+1]) {
            temp = dieValues[i];
            dieValues[i] = dieValues[i+1];
            dieValues[i+1] = temp;
            sorted  = FALSE;
         } else if (dieValues[i] == dieValues[i+1]) {
            dieValues[i+1] += 7;
            sorted = FALSE;
         }
      }
   }

    if ((dieValues[1] == dieValues[0]+1) && (dieValues[2] == dieValues[1]+1) && (dieValues[3] == dieValues[2]+1) ) {
        return 30;
    } else if ((dieValues[2] == dieValues[1]+1) && (dieValues[3] == dieValues[2]+1) && (dieValues[4] == dieValues[3]+1) ) {
        return 30;
    } else 
        return 0;;
}
/* *******************************



********************************* */
-(int) checkForLargeStraight:(NSMatrix *)diceMatrix {
    
    int dieValues[5], i, temp;
    BOOL sorted = FALSE;

    //NSLog(@"*** (int) checkForLargeStraight:");
    
    for (i=0; i < 5; i++) {
        dieValues[i] = [[diceMatrix cellAtRow:i column:0] dieValue];
    }

   while (!sorted) {
      sorted = true;

      for (i=0;i<4;i++) {
         if (dieValues[i] > dieValues[i+1]) {
            temp = dieValues[i];
            dieValues[i] = dieValues[i+1];
            dieValues[i+1] = temp;
            sorted  = false;
         }
      }
   }

   if ((dieValues[1] == dieValues[0]+1) && (dieValues[2] == dieValues[1]+1) && (dieValues[3] == dieValues[2]+1) &&
   (dieValues[4] == dieValues[3]+1))
      return 40;
   else
      return 0;;
}	
/* *******************************



********************************* */
-(BOOL) checkForYahtzee:(NSMatrix *)diceMatrix {
    int		i, dieValues[5], temp; //newYahtzeeBonus;
    BOOL	sorted = FALSE;
    
    for (i=0; i < 5; i++) {
        dieValues[i] = [[diceMatrix cellAtRow:i column:0] dieValue];
    }

   while (!sorted) {
      sorted = TRUE;

      for (i=0;i<4;i++) {
         if (dieValues[i] > dieValues[i+1]) {
            temp = dieValues[i];
            dieValues[i] = dieValues[i+1];
            dieValues[i+1] = temp;
            sorted  = FALSE;
         }
      }
   }

     if ( (dieValues[0] == dieValues[1]) && (dieValues[1] == dieValues[2]) && (dieValues[2] == dieValues[3]) && (dieValues[3] == dieValues[4]) ) 
        return TRUE;
    else	
        return FALSE;
        
    return FALSE;
}
/* *******************************



********************************* */
- (int) diceTotal:(NSMatrix *)diceMatrix {
    int i, dieValue, sumOfDice = 0;
    
    for (i=0; i < 5; i++) {
        dieValue = [[diceMatrix cellAtRow:i column:0] dieValue];
        sumOfDice += dieValue;
    }
    
    return sumOfDice;
}
/* *******************************



********************************* */
- (BOOL) isGameOver:(NSMatrix *)topMatrix lowerMatrix:(NSMatrix *)bottomMatrix {
        int	i, j;

        [self setIsUpperFull:YES];
        [self setIsLowerFull:YES];
        
        for (j=0; j < [topMatrix numberOfColumns]; j++) {
            for (i=0; i < 6; i++) {
                if (![[topMatrix cellAtRow:i column:j] locked]) {
                    [self setIsUpperFull:NO];
                }
            }
            for (i=0; i < 8; i++) {
                if (![[bottomMatrix cellAtRow:i column:j] locked]) {
                    [self setIsLowerFull:NO];
                }
            }
        }
        
        if (([self isLowerFull]) && ([self isUpperFull])) {
            return TRUE;
        }
        return FALSE;
}
@end
