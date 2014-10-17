//
//  KNMModalTransition.m
//  KNMModalTransitions
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMModalTransition.h"

#import <objc/runtime.h>


#define IS_IOS_7 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_0)

static CGPoint CenterOfRect(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


@interface KNMModalTransition ()

@property (nonatomic, readwrite) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readwrite) UIViewController *presentingViewController;
@property (nonatomic, readwrite) UIViewController *presentedViewController;
@property (nonatomic, readwrite, getter = isDismissing) BOOL dismissing;

@property (nonatomic, readwrite, weak) UIView *transitionContainerView;
@property (nonatomic, readwrite) CGAffineTransform initialTransform;
@property (nonatomic, readwrite) CGAffineTransform finalTransform;
@property (nonatomic, readwrite) CGPoint finalCenter;
@property (nonatomic, readwrite) CGRect finalBounds;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, weak) UIViewController *owningController;

@end

@implementation KNMModalTransition

#pragma mark - Initialization

- (instancetype)initWithDuration:(NSTimeInterval)duration
{
    if ((self = [super init])) {
        _duration = duration;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDuration:0.25];
}


#pragma mark - Performing the Transition

- (void)prepareForTransition:(BOOL)interactive
{
}

- (void)performTransition:(BOOL)interactive
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must be overridden" userInfo:nil];
}

- (void)finishAnimation:(void(^)(BOOL finished))completion
{
    BOOL success = ![self.transitionContext transitionWasCancelled];
    if (completion != nil) {
        completion(success);
    }
    
    [self.transitionContext completeTransition:success];
    
    self.transitionContext = nil;
    self.presentingViewController = nil;
    self.presentedViewController = nil;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    if (presented != self.owningController) {
        return nil;
    }
    
    self.presentedViewController = presented;
    self.presentingViewController = presenting;
    self.dismissing = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (dismissed != self.owningController || ![self respondsToSelector:@selector(performDismissingTransition:)]) {
        return nil;
    }
    
    self.presentedViewController = dismissed;
    self.presentingViewController = dismissed.presentingViewController;
    self.dismissing = YES;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionController;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    if (self.transitionContainerView == nil) { // on iOS 8 the containerView is persistent so we don't recreate it
        self.transitionContainerView = [self transitionContainerViewForContext:transitionContext];
    }
    
    [self setupViewControllerTransformsAndFrames];
    
//    [self.transitionContainerView addSubview:self.presentingViewController.view];
//    [self.transitionContainerView addSubview:self.presentedViewController.view];
    
    [self prepareForTransition:[transitionContext isInteractive]];
    
    if ([self isDismissing]) {
        [self performDismissingTransition:[transitionContext isInteractive]];
    }
    else {
        [self performTransition:[transitionContext isInteractive]];
    }
}


#pragma mark - Interactive Transition

- (void)beginInteractiveDismissalTransition:(void (^)(void))completion
{
    self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    [self.owningController dismissViewControllerAnimated:YES completion:completion];
}

- (void)updateInteractiveTransitionToProgress:(CGFloat)progress
{
    [self.interactionController updateInteractiveTransition:progress];
}

- (void)cancelInteractiveTransition
{
    [self.interactionController cancelInteractiveTransition];
    self.interactionController = nil;
}

- (void)finishInteractiveTransition
{
    [self.interactionController finishInteractiveTransition];
    self.interactionController = nil;
}


#pragma mark - Rotation Helpers

- (void)setupViewControllerTransformsAndFrames
{
    self.presentedViewController.view.transform = self.presentingViewController.view.transform;
    
    self.initialTransform = self.presentingViewController.view.transform;
    self.finalTransform = CGAffineTransformIdentity;
    
    self.finalCenter = CenterOfRect(self.transitionContainerView.bounds);
    self.finalBounds = self.transitionContainerView.bounds;
}

- (UIView *)transitionContainerViewForContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UILabel *transformView = [[UILabel alloc] init];
    
    transformView.text = @"Transform View";
    transformView.textAlignment = NSTextAlignmentCenter;
    
    transformView.center = CenterOfRect(containerView.bounds);
    
    transformView.bounds = self.presentingViewController.view.bounds;
    transformView.transform = self.presentingViewController.view.transform;
    
    transformView.layer.borderColor = [UIColor redColor].CGColor;
    transformView.layer.borderWidth = 1.0f;
    [containerView addSubview:transformView];
    return transformView;
}

- (CGAffineTransform)transformForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:           return CGAffineTransformIdentity;
        case UIInterfaceOrientationPortraitUpsideDown: return CGAffineTransformMakeRotation(M_PI);
        case UIInterfaceOrientationLandscapeLeft:      return CGAffineTransformMakeRotation(-M_PI_2);
        case UIInterfaceOrientationLandscapeRight:     return CGAffineTransformMakeRotation(M_PI_2);
        
        default:
            return CGAffineTransformIdentity;
    }
}

@end


@implementation UIViewController (STKModalTransition)

static NSUInteger KNMModalTransitionKey;

- (KNMModalTransition *)knm_modalTransition
{
    return objc_getAssociatedObject(self, &KNMModalTransitionKey);
}

- (void)knm_setModalTransition:(KNMModalTransition *)transition
{
    self.knm_modalTransition.owningController = nil;
    
    self.transitioningDelegate = transition;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    transition.owningController = self;
    
    objc_setAssociatedObject(self, &KNMModalTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
