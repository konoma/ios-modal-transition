//
//  SpanTransition.m
//  KNMModalTransition
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "SpanTransition.h"


@implementation SpanTransition

#pragma mark - Animating the Transition

- (void)performTransition:(BOOL)interactive
{
    self.presentedViewController.view.center = [self convertPoint:self.initialCenter toView:self.transitionContainerView];
    self.presentedViewController.view.bounds = self.initialBounds;
    self.presentedViewController.view.transform = self.initialTransform;
    [self.presentedViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.presentedViewController.view.center = [self finalCenterForViewController:self.presentedViewController];
        self.presentedViewController.view.bounds = [self finalBoundsForViewController:self.presentedViewController];
        self.presentedViewController.view.transform = self.finalTransform;
        [self.presentedViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self finishAnimation:nil];
    }];
}

- (void)performDismissingTransition:(BOOL)interactive
{
//    self.presentedViewController.view.center = self.finalCenter;
//    self.presentedViewController.view.bounds = self.finalBounds;
//    self.presentedViewController.view.transform = self.finalTransform;
//    [self.presentedViewController.view layoutIfNeeded];
//    
//    [UIView animateWithDuration:self.duration animations:^{
//        CGRect rect = [self.transitionContainerView convertRect:self.initialRect fromView:self.transitionContainerView.window];
//        self.presentedViewController.view.frame = rect;
//        self.presentedViewController.view.transform = self.initialTransform;
//        [self.presentedViewController.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [self finishAnimation:nil];
//    }];
}

@end
