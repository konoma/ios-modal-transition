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


#pragma mark - Subclassing Hooks

// these properties are only valid during the methods below
@property (nonatomic, readonly) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readonly, weak) UIView *transitionContainerView;
@property (nonatomic, readonly) UIViewController *presentingViewController;
@property (nonatomic, readonly) UIViewController *presentedViewController;

@property (nonatomic, readonly, getter = isDismissing) BOOL dismissing;

- (void)prepareForTransition:(BOOL)interactive; // optional, called before animation starts
- (void)performTransition:(BOOL)interactive; // required, don't call super
- (void)finishAnimation:(void(^)(BOOL finished))completion;


#pragma mark - Interactive Transition

- (void)beginInteractiveDismissalTransition:(void(^)(void))completion;
- (void)updateInteractiveTransitionToProgress:(CGFloat)progress;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end


@interface KNMModalTransition (ReverseTransitions)

- (void)performDismissingTransition:(BOOL)interactive;

@end


@interface UIViewController (KNMModalTransition)

@property (nonatomic, strong, setter = knm_setModalTransition:) KNMModalTransition *knm_modalTransition;

@end
