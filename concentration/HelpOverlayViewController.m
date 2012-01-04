//
//  HelpOverlayViewController.m
//  concentration
//
//  Created by Brent Sanders on 1/4/12.
//  Copyright (c) 2012 Sanders New Media. All rights reserved.
//

#import "HelpOverlayViewController.h"

@implementation HelpOverlayViewController

- (IBAction)continueWithGame:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"continueWithGame" object:nil];
}

@end
