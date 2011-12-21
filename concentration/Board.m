//
//  Board.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Board.h"
#import "Card.h"
#import <QuartzCore/QuartzCore.h>

#define NUM_ROWS    4
#define NUM_COLS    4
#define CARD_WIDTH  100
#define CARD_HEIGHT 100
#define PADDING     8

@interface Board() 
@property (nonatomic, assign) NSArray *cards;
- (void)drawBoard;
- (void)clearBoard;
@end

@implementation Board

@synthesize cards, cardLayers=_cardLayers;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCards:(NSArray *)theCards
{
    if(self = [self initWithFrame:CGRectMake(300, 20, 700, 500)]) {
        self.cards = theCards;
        [self drawBoard];
    }
    return self;
}

- (NSMutableArray *)cardLayers 
{
    if(!_cardLayers) {
        _cardLayers = [[NSMutableArray alloc] init];
    }
    return _cardLayers;
}

- (void)dealloc
{
    [_cardLayers release];
    [super dealloc];
}

- (void)drawBoard
{
    [self clearBoard];
    int colCount = 0;
    int rowCount = 0;
    for(NSNumber *cardTypeNumber in self.cards) {
        CardType type = [cardTypeNumber intValue];
        float xLocation = colCount * (CARD_WIDTH + PADDING);
        float yLocation = rowCount * (CARD_HEIGHT + PADDING);
        CGRect cardFrame = CGRectMake(xLocation, yLocation, CARD_WIDTH, CARD_HEIGHT);
        
        if(colCount > NUM_COLS) {
            colCount = 0;
            rowCount ++;
        } else {
            colCount ++;
        }
        
        Card *card = [[Card alloc] initWithType:type andFrame:cardFrame];
        [self.layer addSublayer:card];
        [self.cardLayers addObject:card];
        [card release];
    }
}

- (void)clearBoard
{
    //remove them all from the view
    for(CALayer *layer in self.cardLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    self.cardLayers = nil;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] == 1) {
        CGPoint point = [[touches anyObject] locationInView:self];
        for(Card *card in self.cardLayers) {
            if([card containsPoint:[self.layer convertPoint:point toLayer:card]]) {
                [card flip];
            }
        }
    }
}


@end
