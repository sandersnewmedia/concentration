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

@interface ConcentrationViewController : UIViewController <BoardDelegate, UIAlertViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet Board *board;
@property (nonatomic, retain) IBOutlet ScoreBoard *scoreBoard;
@property (nonatomic, retain) SoundUtil *soundUtil;
@property (nonatomic) int currentLevel;
@property (nonatomic) int currentScore;
@property (nonatomic, retain) NSDate *levelStartTime;

@end
