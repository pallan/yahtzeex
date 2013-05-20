#import "ScoresCell.h"

@implementation ScoresCell
- (ScoresCell *)init {
    //NSLog(@"*** - (ScoresCell *)init ***");
    
    self = [super init];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

-(void) setLocked:(BOOL)value {
    
    //NSLog(@"*** - (void)setLocked ***");
    locked = value;
}
-(BOOL) locked {
    //NSLog(@"*** - (BOOL)locked ***");
    return locked;
}

-(void) setScoreValue:(int)value {
    //NSLog(@"*** - (void)setDieValue ***");
    scoreValue = value;
}
-(int) scoreValue {
     //NSLog(@"*** - (int)dieValue ***");
    return scoreValue;
}
@end
