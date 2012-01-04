//
//  SNMViewController.h
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "ScoreBoard.h"
#import "Card.h"
#import "ScoreOverlayViewController.h"
#import "Score.h"
#import "WelcomeOverlayViewController.h"
#import "HelpOverlayViewController.h"

@interface ConcentrationViewController : UIViewController <BoardDelegate, ScoreOverlayDelegate> {
    
}

@property (nonatomic, retain) IBOutlet Board *board;
@property (nonatomic, retain) IBOutlet ScoreBoard *scoreBoard;
@property (nonatomic, retain) SoundUtil *soundUtil;
@property (nonatomic) int currentLevel;
@property (nonatomic, retain) Score *currentScore;
@property (nonatomic, retain) NSDate *levelStartTime;
@property (nonatomic, retain) NSDate *pauseStartTime;
@property (nonatomic, retain) ScoreOverlayViewController *scoreOverlay;
@property (nonatomic, retain) WelcomeOverlayViewController *welcomeOverlay;
@property (nonatomic, retain) HelpOverlayViewController *helpOverlay;

@end
