//
//  ScoreOverlayViewController.h
//  concentration
//
//  Created by Brent Sanders on 12/23/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"

@protocol ScoreOverlayDelegate <NSObject>
- (void)continueToNextLevel;
@end

@interface ScoreOverlayViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UILabel *score;
@property (nonatomic, retain) IBOutlet UILabel *attempts;
@property (nonatomic, assign) id <ScoreOverlayDelegate> delegate;
@property (nonatomic, assign) Score *currentScore;
- (IBAction)continueToNextLevel;
- (void)updateScore:(NSDictionary *)dict;
- (id)initWithScore:(Score *)theScore;
@end
