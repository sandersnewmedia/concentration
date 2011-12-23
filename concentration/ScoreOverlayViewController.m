//
//  ScoreOverlayViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/23/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ScoreOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScoreOverlayViewController

@synthesize time, score, attempts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.cornerRadius    = 8;
    self.view.layer.shadowRadius    = 4;
    self.view.layer.shadowColor     = [UIColor whiteColor].CGColor;
    self.view.layer.shadowOpacity   = .4f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    
    return NO;
}
@end
