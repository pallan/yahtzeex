#import <Cocoa/Cocoa.h>
#import "yahtzee.h"
#import "HighScores.h"


@interface yahtzeeController : NSObject
{
    IBOutlet NSTextField 	*totalScoreField, *playerField, *playerInputField;
    IBOutlet NSMatrix 		*topMatrix;
    IBOutlet NSMatrix 		*topTotalMatrix;
    IBOutlet NSMatrix 		*bottomMatrix;
    IBOutlet NSMatrix 		*highScoresMatrix;
    IBOutlet NSMatrix 		*diceMatrix;
    IBOutlet NSButton 		*rollButton, *showHintsSwitch, *zeroWarningSwitch, *clickLocksSwitch;
    IBOutlet id 		mainWindow;
    IBOutlet id 		prefsSheet, highScoresSheet;
    
    NSMutableArray		*dieImageArray, *highScoresArray;
    
    BOOL		isRollValid, showHints, showWarnings, clickLocksDice, windowSetForTriple;
    int			roll, newHighScoreIndex, animateCount;
    Yahtzee		*currentGame;
    
}
- (IBAction)rollDice:(id)sender;
- (IBAction)lockDice:(id)sender;
- (IBAction)setClickedFieldInTop:(id)sender;
- (IBAction)setClickedFieldInBottom:(id)sender;
- (IBAction)resetGame:(id)sender;
- (IBAction)newGame:(id)sender;
- (IBAction)openPrefsSheet:(id)sender;
- (IBAction)closePrefsSheet:(id)sender;
- (IBAction)newGame:(id)sender;
- (IBAction)clearHighScores:(id)sender;

- (IBAction)undo:(id)sender;

- (void) showScoreDuringPlay;
- (void) setScoreTotals;
- (void) resetForNextRoll;

//High Score Processing
- (void) processHighScores;
- (void)setHighScores:(NSMutableArray *)newArray;
- (IBAction)openHighScoresSheet:(id)sender;
- (IBAction)closeHighScoresSheet:(id)sender;
- (NSMutableArray *)highScoresArray;


//Window Delegate Methods
- (BOOL) windowShouldClose: (NSWindow *)sender;
- (void)didEndShouldCloseSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end
