//
//  Board.h
//  concentration
//
//  Created by Brent Sanders on 12/20/11.
//  Copyright (c) 2011 Sanders New Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Board : UIView {
   
}
- (id)initWithCards:(NSArray *)theCards;
@property (nonatomic, retain) NSMutableArray *cardLayers;
@end
