//
//  Board.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Board.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableArray+Shuffling.h"

#define NUM_ROWS    4
#define NUM_COLS    4
#define CARD_WIDTH  150
#define CARD_HEIGHT 150
#define PADDING     8

@interface Board() {
    SystemSoundID matchEffect;
}
@property (nonatomic, assign) NSArray *cards;
- (void)drawBoard;
- (void)clearBoard;
- (void)showPeek;
- (void)hidePeek;
@end

@implementation Board

@synthesize cards=_cards, cardLayers=_cardLayers, currentCard, soundUtil=_soundUtil, delegate,attempts,matches;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.attempts = 0;
        self.matches  = 0;
    }
    return self;
}

- (NSArray *)cards
{
    if(!_cards) {
        //create all cards with 2 types of each...
        NSMutableArray *allCards = [[NSMutableArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:Robot],
                                    [NSNumber numberWithInt:Rocket],
                                    [NSNumber numberWithInt:Grandpa],
                                    [NSNumber numberWithInt:Mom],
                                    [NSNumber numberWithInt:Dad],
                                    [NSNumber numberWithInt:Brent],
                                    [NSNumber numberWithInt:Scott],
                                    [NSNumber numberWithInt:Elijah],
                                    [NSNumber numberWithInt:Robot],
                                    [NSNumber numberWithInt:Rocket],
                                    [NSNumber numberWithInt:Grandpa],
                                    [NSNumber numberWithInt:Mom],
                                    [NSNumber numberWithInt:Dad],
                                    [NSNumber numberWithInt:Brent],
                                    [NSNumber numberWithInt:Scott],
                                    [NSNumber numberWithInt:Elijah],nil];
        //shuffle up all the cards
        [allCards shuffle];
        _cards = [allCards copy];
        [allCards release];
    }
    return _cards;
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
    [_cards release];
    [_cardLayers release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [self drawBoard];
    [self showPeek];
}

- (void)drawBoard
{
    [self clearBoard];
    int colCount = 0;
    int rowCount = 0;
    int i = 0;
    for(NSNumber *cardTypeNumber in self.cards) {
        CardType type = [cardTypeNumber intValue];
        float xLocation = colCount * (CARD_WIDTH + PADDING);
        float yLocation = rowCount * (CARD_HEIGHT + PADDING);
        CGRect cardFrame = CGRectMake(xLocation, yLocation, CARD_WIDTH, CARD_HEIGHT);
        
        if(colCount >= NUM_COLS-1) {
            colCount = 0;
            rowCount ++;
        } else {
            colCount ++;
        }
        
        Card *card = [[Card alloc] initWithType:type andFrame:cardFrame andIdentifier:i];
        [self.layer addSublayer:card];
        [self.cardLayers addObject:card];
        [card release];
        i++;
    }
}

- (void)showPeek
{
    for(Card *card in self.cardLayers) {
        [card flipOver];
    }
    [self performSelector:@selector(hidePeek) withObject:nil afterDelay:1];
}

- (void)hidePeek 
{
    for(Card *card in self.cardLayers) {
        [card flipBack];
    }
}

- (void)clearBoard
{
    //remove them all from the view
    for(Card *card in self.cardLayers) {
        [card removeAllAnimations];
        [card removeFromSuperlayer];
    }
    self.cardLayers = nil;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] == 1) {
        CGPoint point = [[touches anyObject] locationInView:self];
        for(Card *card in self.cardLayers) {
            if([card containsPoint:[self.layer convertPoint:point toLayer:card]]) {
                [self.delegate selectCard:card];
            }
        }
    }
}


@end
