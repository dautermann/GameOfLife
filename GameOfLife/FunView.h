//
//  FunView.h
//  ButtonFun
//
//  Created by Michael Dautermann on 1/8/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface FunView : UIView

- (void) checkNeighborsCurrentStatus;
- (void) updateMyOwnLifeStatus;

@property (readwrite) NSInteger xIndex;
@property (readwrite) NSInteger yIndex;

@property (readwrite) BOOL alive;
@property (readwrite) BOOL willLiveInNextGeneration;

@property (strong) ViewController * parentGameBoard;

@end
