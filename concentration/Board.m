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
- (void)updateScore;
@end

@implementation Board

@synthesize cards=_cards, cardLayers=_cardLayers, currentCard, soundUtil=_soundUtil;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        attempts = 0;
        matches  = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restart" object:nil];
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

- (SoundUtil *)soundUtil
{
    if(!_soundUtil) {
        _soundUtil = [[SoundUtil alloc] init];
    }
    return _soundUtil;
}

- (void)dealloc
{
    [_cards release];
    [_soundUtil release];
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

- (NSDictionary *)scoreDict
{
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:matches],  @"matches",
                          [NSNumber numberWithInt:attempts], @"attempts",nil] autorelease];
    return dict;
}

- (void)updateScore
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScore" object:nil userInfo:[self scoreDict]];
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
                [self.soundUtil playSound:Match];
            } else {                                        //NO MATCH
                [card notMatched];
                [self.currentCard notMatched];
            }
            self.currentCard = nil;
            attempts ++;
            [self updateScore];
        } 
    } else {
        [card flip];
        self.currentCard = card;
    }
}

- (void)restart 
{
    matches = 0;
    attempts = 0;
    [self updateScore];
    [self drawBoard];
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
