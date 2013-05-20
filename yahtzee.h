//
//  yahtzee.h
//  YahtzeeX
//
//  Created by pallan on Mon Nov 26 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Yahtzee : NSObject {

    BOOL		hasAYahtzee,
                        isUpperFull,
                        isLowerFull;

}

-(void) setHasAYahtzee:(BOOL)value;
-(BOOL) hasAYahtzee;
-(void) setIsUpperFull:(BOOL)value;
-(BOOL) isUpperFull;
-(void) setIsLowerFull:(BOOL)value;
-(BOOL) isLowerFull;

-(int) checkForThreeOfAKind:(NSMatrix *)diceMatrix;
-(int) checkForFourOfAKind:(NSMatrix *)diceMatrix;
-(int) checkForFullHouse:(NSMatrix *)diceMatrix;
-(int) checkForSmallStraight:(NSMatrix *)diceMatrix;
-(int) checkForLargeStraight:(NSMatrix *)diceMatrix;
-(BOOL) checkForYahtzee:(NSMatrix *)diceMatrix;
-(int) diceTotal:(NSMatrix *)diceMatrix;
-(BOOL) isGameOver:(NSMatrix *)topMatrix lowerMatrix:(NSMatrix *)bottomMatrix;


@end
