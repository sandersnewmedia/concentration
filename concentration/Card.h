//
//  Card.h
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SoundUtil.h"

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

typedef enum {
    Normal,
    Flipped,
    Matched
} CardStatus;

@interface Card : CATransformLayer {
    BOOL enabled;
}

@property (nonatomic) CardType type;
@property (nonatomic) CardStatus status;
@property (nonatomic) int identifier;
@property (nonatomic, retain) SoundUtil *soundUtil;

- (id)initWithType:(CardType)theType andFrame:(CGRect)frame andIdentifier:(int)ident;
- (void)flip;
- (void)matched;
- (void)notMatched;
- (void)flipOver;
- (void)flipBack;
@end
