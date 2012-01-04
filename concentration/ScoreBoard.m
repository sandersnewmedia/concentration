//
//  ScoreBoard.m
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ScoreBoard.h"

@interface ScoreBoard()
- (void)tick;
@end

@implementation ScoreBoard

@synthesize currentTime=_currentTime,currentLevel=_currentLevel,currentScore=_currentScore,restartButton=_restartButton;
@synthesize clock=_clock, levelStartTime;

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
        _currentTime.backgroundColor = [UIColor clearColor];
        _currentTime.textColor = [UIColor whiteColor];
        _currentTime.text = @"0:00";
    }
    return _currentTime;
}

- (UILabel *)currentLevel
{
    if(!_currentLevel) {
        _currentLevel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 30)];
        _currentLevel.textAlignment = UITextAlignmentCenter;
        _currentLevel.backgroundColor = [UIColor clearColor];
        _currentLevel.textColor = [UIColor whiteColor];
        _currentLevel.text = @"Level 1";
    }
    return _currentLevel;
}

- (UILabel *)currentScore
{
    if(!_currentScore) {
        _currentScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, 40)];
        _currentScore.textAlignment = UITextAlignmentCenter;
        _currentScore.backgroundColor = [UIColor clearColor];
        _currentScore.textColor = [UIColor whiteColor];
        _currentScore.text = @"0";
    }
    return _currentScore;
}

- (UIButton *)restartButton
{
    if(!_restartButton) {
        _restartButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _restartButton.frame = CGRectMake(0, 120, 180, 30);
        [_restartButton addTarget:self action:@selector(restartButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _restartButton.titleLabel.text = @"RESTART";
    }
    return _restartButton;
}

- (NSTimer *)clock
{
    if(!_clock) {
        _clock = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES] retain];
    }
    return _clock;
}

- (void)dealloc 
{
    [_clock release];
    [_restartButton release];
    [_currentLevel release];
    [_currentTime release];
    [super dealloc];
}

- (NSString *)getTimeRemainingString {
    int deltaTime = [[NSDate date] timeIntervalSinceDate:self.levelStartTime];
    NSLog(@"DELTATIME = %i", deltaTime);
    return [NSString stringWithFormat:@"%02d:%02d", deltaTime / 60 , deltaTime % 60];
}

- (void)tick
{
    self.currentTime.text = [self getTimeRemainingString];
}

- (void)updateScore:(NSNotification *)notif
{
    int matches = [[[notif userInfo] objectForKey:@"matches"] intValue];
    int attempts = [[[notif userInfo] objectForKey:@"attempts"] intValue];
    int level = [[[notif userInfo] objectForKey:@"level"] intValue];
    self.currentScore.text = [NSString stringWithFormat:@"%d/%d", matches, attempts];
    self.currentLevel.text = [NSString stringWithFormat:@"Level %d", level];
}

- (void)startTimer:(NSNotification *)notif 
{
    self.levelStartTime = [notif.userInfo objectForKey:@"startTime"];
    self.currentTime.text = @"00:00";
    [self.clock fire];
}

- (void)clearTimer:(NSNotification *)notif
{
    self.currentTime.text = @"00:00";
    self.clock = nil;
}

- (void)stopTimer
{
    [self.clock invalidate];
}

- (void)awakeFromNib
{
    [self addSubview:self.currentTime];
    [self addSubview:self.currentScore];
    [self addSubview:self.currentLevel];
    [self addSubview:self.restartButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScore:) name:@"updateScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer:) name:@"startTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearTimer:) name:@"clearTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"pauseTime" object:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"restart" object:nil];
    }
}

@end
