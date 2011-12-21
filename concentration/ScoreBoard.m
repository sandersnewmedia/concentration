//
//  ScoreBoard.m
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ScoreBoard.h"

@implementation ScoreBoard

@synthesize currentTime=_currentTime,currentLevel=_currentLevel,currentScore=_currentScore,restartButton=_restartButton;

- (void)restartButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You will loose all of your game progress" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (UILabel *)currentTime
{
    if(!_currentTime) {
        _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        _currentTime.textAlignment = UITextAlignmentCenter;
        _currentTime.text = @"0:00";
    }
    return _currentTime;
}

- (UILabel *)currentLevel
{
    if(!_currentLevel) {
        _currentLevel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 30)];
        _currentLevel.textAlignment = UITextAlignmentCenter;
        _currentLevel.text = @"Level 1";
    }
    return _currentLevel;
}

- (UILabel *)currentScore
{
    if(!_currentScore) {
        _currentScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, 30)];
        _currentScore.textAlignment = UITextAlignmentCenter;
        _currentScore.text = @"0";
    }
    return _currentScore;
}

- (UIButton *)restartButton
{
    if(!_restartButton) {
        _restartButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _restartButton.frame = CGRectMake(0, 120, 100, 30);
        [_restartButton addTarget:self action:@selector(restartButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _restartButton.titleLabel.text = @"Restart";
    }
    return _restartButton;
}

- (void)dealloc 
{
    [_restartButton release];
    [_currentLevel release];
    [_currentTime release];
    [super dealloc];
}

- (void)updateScore:(NSNotification *)notif
{
    int matches = [[[notif userInfo] objectForKey:@"matches"] intValue];
    int attempts = [[[notif userInfo] objectForKey:@"attempts"] intValue];
    self.currentScore.text = [NSString stringWithFormat:@"%d/%d", matches, attempts];
}

- (void)awakeFromNib
{
    [self addSubview:self.currentTime];
    [self addSubview:self.currentScore];
    [self addSubview:self.currentLevel];
    [self addSubview:self.restartButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"updateScore" object:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"restart" object:nil];
    }
}

@end
