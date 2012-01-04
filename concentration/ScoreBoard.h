//
//  ScoreBoard.h
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoard : UIView <UIAlertViewDelegate>


@property (nonatomic, retain) UILabel *currentLevel;
@property (nonatomic, retain) UILabel *currentTime;
@property (nonatomic, retain) UILabel *currentScore;
@property (nonatomic, retain) UIButton *restartButton;
@property (nonatomic, retain) UIButton *helpButton;
@property (nonatomic, assign) NSDate *levelStartTime;
@property (nonatomic, retain) NSDate *pauseStartTime;
@property (nonatomic, retain) NSTimer *clock;

@end
