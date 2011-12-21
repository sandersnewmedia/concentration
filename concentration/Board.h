//
//  Board.h
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Card.h"

@interface Board : UIView {
    int matches;
    int attempts;
}
- (id)initWithCards:(NSArray *)theCards;
@property (nonatomic, retain) NSMutableArray *cardLayers;
@property (nonatomic, assign) Card *currentCard;
@property (nonatomic, retain) SoundUtil *soundUtil;

@end
