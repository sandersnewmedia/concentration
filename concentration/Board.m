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
    for(UIColor *color in self.cards) {
        CATransformLayer *layer = [CATransformLayer new];
        CALayer *backLayer = [CALayer new];
        [backLayer setBackgroundColor:[UIColor lightGrayColor].CGColor];
        CALayer *frontLayer = [CALayer new];
        [frontLayer setBackgroundColor:color.CGColor];
        frontLayer.zPosition = 0;
        backLayer.zPosition = 1;
        frontLayer.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT);
        backLayer.frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT);
        [layer addSublayer:backLayer];
        [layer addSublayer:frontLayer];
        
        
        float xLocation = colCount * (CARD_WIDTH + PADDING);
        float yLocation = rowCount * (CARD_HEIGHT + PADDING);
        layer.frame = CGRectMake(xLocation, yLocation, CARD_WIDTH, CARD_HEIGHT);
        
        if(colCount > NUM_COLS) {
            colCount = 0;
            rowCount ++;
        } else {
            colCount ++;
        }
        
        [self.layer addSublayer:layer];
        [frontLayer release];
        [backLayer release];
        [layer release];
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
        for(UITouch *touch in touches) {
            CGPoint point = [touch locationInView:self];
            point = [self.layer convertPoint:point toLayer:self.layer.superlayer];
            CATransformLayer *layer = (CATransformLayer *)[self.layer hitTest:point];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:1.0];
            [layer superlayer].transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [CATransaction commit];
        }
    }
}


@end
