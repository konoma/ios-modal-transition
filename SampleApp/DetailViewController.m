//
//  DetailViewController.m
//  KNMModalTransitions
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

#pragma mark - Configuration

@synthesize preferredInterfaceOrientationForPresentation = _preferredInterfaceOrientationForPresentation;

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return _preferredInterfaceOrientationForPresentation;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationIsLandscape(self.preferredInterfaceOrientationForPresentation)
            ? UIInterfaceOrientationMaskLandscape
            : (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown));
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.closeButton.layer.cornerRadius = 3.0f;
    self.closeButton.layer.borderColor = self.closeButton.tintColor.CGColor;
    self.closeButton.layer.borderWidth = 1.0f;
}


#pragma mark - Actions

- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
