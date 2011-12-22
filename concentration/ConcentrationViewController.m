//
//  SNMViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ConcentrationViewController.h"

@implementation ConcentrationViewController

@synthesize board,scoreBoard,soundUtil=_soundUtil;

- (SoundUtil *)soundUtil
{
    if(!_soundUtil) {
        _soundUtil = [[SoundUtil alloc] init];
    }
    return _soundUtil;
}

- (id)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
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
