//
//  ViewController.h
//  ButtonFun
//
//  Created by Michael Dautermann on 1/7/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import "FunView.h" // circular reference!

@interface ViewController : UIViewController
{
    UITapGestureRecognizer * mGestureRecognizer;
    
    IBOutlet UIButton *mStepButton;
}

- (NSInteger) howManyLiveNeighbors: (FunView *) whoIsAsking;
+ (UIColor *) randomColor;

@end
