#import <Cocoa/Cocoa.h>

@interface DieValuesCell : NSButtonCell
{
    int		dieArrayIndex;
    BOOL	locked;
    int		dieValue;
}


-(void) setDieArrayIndex:(int)value;
-(int) dieArrayIndex;

-(void) setLocked:(BOOL)value;
-(BOOL) locked;

-(void) setDieValue:(int)value;
-(int) dieValue;

@end
