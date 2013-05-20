#import <Cocoa/Cocoa.h>

@interface ScoresCell : NSButtonCell
{
    BOOL	locked;
    int		scoreValue;
}


-(void) setLocked:(BOOL)value;
-(BOOL) locked;

-(void) setScoreValue:(int)value;
-(int) scoreValue;

@end
