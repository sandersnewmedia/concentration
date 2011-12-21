//
//  Card.m
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Card.h"

#define ANIMATION_SPEED .5

@interface Card()
- (void)playSound;
- (void)flipOver;
- (void)flipBack;
@end

@implementation Card

@synthesize identifier, type, status;

- (id)initWithType:(CardType)theType andFrame:(CGRect)frame andIdentifier:(int)ident
{
    if(self = [self init]) {
        self.type   = theType;
        self.frame  = frame;
        self.status = Normal;
        self.identifier = ident;
        enabled = YES;
        
        CATransformLayer *layer = [CATransformLayer new];
        CALayer *backLayer = [CALayer new];
        CALayer *frontLayer = [CALayer new];
        
        UIColor *cardColor;     //temporary way to identify cards
        
        switch (self.type) {
            case Robot:
                cardColor = [UIColor redColor];
                break;
            case Rocket:
                cardColor = [UIColor blueColor];
                break;
            case Grandpa:
                cardColor = [UIColor greenColor];
                break;
            case Mom:
                cardColor = [UIColor grayColor];
                break;
            case Dad:
                cardColor = [UIColor yellowColor];
                break;
            case Brent:
                cardColor = [UIColor orangeColor];
                break;
            case Scott:
                cardColor = [UIColor purpleColor];
                break;
            case Elijah:
                cardColor = [UIColor brownColor];
                break;
            default:
                cardColor = [UIColor blackColor];
                break;
        }
        
        [backLayer setBackgroundColor:[UIColor whiteColor].CGColor];
        [frontLayer setBackgroundColor:cardColor.CGColor];
        frontLayer.zPosition = 0;
        backLayer.zPosition = 1;
        frontLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        frontLayer.cornerRadius = 3;
        backLayer.cornerRadius = 3;
        [layer addSublayer:backLayer];
        [layer addSublayer:frontLayer];
        
        [self addSublayer:layer];
        [frontLayer release];
        [backLayer release];
        [layer release];
    }
    return self;
}

- (void)flip
{
    if(enabled) {
        if(self.status == Normal) {
            [self flipOver];
            [self playSound];
        } else {
            [self flipBack];
        }
    }
}

- (void)flipOver
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:ANIMATION_SPEED];
    self.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [CATransaction commit];
    self.status = Flipped;
}

- (void)flipBack
{
    if(self.status != Matched) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:ANIMATION_SPEED];
        self.transform = CATransform3DMakeRotation(-M_PI, 0, 0, 0);
        [CATransaction commit];
        self.status = Normal;
    }
}

- (void)matched
{
    [self flipOver];
    self.status = Matched;
    enabled = NO;
}

- (void)notMatched
{
    [self performSelector:@selector(flipBack) withObject:nil afterDelay:ANIMATION_SPEED];
}

- (void)playSound
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"page-flip-2" ofType:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &turnEffect);
        AudioServicesPlaySystemSound(turnEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(turnEffect);
    [super dealloc];
}

@end
