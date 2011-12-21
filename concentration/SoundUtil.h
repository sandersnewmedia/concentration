//
//  SoundUtil.h
//  concentration
//
//  Created by Brent Sanders on 12/21/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum { Match, Flip, LevelComplete } SoundType;

@interface SoundUtil : NSObject {
    SystemSoundID sound;
}

- (void) playSound:(SoundType)type;

@end
