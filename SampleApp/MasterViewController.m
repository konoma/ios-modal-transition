//
//  MasterViewController.m
//  SampleApp
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "SpanTransition.h"


@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.presentDetailButton.layer.cornerRadius = 3.0f;
    self.presentDetailButton.layer.borderColor = self.presentDetailButton.tintColor.CGColor;
    self.presentDetailButton.layer.borderWidth = 1.0f;
}

- (void)presentDetail:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.preferredInterfaceOrientationForPresentation = [self preferredDetailOrientation];
    
    SpanTransition *transition = [[SpanTransition alloc] initWithDuration:5.0];
    transition.initialCenter = [transition convertPoint:sender.center fromView:sender.superview];
    transition.initialBounds = sender.bounds;
    controller.knm_modalTransition = transition;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (UIInterfaceOrientation)preferredDetailOrientation
{
    switch (self.detailOrientationSwitch.selectedSegmentIndex) {
        case 0: return UIInterfaceOrientationPortrait;
        case 1: return UIInterfaceOrientationPortraitUpsideDown;
        case 2: return UIInterfaceOrientationLandscapeLeft;
        case 3: return UIInterfaceOrientationLandscapeRight;
        
        default:
            return UIInterfaceOrientationPortrait;
    }
}

@end
