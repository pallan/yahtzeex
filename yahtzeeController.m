#import "yahtzeeController.h"
#import "Yahtzee.h"
#import "DieValuesCell.h"
#import "ScoresCell.h"
#import "HighScores.h"

@implementation yahtzeeController
// Constants for User Defaults (preferences)
#define preferences 	[NSUserDefaults standardUserDefaults]
#define kDefaultName	NSFullUserName()
#define	kNameKey	@"Player"
#define kHintsKey	@"Hints"
#define kWarningsKey	@"Warnings"
#define kDiceLockKey	@"ClickLock"
#define	kHighScoresKey  @"Scores"

// Score Constants
#define	kUpperBonus		35
#define	kFullHouseScore		25
#define	kLargeStraightScore	40
#define kSmallStraightScore	30
#define kYahtzeeScore		50	
#define kYahtzeeBonusScore	100

// Roll Button Titles
#define	kFirstRoll	@"Roll"
#define kSecondRoll	@"Roll Again"
#define kThirdRoll	@"Last Roll"
#define kDoneRolls	@"Done"
#define kGameOver	@"Game Over"

// Other Constants
#define	kEmptyString	@""
#define kNewHighScoreColor	[NSColor redColor]
#define kHighScoresFile @"/Library/Preferences/YahtzeeHighScores.yscores"
#define kDateFormat	@"%m/%d/%Y"
#define	kTICKS		6

static float RandFloat(void)
    // Returns a random floating point number between
    // 0.0 and 1.0.
{
    return ((float) rand() / (float) RAND_MAX);
}
/* *******************************



********************************* */

-(yahtzeeController *) init {

    self = [super init];
    
    currentGame = [[Yahtzee alloc] init];
    highScoresArray = [[NSUnarchiver unarchiveObjectWithFile:kHighScoresFile] retain];
    
    if (!highScoresArray) {
        highScoresArray = [[NSMutableArray alloc] initWithCapacity:0];
    };
    
    roll = 0;

    isRollValid = FALSE;
    windowSetForTriple = FALSE;
    newHighScoreIndex = -1;
    animateCount = 0;
    
    srand(clock());

    return self;

}

/* *******************************



********************************* */
- (void)awakeFromNib {

        int		i, j;
        NSBundle	*programBundle = [NSBundle bundleForClass:[self class]];
        NSArray		*imageFiles;

        imageFiles = [NSArray arrayWithObjects:  @"one", @"two",  @"three", @"four", @"five",@"six", @"one_locked",@"two_locked", @"three_locked",@"four_locked", @"five_locked", @"six_locked", @"blank", nil];
    
        dieImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (i=0; i < 13; i++) {
            NSString	*fileName = [[NSString alloc] initWithString:[programBundle pathForResource:[imageFiles objectAtIndex:(i)] ofType:@"gif"]];
            NSImage	*dieImage = [[NSImage alloc] initWithContentsOfFile: fileName];
            [dieImageArray addObject: dieImage];
            [fileName release];
            [dieImage release];
        }
        // create the user defaults here if none exists
        if (!preferences) {
        // create a dictionary
            NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionary];
        // put default prefs in the dictionary
            [defaultPrefs setObject:[NSString stringWithFormat:kDefaultName] forKey:kNameKey];
            [defaultPrefs setObject:NO forKey:kWarningsKey];
            [defaultPrefs setObject:NO forKey:kHintsKey];
            [defaultPrefs setObject:NO forKey:kDiceLockKey];
        // register the dictionary of defaults
            [preferences registerDefaults: defaultPrefs];
            
        }

        showHints = [preferences boolForKey:kHintsKey];
        showWarnings = [preferences boolForKey:kWarningsKey];
        clickLocksDice = [preferences boolForKey:kDiceLockKey];
        if ([preferences stringForKey:kNameKey] != nil) 
            [playerField setStringValue:[preferences stringForKey:kNameKey]];
        else
            [playerField setStringValue:kDefaultName];
    
        for (i=0; i < 5; i++) {
            [[diceMatrix cellAtRow:i column:0] setImagePosition:NSImageOnly];
        }
    /*    
        for (j=1; j <  3; j++) {
            for (i=0; i < [topMatrix numberOfRows]; i++) {
                [[topMatrix cellAtRow:i column:j] setTitle:kEmptyString];
                [[topMatrix cellAtRow:i column:j] setBordered:NO];
                [[topMatrix cellAtRow:i column:j] setEnabled:NO];
                [[topMatrix cellAtRow:i column:j] setCellAttribute:NSCellHighlighted to:NO];
            }
            for (i=0; i < [bottomMatrix numberOfRows]; i++) {
                [[bottomMatrix cellAtRow:i column:j] setTitle:kEmptyString];
                [[bottomMatrix cellAtRow:i column:j] setBordered:NO];
                [[bottomMatrix cellAtRow:i column:j] setEnabled:NO];
                [[bottomMatrix cellAtRow:i column:j] setCellAttribute:NSCellHighlighted to:NO];
            }
             for (i=0; i < [topTotalMatrix numberOfRows]; i++) {
                [[topTotalMatrix cellAtRow:i column:j] setTitle:kEmptyString];
                [[topTotalMatrix cellAtRow:i column:j] setBordered:NO];
                [[topTotalMatrix cellAtRow:i column:j] setEnabled:NO];
                [[topTotalMatrix cellAtRow:i column:j] setCellAttribute:NSCellHighlighted to:NO];
            }
        }
        */
        [self newGame:nil];
    
}
/* *******************************



********************************* */
- (void)dealloc {
   [highScoresArray release];
   [dieImageArray release];
   [currentGame release];
   [super dealloc];
}


/* *******************************



********************************* */
- (IBAction)newGame:(id)sender
{
    if ([NSApp mainWindow] == nil) {
        [mainWindow makeKeyAndOrderFront:nil];
    }
    [self resetGame:nil];
}
/* *******************************



********************************* */
- (IBAction)rollDice:(id)sender
{
     int  i;
     NSTimer	*timer;
    //NSLog(@"*** - (IBAction)rollDice ***");
     roll++;
    switch (roll) {
        case 1:
            [rollButton setTitle:kSecondRoll];
            for (i=0; i < 5; i++) {
                [[diceMatrix cellAtRow:i column:0] setEnabled:YES];
                [[diceMatrix cellAtRow:i column:0] setLocked:NO];
            }
            break;
        case 2:
            [rollButton setTitle:kThirdRoll];
            break;
        case 3:
            [rollButton setTitle:kDoneRolls];
            [rollButton setEnabled:NO];
            break;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateDice:) userInfo:nil repeats:YES] retain];

}
- (void)animateDice:(NSTimer *)aTimer
{
    int 	i, index;
    
     for (i=0; i < 5; i++) {
        if (![[diceMatrix cellAtRow:i column:0] locked]) {
            index = (6 * RandFloat() + 1);
            [[diceMatrix cellAtRow:i column:0] setImage:[dieImageArray objectAtIndex:(index-1)]];
            [[diceMatrix cellAtRow:i column:0] setDieArrayIndex:(index-1)];
            [[diceMatrix cellAtRow:i column:0] setDieValue:index];
        }
    }
    animateCount++;
    
    if ( animateCount > kTICKS ) {
        [aTimer invalidate];
        [aTimer release];
        animateCount = 0;
        isRollValid = TRUE;
        if (clickLocksDice) {
             for (i=0; i < [diceMatrix numberOfRows]; i++) {
                [[diceMatrix cellAtRow:i column:0] setImage:[dieImageArray objectAtIndex:([[diceMatrix cellAtRow:i column:0] dieArrayIndex]+6)]];
                [[diceMatrix cellAtRow:i column:0] setLocked:YES];
            }
        }
        
        if (showHints) 
            [self showScoreDuringPlay];
    }
    
}
/* *******************************



********************************* */
- (IBAction)lockDice:(id)sender
{
    int i,rowClicked = [diceMatrix selectedRow];
    int arrayIndex = [[diceMatrix cellAtRow:rowClicked column:0] dieArrayIndex];
    
    for (i=0; i < [diceMatrix numberOfRows]; i++)
        NSLog(@"*** - diceMatrix %d state is: %d", i, [[diceMatrix cellAtRow:i column:0] isHighlighted] );
    
    [[diceMatrix cellAtRow:2 column:0] setHighlighted:NO];
    if ([[diceMatrix cellAtRow:rowClicked column:0] locked]) {
        [[diceMatrix cellAtRow:rowClicked column:0] setImage:[dieImageArray objectAtIndex:arrayIndex]];
        [[diceMatrix cellAtRow:rowClicked column:0] setLocked:NO];
    } else {
        [[diceMatrix cellAtRow:rowClicked column:0] setImage:[dieImageArray objectAtIndex:(arrayIndex+6)]];
        [[diceMatrix cellAtRow:rowClicked column:0] setLocked:YES];
    }
}

/* *******************************



********************************* */
- (void) resetForNextRoll {
    int	i;
    
    if (![currentGame isGameOver:topMatrix lowerMatrix:bottomMatrix]) {
        if (![rollButton isEnabled]) {
            [rollButton setEnabled:YES];
        }
        [rollButton setTitle:kFirstRoll];
        roll = 0;
        if (showHints) {
            for (i=0; i < [topMatrix numberOfRows]; i++) {
                 if (![[topMatrix cellAtRow:i column:0] locked])
                    [[topMatrix cellAtRow:i column:0] setTitle:nil];
            }
            for (i=0; i < [bottomMatrix numberOfRows]; i++) {
                 if (![[bottomMatrix cellAtRow:i column:0] locked])
                    [[bottomMatrix cellAtRow:i column:0] setTitle:nil];
            }
        }
    } else {
        [rollButton setEnabled:NO];
        [rollButton setTitle:kGameOver];
        [self processHighScores];
    }
    for (i=0; i < 5; i++) {
        if ([[diceMatrix cellAtRow:i column:0] locked]) {
            [[diceMatrix cellAtRow:i column:0] setLocked:NO];
        }
        [[diceMatrix cellAtRow:i column:0] setEnabled:NO];
        [[diceMatrix cellAtRow:i column:0] setImage:[dieImageArray objectAtIndex:12]];
    }
    
    isRollValid = FALSE;
}

/* *******************************



********************************* */
- (IBAction)setClickedFieldInTop:(id)sender
{
    int		i, answer, total = 0;
    int 	diceValueToCheck = [topMatrix selectedRow];
    int		selectedColumn = [topMatrix selectedColumn];
    
    //NSLog(@"*** - (IBAction)setClickedFieldInTop ***");
    
    if ( (![[topMatrix cellAtRow:diceValueToCheck column:selectedColumn] locked]) && (isRollValid) ) {    
        
        if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
            total = [currentGame diceTotal:diceMatrix];
            [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
        } else {
            for (i=0; i < 5; i++) {
                if ([[diceMatrix cellAtRow:i column:0] dieValue] == diceValueToCheck + 1) {
                    total = total + [[diceMatrix cellAtRow:i column:0] dieValue];
                }
            }
        }
        if ((total == 0) && (showWarnings)) {
            answer = NSRunAlertPanel(@"Zero Entry Warning", @"Are you sure you want to enter a 0 for this score?", @"Yes", @"No", nil);
        } else
            answer = NSAlertDefaultReturn;
        
        if (answer == NSAlertDefaultReturn) {
        
            [[topMatrix cellAtRow:diceValueToCheck column:selectedColumn] setLocked:YES];
            [[topMatrix cellAtRow:diceValueToCheck column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", total]];
            
            [self setScoreTotals];
            [self resetForNextRoll];
        }

    } else
        NSBeep();
        //NSLog(@"*** Field locked: %d", diceValueToCheck);
}
/* *******************************



********************************* */
- (IBAction)setClickedFieldInBottom:(id)sender
{
    int 	clickedField = [bottomMatrix selectedRow];
    int		selectedColumn = [bottomMatrix selectedColumn];
    int 	returnedValue, answer;
    
    //NSLog(@"*** - (IBAction)setClickedFieldInBottom ***");
    
    if ( (![[bottomMatrix cellAtRow:clickedField column:selectedColumn] locked]) && (isRollValid) ) {
    
        switch (clickedField) {
            case 0:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = [currentGame diceTotal:diceMatrix];
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
                } else
                    returnedValue = [currentGame checkForThreeOfAKind:diceMatrix];
                break;
            case 1:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = [currentGame diceTotal:diceMatrix];
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
                 } else 
                    returnedValue = [currentGame checkForFourOfAKind:diceMatrix];
                break;
            case 2:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = kFullHouseScore;
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
                } else    
                    returnedValue = [currentGame checkForFullHouse:diceMatrix];
                break;
            case 3:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = kSmallStraightScore;
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
                } else    
                    returnedValue = [currentGame checkForSmallStraight:diceMatrix];
                break;
            case 4:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = kLargeStraightScore;
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
                } else    
                    returnedValue = [currentGame checkForLargeStraight:diceMatrix];
                break;
            case 5:
                if ([currentGame checkForYahtzee:diceMatrix]) {
                    returnedValue = kYahtzeeScore;
                    [currentGame setHasAYahtzee:YES];
                } else
                    returnedValue = 0;
                break;
            case 6:
               break;
            case 7:
                if ([currentGame hasAYahtzee] && [currentGame checkForYahtzee:diceMatrix]) 
                    [[bottomMatrix cellAtRow:6 column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", ([[[bottomMatrix cellAtRow:6 column:selectedColumn] title] intValue] + kYahtzeeBonusScore)]];
   
                returnedValue = [currentGame diceTotal:diceMatrix];
                break;
        }
        if ((returnedValue == 0) && (showWarnings)) {
            answer = NSRunAlertPanel(@"Zero Entry Warning", @"Are you sure you want to enter a 0 for this score?", @"Yes", @"No", nil);
        } else
            answer = NSAlertDefaultReturn;
        
        if (answer == NSAlertDefaultReturn) {
            [[bottomMatrix cellAtRow:clickedField column:selectedColumn] setTitle:[NSString stringWithFormat:@"%d", returnedValue]];
            [[bottomMatrix cellAtRow:clickedField column:selectedColumn] setLocked:YES];
            
            //NSLog(@"*** Field locked: %d", clickedField);
            [self setScoreTotals];
            
            [self resetForNextRoll];
        }
    } else
        NSBeep();
        
}

/* *******************************



********************************* */
- (IBAction)resetGame:(id)sender
{
        int	i, j;
        
       //NSLog(@"*** - (IBAction)resetGame ***");
        for (j=0; j < [bottomMatrix numberOfColumns]; j++) {
            for (i=0; i < [bottomMatrix numberOfRows]; i++) {
                [[bottomMatrix cellAtRow:i column:j] setTitle:nil];
                [[bottomMatrix cellAtRow:i column:j] setLocked:NO];
            }
            [[bottomMatrix cellAtRow:6 column:j] setLocked:YES];
            
            for (i=0; i < [topMatrix numberOfRows]; i++) {
                [[topMatrix cellAtRow:i column:j] setTitle:nil];
                [[topMatrix cellAtRow:i column:j] setLocked:NO];
            }
        }
        
        for (i=0; i < 5; i++) {
            if ([[diceMatrix cellAtRow:i column:0] locked]) {
                [[diceMatrix cellAtRow:i column:0] setLocked:NO];
            }
            [[diceMatrix cellAtRow:i column:0] setImage:[dieImageArray objectAtIndex:12]];
            [[diceMatrix cellAtRow:i column:0] setDieValue:0];
            [[diceMatrix cellAtRow:i column:0] setEnabled:NO];
            //[[diceMatrix cellAtRow:i column:0] setTitle:kEmptyString];
        }

        [currentGame setHasAYahtzee:NO];
        [currentGame setIsLowerFull:NO];
        [currentGame setIsUpperFull:NO];
        roll = 0;
        [rollButton setTitle:kFirstRoll];
        [rollButton setEnabled:YES];
        
        [totalScoreField setStringValue:kEmptyString];
        for (j=0; j < [topTotalMatrix numberOfColumns]; j++) {
            [[topTotalMatrix cellAtRow:0 column:j] setTitle:kEmptyString];
            [[topTotalMatrix cellAtRow:1 column:j] setTitle:kEmptyString];
        }
}

/* *******************************



********************************* */
- (IBAction)openPrefsSheet:(id)sender
{
    [NSApp beginSheet:prefsSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
    if (showWarnings) 
        [zeroWarningSwitch setState:NSOnState];
    if (showHints) 
        [showHintsSwitch setState:NSOnState];
    if (clickLocksDice)
        [clickLocksSwitch setState:NSOnState];
        
    [playerInputField setStringValue:[playerField stringValue]];
}


/* *******************************



********************************* */
- (IBAction)closePrefsSheet:(id)sender
{
    int		row;
    NSString	*playerName = [playerInputField stringValue];
    
    [playerField setStringValue:playerName];

    if ([showHintsSwitch state] == NSOnState) {
        //NSLog(@"Hints Are ON");
        showHints = TRUE;
        [self showScoreDuringPlay];
    } else {
        //NSLog(@"Hints Are OFF");
        showHints = FALSE;
        for (row=0; row < [topMatrix numberOfRows]; row++) {
            if (! [[topMatrix cellAtRow:row column:0] locked]) {
                [[topMatrix cellAtRow:row column:0] setTitle:nil];
            }//if
        }//for
        for (row=0; row < [bottomMatrix numberOfRows]; row++) {
            if (! [[bottomMatrix cellAtRow:row column:0] locked]) {
            [[bottomMatrix cellAtRow:row column:0] setTitle:nil];
            }//if
        }//for
    }
    if ([zeroWarningSwitch state] == NSOnState) {
        //NSLog(@"Warnings Are ON!");
        showWarnings = TRUE;
    } else {
        //NSLog(@"Warnings Are OFF!");
        showWarnings = FALSE;
    }
    if ([clickLocksSwitch state] == NSOnState) {
        //NSLog(@"Click Locks Dice is ON!");
        clickLocksDice = TRUE;
    } else {
       // NSLog(@"Click Locks Dice is OFF!");
        clickLocksDice = FALSE;
    }
    [preferences setObject:playerName forKey:kNameKey];
    [preferences setBool:showHints forKey:kHintsKey];
    [preferences setBool:showWarnings forKey:kWarningsKey];
    [preferences setBool:clickLocksDice forKey:kDiceLockKey];
    
    [prefsSheet orderOut:nil];
    [NSApp endSheet:prefsSheet];

}

/* *******************************



********************************* */
- (void) showScoreDuringPlay {
    int		row, i, total;
    
   
    
    for (row=0; row < [topMatrix numberOfRows]; row++) {
         if ( (! [[topMatrix cellAtRow:row column:0] locked]) && (isRollValid) ) {
            total = 0;
            for (i=0; i < 5; i++) {
                if ([[diceMatrix cellAtRow:i column:0] dieValue] == row + 1) {
                    total = total + [[diceMatrix cellAtRow:i column:0] dieValue];
                }
            }
            //NSLog(@"*** Upper Field Unlocked: %d", row);
            [[topMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >", total]];
        }
    }
    
     for (row=0; row < [bottomMatrix numberOfRows]; row++) {
         if ( (![[bottomMatrix cellAtRow:row column:0] locked]) && (isRollValid) ) {
            switch (row) {
                case 0:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame checkForThreeOfAKind:diceMatrix]]];
                    break;
                case 1:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame checkForFourOfAKind:diceMatrix]]];
                    break;
                case 2:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame checkForFullHouse:diceMatrix]]];
                    break;
                case 3:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame checkForSmallStraight:diceMatrix]]];
                    break;
                case 4:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame checkForLargeStraight:diceMatrix]]];
                    break;
                case 5:
                    if ([currentGame checkForYahtzee:diceMatrix]) {
                        [[bottomMatrix cellAtRow:row column:0] setTitle:@"< 50 >"];
                    } else
                        [[bottomMatrix cellAtRow:row column:0] setTitle:@"< 0 >"];
                    break;
                case 6:
                    break;
                case 7:
                    [[bottomMatrix cellAtRow:row column:0] setTitle:[NSString stringWithFormat:@"< %d >",[currentGame diceTotal:diceMatrix]]];
                    break;
            }//switch
        }
    }//for
}

/* *******************************



********************************* */
- (void) setScoreTotals {
        int	i, j;
        int	upperTotal, columnTotal;
        int	grandTotal = 0;
        
        
        for (j=0; j < [topMatrix numberOfColumns]; j++) {
            upperTotal = 0;
            columnTotal = 0;
            [currentGame setIsUpperFull:YES];
            for (i=0; i < 6; i++) {
                if (![[topMatrix cellAtRow:i column:j] locked]) {
                    [currentGame setIsUpperFull:NO];
                }
            }
            for (i=0; i < 6; i++) {
                upperTotal += [[[topMatrix cellAtRow:i column:j] title] intValue];
            }
            if ([currentGame isUpperFull]) {
                if (upperTotal >= 63) {
                    [[topTotalMatrix cellAtRow:1 column:j] setTitle:[NSString stringWithFormat:@"%d", kUpperBonus]];
                    columnTotal = 35;
                } else 
                    [[topTotalMatrix cellAtRow:1 column:j] setTitle:@"0"];
            }
            
            [[topTotalMatrix cellAtRow:0 column:j] setTitle:[NSString stringWithFormat:@"%d", upperTotal]];
            
            columnTotal += upperTotal;
            for (i=0; i < [bottomMatrix numberOfRows]; i++) {
                columnTotal += [[[bottomMatrix cellAtRow:i column:j] title] intValue];
            }
            
            grandTotal += columnTotal * (j+1);
        }
        [totalScoreField setIntValue: grandTotal];
}

/* *******************************



********************************* */
- (BOOL) windowShouldClose: (NSWindow *)sender {

    NSBeginAlertSheet(@"End Game", 		// Sheet Title
        @"Cancel", 							// Default Button Label
        @"OK",						// Alternate Button Label
        nil, 							// Other Button Label
        sender, 						// Document Window
        self, 							// Modal Delegate
        @selector(didEndShouldCloseSheet:returnCode:contextInfo:), 	// didEndSelector
        NULL, 							// didDismiss Selector
        sender,							// context Info
        @"Do you want to exit this game?", 	// Message
        nil);							// ... (var args)

    return NO;
}

- (void)didEndShouldCloseSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode != NSAlertDefaultReturn)
        [(NSWindow *)contextInfo  close];

}
/* *******************************



********************************* */
- (void) processHighScores
{
    BOOL	sorted = FALSE;
    int		i;
    HighScores	*thisScore = [[HighScores alloc] init];
    
    //NSLog(@"*** -(void)processHighScores ***" );

    [thisScore setPlayerName:[playerField stringValue]];
    [thisScore setGameDate:[NSCalendarDate date]];
    [thisScore setScore:[totalScoreField intValue]];

    for (i=0; i < [highScoresArray count]; i++) {
        if ([thisScore score] > [[highScoresArray objectAtIndex:i] score]) {
            [highScoresArray insertObject:thisScore atIndex:i];
            //NSLog(@"*** Doing Insert at Index: %d", i);
            sorted = TRUE;
            break;
        }
    }
    if (!sorted) {
        [highScoresArray addObject:thisScore];
        i++;
    }
    //NSLog(@"*** Current array count: %d", [highScoresArray count]);
    if ([highScoresArray count] > 10) {
        [highScoresArray removeLastObject];
    }
    
    [NSArchiver archiveRootObject:highScoresArray toFile: kHighScoresFile ];
    [thisScore release];
    
    if (i < 10) {
        //NSLog(@"*** Current Index: %d", i );
        newHighScoreIndex = i;
        [self openHighScoresSheet:nil];
    }
    
}

- (IBAction)openHighScoresSheet:(id)sender
{    
    int		i=0;

    [NSApp beginSheet:highScoresSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];

    //NSLog(@"*** Current array count: %d", [highScoresArray count]);
    for (i=0; i < [highScoresArray count]; i++) {
        //NSLog(@"*** Current Index: %d", i );
        if (i == newHighScoreIndex) {
            [[highScoresMatrix cellAtRow:i column:0] setTextColor:[NSColor redColor]];
            [[highScoresMatrix cellAtRow:i column:1] setTextColor:[NSColor redColor]];
            [[highScoresMatrix cellAtRow:i column:2] setTextColor:[NSColor redColor]];
        }
            
        [[highScoresMatrix cellAtRow:i column:0] setStringValue:[[highScoresArray objectAtIndex:i] playerName]];
        [[highScoresMatrix cellAtRow:i column:1] setStringValue:[[[highScoresArray objectAtIndex:i] gameDate] descriptionWithCalendarFormat:kDateFormat]];
        [[highScoresMatrix cellAtRow:i column:2] setIntValue:[[highScoresArray objectAtIndex:i] score]];

    }
    while (i <  10) {    
        [[highScoresMatrix cellAtRow:i column:0] setStringValue:@"Empty"];
        i++;
    }

}
/* *******************************



********************************* */
- (IBAction)closeHighScoresSheet:(id)sender
{
     
    [highScoresSheet orderOut:nil];
    [[highScoresMatrix cellAtRow:newHighScoreIndex column:0] setTextColor:[NSColor blackColor]];
    [[highScoresMatrix cellAtRow:newHighScoreIndex column:1] setTextColor:[NSColor blackColor]];
    [[highScoresMatrix cellAtRow:newHighScoreIndex column:2] setTextColor:[NSColor blackColor]];
    newHighScoreIndex = -1;
    [NSApp endSheet:highScoresSheet];
}

- (void)setHighScores:(NSMutableArray *)newScores {
    //[newScores retain];
    //[highScoresArray autorelease];
    highScoresArray = newScores;
}

- (NSMutableArray *)highScoresArray {
    return highScoresArray;
}

- (IBAction)clearHighScores:(id)sender {
        
        int	i, j;
        
        [highScoresArray removeAllObjects];
        [NSArchiver archiveRootObject:highScoresArray toFile: kHighScoresFile ];
        
        for (i=0; i <  10; i++) {    
            [[highScoresMatrix cellAtRow:i column:0] setStringValue:@"Empty"];
        }
        for (j=1; j <  3; j++) { 
            for (i=0; i <  10; i++) {    
                [[highScoresMatrix cellAtRow:i column:j] setStringValue:kEmptyString];
            }
        }

}

- (IBAction)undo:(id)sender {
        
     [[bottomMatrix cellAtRow:6 column:0] setTitle:@"Undo"];

}
@end
