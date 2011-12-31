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
- (NSDictionary *)scoreDict;
@end

@implementation ConcentrationViewController

@synthesize board,scoreBoard,soundUtil=_soundUtil, currentLevel, currentScore=_currentScore, levelStartTime=_levelStartTime;

@synthesize scoreOverlay=_scoreOverlay;

-(ScoreOverlayViewController *)scoreOverlay
{
    if(!_scoreOverlay) {
        _scoreOverlay = [[ScoreOverlayViewController alloc] initWithNibName:@"ScoreOverlayViewController" bundle:nil];
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


- (void)dealloc
{
    self.scoreOverlay.delegate = nil;
    [_scoreOverlay release];
    [_levelStartTime release];
    [_currentScore release];
    [_soundUtil release];
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
    [self nextLevel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restart" object:nil];
}

- (void)viewDidUnload
{
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
    [self.board touchesBegan:touches withEvent:event];
}


#pragma mark - Game Logic
- (void)gameStart
{
    self.board.enabled = YES;
    self.levelStartTime = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startTime" object:nil userInfo:[self scoreDict]];
    [self.board hidePeek];
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
    self.currentScore = 0;
    [self nextLevel];
}

- (NSDictionary *)scoreDict
{
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:self.board.matches],  @"matches",
                           [NSNumber numberWithInt:self.board.attempts], @"attempts",
                           [NSNumber numberWithInt:self.currentLevel], @"level", 
                           self.levelStartTime, @"startTime",
                           nil] autorelease];
    return dict;
}

- (void)levelComplete
{
    self.board.enabled = NO;
    [self.soundUtil playSound:LevelComplete];
    [self.view addSubview:self.scoreOverlay.view];
    [self.scoreOverlay updateScore:[self scoreDict]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseTime" object:nil];
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
            if(card.type == self.board.currentCard.type) {        //MATCH
                [card matched];
                [self.board.currentCard matched];
                self.board.matches++;
                [self.soundUtil playSound:Match];
            } else {                                        //NO MATCH
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
- (void)continue
{
    [self.scoreOverlay.view removeFromSuperview];
    [self nextLevel];
}

@end
