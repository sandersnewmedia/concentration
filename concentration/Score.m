//
//  Score.m
//  concentration
//
//  Created by Brent Sanders on 12/23/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Score.h"

@implementation Score

@synthesize score,rounds,seconds;

- (id)init
{
    if(self = [super init]) {
        self.score      = 0;
        self.rounds     = 0;
        self.seconds    = 0;
    }
    return self;
}

@end
