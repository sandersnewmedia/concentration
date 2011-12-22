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

@protocol BoardDelegate <NSObject>
- (void)selectCard:(Card *)card;
@end

@interface Board : UIView

@property (nonatomic, retain) NSMutableArray *cardLayers;
@property (nonatomic, assign) Card *currentCard;
@property (nonatomic, assign) id <BoardDelegate> delegate;
@property (nonatomic, retain) SoundUtil *soundUtil;
@property (nonatomic) int attempts;
@property (nonatomic) int matches;

@end
