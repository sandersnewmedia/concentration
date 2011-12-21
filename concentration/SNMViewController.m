//
//  SNMViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "SNMViewController.h"

#define NUM_CARDS 24

@implementation SNMViewController

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
        _cards = [[NSArray alloc] initWithObjects:[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor],[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor], nil];
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
