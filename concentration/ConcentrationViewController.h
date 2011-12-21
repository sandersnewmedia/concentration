//
//  SNMViewController.h
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "Card.h"

@interface ConcentrationViewController : UIViewController {
    int turns;
    int time;
    int level;
}

@property (nonatomic, retain) IBOutlet Board *board;

@end
