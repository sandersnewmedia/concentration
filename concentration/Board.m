//
//  Board.m
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import "Board.h"
#import <QuartzCore/QuartzCore.h>

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
- (void)updateScore;
@end

@implementation Board

@synthesize cards, cardLayers=_cardLayers, currentCard, soundUtil=_soundUtil;

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
    if(self = [self initWithFrame:CGRectMake(200,50,824,718)]) {
        self.cards = theCards;
        matches = 0;
        attempts = 0;
        [self drawBoard];
        [self showPeek];
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

- (SoundUtil *)soundUtil
{
    if(!_soundUtil) {
        _soundUtil = [[SoundUtil alloc] init];
    }
    return _soundUtil;
}

- (void)dealloc
{
    [_soundUtil release];
    [_cardLayers release];
    [super dealloc];
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

- (void)updateScore
{
    [self.soundUtil playSound:Match];
    //this will send out a notification saying the score has been updated and what its been updated to...
}

- (void)selectCard:(Card *)card
{
    if(self.currentCard) {
        if(card.identifier != self.currentCard.identifier) {
            [card flip];
            if(card.type == self.currentCard.type) {        //MATCH
                [card matched];
                [self.currentCard matched];
                matches++;
                [self updateScore];
            } else {                                        //NO MATCH
                [card notMatched];
                [self.currentCard notMatched];
            }
            self.currentCard = nil;
            attempts ++;
        } 
    } else {
        [card flip];
        self.currentCard = card;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] == 1) {
        CGPoint point = [[touches anyObject] locationInView:self];
        for(Card *card in self.cardLayers) {
            if([card containsPoint:[self.layer convertPoint:point toLayer:card]]) {
                [self selectCard:card];
            }
        }
    }
}


@end
