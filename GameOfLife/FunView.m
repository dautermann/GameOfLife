//
//  FunView.m
//  ButtonFun
//
//  Created by Michael Dautermann on 1/8/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import "FunView.h"
#import "ViewController.h"

@implementation FunView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _alive = NO;
    }
    return self;
}

- (void) checkNeighborsCurrentStatus
{
    // ask gameboard for my 8 neighbors
    //    Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    //    Any live cell with two or three live neighbours lives on to the next generation.
    //    Any live cell with more than three live neighbours dies, as if by overcrowding.
    //    Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
    NSInteger liveNeighbors = [self.parentGameBoard howManyLiveNeighbors: self];
    if(self.alive)
    {
        switch(liveNeighbors)
        {
            // the rules from http://en.wikipedia.org/wiki/Conway's_Game_of_Life
            // Any live cell with fewer than two live neighbours dies, as if caused by under-population.
            // Any live cell with two or three live neighbours lives on to the next generation.
            // Any live cell with more than three live neighbours dies, as if by overcrowding.
            case 2 :
            case 3 :
                self.willLiveInNextGeneration = YES;
                break;
            default :
                break;
        }
    } else {
        // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        if(liveNeighbors == 3)
            self.willLiveInNextGeneration = YES;
    }
}

- (void) updateMyOwnLifeStatus
{
    // only call this when right before it's time to update the game board and all
    // other cells (me and my neighbors and everyone else) have
    // determined whether they will live or die
    self.alive = self.willLiveInNextGeneration;
    self.willLiveInNextGeneration = NO;
    
    // now redraw myself
    if(self.alive)
        [self setBackgroundColor: [ViewController randomColor]];
    else
        [self setBackgroundColor: [UIColor whiteColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
