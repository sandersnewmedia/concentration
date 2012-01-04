//
//  ScoreOverlayViewController.m
//  concentration
//
//  Created by Brent Sanders on 12/23/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "ScoreOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScoreOverlayViewController()
- (NSString *)getTimeRemainingString:(NSDate *)startTime;
@end

@implementation ScoreOverlayViewController

@synthesize time, score, attempts, delegate, currentScore;

- (id)initWithScore:(Score *)theScore
{
    if(self = [self initWithNibName:@"ScoreOverlayViewController" bundle:nil]) {
        self.currentScore = theScore;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateScore:(NSDictionary *)dict
{
    self.time.text = [self getTimeRemainingString:(NSDate *)[dict objectForKey:@"startTime"]];
    self.attempts.text = [[dict objectForKey:@"attempts"] stringValue];
    self.currentScore = (Score *)[dict objectForKey:@"score"];
    self.score.text = [NSString stringWithFormat:@"%.0f", self.currentScore.score];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSString *)getTimeRemainingString:(NSDate *)startTime {
    int deltaTime = [[NSDate date] timeIntervalSinceDate:startTime];
    return [NSString stringWithFormat:@"%02d:%02d", deltaTime / 60 , deltaTime % 60];
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

- (IBAction)continue
{
    [self.delegate continueToNextLevel];
}
@end
