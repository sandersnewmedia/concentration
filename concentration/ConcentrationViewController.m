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
@end

@implementation ConcentrationViewController

@synthesize board,scoreBoard,soundUtil=_soundUtil, currentLevel, currentScore, levelStartTime=_levelStartTime;

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


- (void)dealloc
{
    [_levelStartTime release];
    [_soundUtil release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Game Logic

- (void)nextLevel
{
    self.currentLevel++;
    [self.board drawBoard];
    int delay = 5 - self.currentLevel;
    if(delay > 0) {
        [self.board showPeek];
        [self.board performSelector:@selector(hidePeek) withObject:nil afterDelay:delay];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.board.delegate = self;
    self.currentLevel = 1;
    self.currentScore = 0;
    [self nextLevel];
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

- (NSDictionary *)scoreDict
{
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:self.board.matches],  @"matches",
                           [NSNumber numberWithInt:self.board.attempts], @"attempts",nil] autorelease];
    return dict;
}

- (void)updateScore
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScore" object:nil userInfo:[self scoreDict]];
    if(self.board.matches == ([self.board.cardLayers count]/2)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Level Complete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self nextLevel];
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



@end
