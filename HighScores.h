//
//  HighScores.h
//  YahtzeeX
//
//  Created by pallan on Mon Dec 10 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HighScores : NSObject <NSCoding>
{
    NSString		*playerName;
    NSCalendarDate	*gameDate;
    int			score;
}

-(void) setWithName:(NSString *)name withDate:(NSCalendarDate *)date withScore:(int)score;

-(void) setPlayerName:(NSString *)value;
-(NSString *)playerName;

-(void) setGameDate:(NSCalendarDate *)date;
-(NSCalendarDate *)gameDate;

-(void) setScore:(int)score;
-(int)score;


@end
