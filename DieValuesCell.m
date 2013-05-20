#import "DieValuesCell.h"

@implementation DieValuesCell

- (DieValuesCell *)init {
    //NSLog(@"*** - (DieValuesCell *)init ***");
    
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
    // NSLog(@"*** - (BOOL)locked ***");
    return locked;
}

-(void) setDieArrayIndex:(int)value {
    //NSLog(@"*** - (void)setDieArrayIndex ***");
    dieArrayIndex = value;
}
-(int) dieArrayIndex {
     //NSLog(@"*** - (int)dieArrayIndex ***");
    return dieArrayIndex;
}

-(void) setDieValue:(int)value {
    //NSLog(@"*** - (void)setDieValue ***");
    dieValue = value;
}
-(int) dieValue {
     //NSLog(@"*** - (int)dieValue ***");
    return dieValue;
}
@end
