//
//  Card.h
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum {
    Robot,
    Rocket,
    Grandpa,
    Mom,
    Dad,
    Brent,
    Scott,
    Elijah,
    PJ,
    Tim,
    Royden
} CardType;

@interface Card : CATransformLayer {
    
    SystemSoundID turnEffect;
    
}

@property (nonatomic, assign) int type;

- (id)initWithType:(CardType)theType andFrame:(CGRect)frame;
- (void)flip;

@end
