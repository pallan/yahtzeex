//
//  HighScores.m
//  YahtzeeX
//
//  Created by pallan on Mon Dec 10 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "HighScores.h"

static NSString	*defaultName = @"Empty";

@implementation HighScores

- (id)init {
    self = [super init];
    [self setGameDate: [NSCalendarDate date]];
    [self setPlayerName: defaultName];
    [self setScore:0];
    
    return self;
}

- (void) dealloc {
    //NSLog(@"*** HighScores dealloc");
    [gameDate release];
    [playerName release];
    [super dealloc];
}


-(void) setWithName:(NSString *)newName withDate:(NSCalendarDate *)newDate withScore:(int)newScore {
    //NSLog(@"*** New Score Value: %d", newScore);
    [self setPlayerName:newName];
    [self setGameDate:newDate];
    [self setScore:newScore];
}

-(void) setPlayerName:(NSString *)value;
 {
    [playerName autorelease];
    playerName = [value copy];
   // NSLog(@"*** playerName is: %@", playerName);
 }

-(NSString *)playerName {
    //NSLog(@"*** playerName is: %@", playerName);
    return playerName;
}

-(void) setGameDate:(NSCalendarDate *)value {
    //NSLog(@"*** gameDate to Value: %@", value);
    [gameDate autorelease];
    gameDate = [value copy];
}

-(NSCalendarDate *)gameDate {
    return gameDate;
}

-(void) setScore:(int)value {
   // NSLog(@"*** Score set to Value: %d", value);
    score = value;
}

-(int)score {
    return score;
}

- (void) encodeWithCoder: (NSCoder *)coder {
   // NSLog(@"*** -(void)encodeWithCoder: ***" );
    [coder encodeObject:[NSNumber numberWithInt:[self score]]];
    [coder encodeObject:[self playerName]];
    [coder encodeObject:[self gameDate]];

}

- initWithCoder: (NSCoder *)coder {
  //  NSLog(@"*** -initWithCoder: ***" );
    [self setScore:[[coder decodeObject] intValue]];
    [self setPlayerName:[coder decodeObject]];
    [self setGameDate:[coder decodeObject]];

    return self;
}
@end
