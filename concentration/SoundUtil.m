//
//  SoundUtil.m
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "SoundUtil.h"

@implementation SoundUtil

- (void)playSound:(SoundType)type
{
    NSString *path;
    
    switch (type) {
        case Match:
            path  = [[NSBundle mainBundle] pathForResource:@"match" ofType:@"wav"];
            break;
        case Flip:
            path  = [[NSBundle mainBundle] pathForResource:@"page-flip-2" ofType:@"wav"];
            break;
        case LevelComplete:
            path  = [[NSBundle mainBundle] pathForResource:@"page-flip-2" ofType:@"wav"];
            break;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

- (void)dealloc
{
    
    AudioServicesDisposeSystemSoundID(sound);
    [super dealloc];
}

@end
