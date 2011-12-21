//
//  Card.m
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Card.h"

@interface Card()
- (void)playSound;
@end

@implementation Card

@synthesize type;

- (id)initWithType:(CardType)theType andFrame:(CGRect)frame
{
    if(self = [self init]) {
        self.type   = theType;
        self.frame  = frame;
        
        CATransformLayer *layer = [CATransformLayer new];
        CALayer *backLayer = [CALayer new];
        [backLayer setBackgroundColor:[UIColor lightGrayColor].CGColor];
        CALayer *frontLayer = [CALayer new];
        [frontLayer setBackgroundColor:[UIColor blueColor].CGColor];
         
        frontLayer.zPosition = 0;
        backLayer.zPosition = 1;
        frontLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    self.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [CATransaction commit];
    [self playSound];
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
