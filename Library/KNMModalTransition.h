//
//  KNMModalTransition.h
//  KNMModalTransitions
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KNMModalTransition : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDuration:(NSTimeInterval)duration;

@property (nonatomic, readonly) NSTimeInterval duration;


#pragma mark - Transition Parameters

// these properties are only valid during the transition
@property (nonatomic, readonly) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readonly) UIView *transitionContainerView;
@property (nonatomic, readonly) UIViewController *presentingViewController;
@property (nonatomic, readonly) UIViewController *presentedViewController;

@property (nonatomic, readonly, getter = isDismissing) BOOL dismissing;


#pragma mark - Animating the Transition

- (void)prepareForTransition:(BOOL)interactive; // optional, called before animation starts
- (void)performTransition:(BOOL)interactive; // required, don't call super
- (void)finishAnimation:(void(^)(BOOL finished))completion;


#pragma mark - Interactive Transition

- (void)beginInteractiveDismissalTransition:(void(^)(void))completion;
- (void)updateInteractiveTransitionToProgress:(CGFloat)progress;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;


#pragma mark - Rotation Helpers

@property (nonatomic, readonly) CGAffineTransform initialTransform;
@property (nonatomic, readonly) CGAffineTransform finalTransform;

- (CGPoint)initialCenterForViewController:(UIViewController *)viewController;
- (CGPoint)finalCenterForViewController:(UIViewController *)viewController;

- (CGRect)initialBoundsForViewController:(UIViewController *)viewController;
- (CGRect)finalBoundsForViewController:(UIViewController *)viewController;

- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;

@end


@interface KNMModalTransition (ReverseTransitions)

- (void)performDismissingTransition:(BOOL)interactive;

@end


@interface UIViewController (KNMModalTransition)

@property (nonatomic, strong, setter = knm_setModalTransition:) KNMModalTransition *knm_modalTransition;

@end
