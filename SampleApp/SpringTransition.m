//
//  SpringTransition.m
//  KNMModalTransition
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "SpringTransition.h"


@implementation SpringTransition

- (void)performTransition:(BOOL)interactive
{
    self.presentedViewController.view.frame = self.initialRect;
    [self.presentedViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:self.duration animations:^{
        CGRect targetFrame = [self.transitionContext finalFrameForViewController:self.presentedViewController];
        self.presentedViewController.view.frame = targetFrame;
        [self.presentedViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self finishAnimation:nil];
    }];
}

- (void)performDismissingTransition:(BOOL)interactive
{
    self.presentingViewController.view.frame = [self.transitionContext finalFrameForViewController:self.presentingViewController];
    self.presentedViewController.view.frame = [self.transitionContext initialFrameForViewController:self.presentedViewController];
    
    [self.presentedViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.presentedViewController.view.frame = self.initialRect;
        [self.presentedViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self finishAnimation:nil];
    }];
}

@end
