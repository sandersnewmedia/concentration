//
//  SNMViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ConcentrationViewController.h"

@interface ConcentrationViewController()
- (void)nextLevel;
- (void)levelComplete;
- (void)showWelcome;
- (NSDictionary *)scoreDict;
- (void)calculateScore;
@end

@implementation ConcentrationViewController

@synthesize board,scoreBoard,soundUtil=_soundUtil, currentLevel, currentScore=_currentScore, levelStartTime=_levelStartTime;

@synthesize scoreOverlay=_scoreOverlay, welcomeOverlay=_welcomeOverlay, helpOverlay=_helpOverlay;

- (HelpOverlayViewController *)helpOverlay
{
    if(!_helpOverlay) {
        _helpOverlay = [[HelpOverlayViewController alloc] initWithNibName:@"HelpOverlayViewController" bundle:nil];
    }
    return _helpOverlay;
}

- (WelcomeOverlayViewController *)welcomeOverlay
{
    if(!_welcomeOverlay) {
        _welcomeOverlay = [[WelcomeOverlayViewController alloc] initWithNibName:@"WelcomeOverlayViewController" bundle:nil];
    }
    return _welcomeOverlay;
}

- (ScoreOverlayViewController *)scoreOverlay
{
    if(!_scoreOverlay) {
        _scoreOverlay = [[ScoreOverlayViewController alloc] initWithScore:self.currentScore];
        _scoreOverlay.delegate = self;
    }
    return _scoreOverlay;
}

- (SoundUtil *)soundUtil
{
    if(!_soundUtil) {
        _soundUtil = [[SoundUtil alloc] init];
    }
    return _soundUtil;
}

- (NSDate *)levelStartTime
{
    if(!_levelStartTime) {
        _levelStartTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    }
    return _levelStartTime;
}

- (Score *)currentScore
{
    if(!_currentScore) {
        _currentScore = [[Score alloc] init];
    }
    return _currentScore;
}

- (NSDictionary *)scoreDict
{
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:self.board.matches],  @"matches",
                           [NSNumber numberWithInt:self.board.attempts], @"attempts",
                           [NSNumber numberWithInt:self.currentLevel], @"level",
                           self.currentScore, @"score",
                           self.levelStartTime, @"startTime",
                           nil] autorelease];
    return dict;
}

- (void)dealloc
{
    self.scoreOverlay.delegate = nil;
    [_scoreOverlay release];
    [_welcomeOverlay release];
    [_levelStartTime release];
    [_currentScore release];
    [_soundUtil release];
    [_helpOverlay release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.board.delegate = self;
    self.currentLevel = 0;
    self.currentScore = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHelpOverlay) name:@"continueWithGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHelpOverlay) name:@"showHelpOverlay" object:nil];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"]) {
        [self showWelcome];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
    } else {
        [self nextLevel];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"restart" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"continueWithGame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showHelpOverlay" object:nil];
    self.board.delegate = nil;
    self.board = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.board.enabled)
        [self.board touchesBegan:touches withEvent:event];
}

#pragma mark - Game Events

- (void)showWelcome
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideWelcome) name:@"welcomeOverlayClosed" object:nil];
    [self.view addSubview:self.welcomeOverlay.view];
}

- (void)hideWelcome
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"welcomeOverlayClosed" object:nil];
    [self.welcomeOverlay.view removeFromSuperview];
    [self nextLevel];
}

- (void)showHelpOverlay
{
    [self.view addSubview:self.helpOverlay.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseTime" object:nil];
    self.board.enabled = NO;
}

- (void)hideHelpOverlay
{
    [self.helpOverlay.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeTime" object:nil];
    self.board.enabled = YES;
}

- (void)gameStart
{
    self.board.enabled = YES;
    self.levelStartTime = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startTime" object:nil userInfo:[self scoreDict]];
    [self.board hidePeek];
}

- (void)levelComplete
{
    //update the value of the current score
    [self calculateScore];
    self.board.enabled = NO;
    [self.soundUtil playSound:LevelComplete];
    [self.view addSubview:self.scoreOverlay.view];
    [self.scoreOverlay updateScore:[self scoreDict]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseTime" object:nil];
}

- (void)nextLevel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearTime" object:nil];
    self.currentLevel++;
    [self.board drawBoard];
    int delay = 5/self.currentLevel;
    [self.board showPeek];
    [self performSelector:@selector(gameStart) withObject:nil afterDelay:delay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScore" object:nil userInfo:[self scoreDict]];
}

- (void)restart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseTime" object:nil];
    self.currentLevel = 0;
    self.currentScore = nil;
    [self nextLevel];
}



- (void)calculateScore
{
    float level_score = 100000 / (float)( self.board.attempts / self.board.matches );
    self.currentScore.score = self.currentScore.score + level_score;
}

- (void)updateScore
{
    if(self.board.matches == ([self.board.cardLayers count]/2)) {
        [self levelComplete];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScore" object:nil userInfo:[self scoreDict]];
    }
}

- (void)selectCard:(Card *)card
{
    if(self.board.currentCard) {
        if(card.identifier != self.board.currentCard.identifier) {
            [card flip];
            if(card.type == self.board.currentCard.type) {          //MATCH
                [card matched];
                [self.board.currentCard matched];
                self.board.matches++;
                [self.soundUtil playSound:Match];
            } else {                                                //NO MATCH
                [card notMatched];
                [self.board.currentCard notMatched];
            }
            self.board.currentCard = nil;
            self.board.attempts ++;
            [self updateScore];
        } 
    } else {
        [card flip];
        self.board.currentCard = card;
    }
}

#pragma mark - Score Overlay Delegate Methods
- (void)continueToNextLevel
{
    [self.scoreOverlay.view removeFromSuperview];
    [self nextLevel];
}

@end
