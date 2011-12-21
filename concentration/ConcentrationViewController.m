//
//  SNMViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "NSMutableArray+Shuffling.h"

@implementation ConcentrationViewController

@synthesize board=_board, cards=_cards;

- (Board *)board 
{
    if(!_board) {
        //todo: add customizable board sizes
        _board = [[Board alloc] initWithCards:self.cards];
    }
    return _board;
}

- (NSArray *)cards
{
    if(!_cards) {
        //create all cards with 2 types of each...
        NSMutableArray *allCards = [[NSMutableArray alloc] initWithObjects:
                  [NSNumber numberWithInt:Robot],
                  [NSNumber numberWithInt:Rocket],
                  [NSNumber numberWithInt:Grandpa],
                  [NSNumber numberWithInt:Mom],
                  [NSNumber numberWithInt:Dad],
                  [NSNumber numberWithInt:Brent],
                  [NSNumber numberWithInt:Scott],
                  [NSNumber numberWithInt:Elijah],
                  [NSNumber numberWithInt:Robot],
                  [NSNumber numberWithInt:Rocket],
                  [NSNumber numberWithInt:Grandpa],
                  [NSNumber numberWithInt:Mom],
                  [NSNumber numberWithInt:Dad],
                  [NSNumber numberWithInt:Brent],
                  [NSNumber numberWithInt:Scott],
                  [NSNumber numberWithInt:Elijah],nil];
        //shuffle up all the cards
        [allCards shuffle];
        _cards = [allCards copy];
        [allCards release];
    }
    return _cards;
}

- (id)init
{
    if(self = [super init]) {
        //todo check for existing games
        turns   = 0;
        time    = 0;
        level   = 0;
    }
    return self;
}

- (void)dealloc
{
    [_cards release];
    [_board release];
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
    [self.view addSubview:self.board];
	
}

- (void)viewDidUnload
{
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

@end
