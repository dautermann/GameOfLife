//
//  ViewController.m
//  ButtonFun
//
//  Created by Michael Dautermann on 1/7/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import "ViewController.h"
#import "FunView.h"

@interface ViewController ()

- (IBAction) stepButtonTouched: (id) sender;

@end

@implementation ViewController

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // handling code
        CGPoint locationOfTap = [sender locationInView: self.view];
        NSInteger xIndex = floorf(locationOfTap.x / 40.f);
        NSInteger yIndex = floorf(locationOfTap.y / 40.f);
        
        NSInteger rightBound = (self.view.frame.size.width / 40.f);
        
        // if it's in the top right, ignore the tap
        // I can make this much prettier later :-)
        if((xIndex < rightBound - 3) || (yIndex > 1))
        {
        
            // find the view that matches these indexes
            for(UIView * aSubviewFromGameBoard in [self.view subviews])
            {
                if([aSubviewFromGameBoard isKindOfClass: [FunView class]])
                {
                    FunView * specificSquare = (FunView *) aSubviewFromGameBoard;
                    if((specificSquare.xIndex == xIndex) && (specificSquare.yIndex == yIndex))
                    {
                        if(specificSquare.alive == NO)
                        {
                            specificSquare.alive = YES;
                            specificSquare.backgroundColor = [ViewController randomColor];
                        }
                    }
                }
            }
        } else {
            [self stepButtonTouched: sender];
        }
    }
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frameRect = self.view.frame;
    NSInteger xIndex, yIndex = 0;
    for( CGFloat yPosition = 0.0; yPosition < frameRect.size.height; yPosition+=40.0f )
    {
        // reset xIndex on every iteration
        xIndex = 0;
        for( CGFloat xPosition = 0.0; xPosition < frameRect.size.width; xPosition+=40.0f )
        {
            FunView * randomSquare = [[FunView alloc] initWithFrame: CGRectMake(xPosition, yPosition, 40.f, 40.0f)];

            if(randomSquare)
            {
                randomSquare.xIndex = xIndex;
                randomSquare.yIndex = yIndex;
                randomSquare.parentGameBoard = self;
                [self.view addSubview: randomSquare];
            }
            xIndex++;
        }
        yIndex++;
    }
    
    mGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    if(mGestureRecognizer)
    {
        mGestureRecognizer.cancelsTouchesInView = NO;
        mGestureRecognizer.delaysTouchesEnded = NO;
        [self.view addGestureRecognizer: mGestureRecognizer];
    }
}

- (FunView *) getViewAtSpecificX: (NSInteger) x andY: (NSInteger) y
{
    // do this as a block in a bit
    for(UIView * aSubviewFromGameBoard in [self.view subviews])
    {
        if([aSubviewFromGameBoard isKindOfClass: [FunView class]])
        {
            FunView * ourLivingOrDeadCell = (FunView *) aSubviewFromGameBoard;
            if((ourLivingOrDeadCell.xIndex == x) && (ourLivingOrDeadCell.yIndex == y))
                return(ourLivingOrDeadCell);
        }
    }
    return NULL;
}

- (NSInteger) howManyLiveNeighbors: (FunView *) whoIsAsking
{
    NSInteger xIndex = whoIsAsking.xIndex;
    NSInteger yIndex = whoIsAsking.yIndex;

    NSInteger totalLiveNeighbors = 0;
    
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex-1 andY: yIndex-1].alive ? 1 : 0 ); // top left
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex-1 andY: yIndex  ].alive ? 1 : 0 ); // left
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex-1 andY: yIndex+1].alive ? 1 : 0 ); // bottom left
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex   andY: yIndex+1].alive ? 1 : 0 ); // bottom
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex   andY: yIndex-1].alive ? 1 : 0 ); // top
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex+1 andY: yIndex+1].alive ? 1 : 0 ); // bottom right
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex+1 andY: yIndex  ].alive ? 1 : 0 ); // right
    totalLiveNeighbors += ([self getViewAtSpecificX: xIndex+1 andY: yIndex-1].alive ? 1 : 0 ); // top right
    
    return(totalLiveNeighbors);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) stepButtonTouched: (id) sender;
{
    // here we'll step through all cells
    // when we encounter a live one, that cell will call back and ask for neighbors
    // and then we'll decide what to do based on the Game Of Life rules

    // find the view that matches these indexes
    for(UIView * aSubviewFromGameBoard in [self.view subviews])
    {
        if([aSubviewFromGameBoard isKindOfClass: [FunView class]])
        {
            FunView * specificSquare = (FunView *) aSubviewFromGameBoard;

            [specificSquare checkNeighborsCurrentStatus];
        }
    }
  
    // do the actual update and drawing
    for(UIView * aSubviewFromGameBoard in [self.view subviews])
    {
        if([aSubviewFromGameBoard isKindOfClass: [FunView class]])
        {
            FunView * specificSquare = (FunView *) aSubviewFromGameBoard;

            [specificSquare updateMyOwnLifeStatus];
        }
    }
}

+ (UIColor *) randomColor
{
    UIColor * colorToReturn;
    
    uint32_t randomNumber = random();
    randomNumber = (randomNumber % 10); // a random number between 0 & 10
    
    switch(randomNumber)
    {
        case 0 :
            colorToReturn = [UIColor blueColor];
            break;
        case 1 :
            colorToReturn = [UIColor grayColor];
            break;
        case 2 :
            colorToReturn = [UIColor greenColor];
            break;
        case 3 :
            colorToReturn = [UIColor purpleColor];
            break;
        case 4 :
            colorToReturn = [UIColor redColor];
            break;
        case 5 :
            colorToReturn = [UIColor brownColor];
            break;
        case 6 :
            colorToReturn = [UIColor cyanColor];
            break;
        case 7 :
            colorToReturn = [UIColor orangeColor];
            break;
        case 8 :
            colorToReturn = [UIColor magentaColor];
            break;
        case 9 :
            colorToReturn = [UIColor yellowColor];
            break;
        default :
            colorToReturn = [UIColor blackColor];
            
    }
    return(colorToReturn);
}

@end
