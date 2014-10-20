//
//  KNMModalTransition.m
//  KNMModalTransitions
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMModalTransition.h"

#import <objc/runtime.h>


#define IOS_8_OR_LATER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_0)


@interface KNMModalTransition ()

@property (nonatomic, readwrite) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readwrite) UIView *transitionContainerView;
@property (nonatomic, readwrite) UIViewController *presentingViewController;
@property (nonatomic, readwrite) UIViewController *presentedViewController;
@property (nonatomic, readwrite, getter = isDismissing) BOOL dismissing;

@property (nonatomic, readwrite) CGAffineTransform initialTransform;
@property (nonatomic, readwrite) CGAffineTransform finalTransform;

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
    self.transitionContainerView = [transitionContext containerView];
    
    [self prepareTransitionParameters];
    
    [self prepareForTransition:[transitionContext isInteractive]];
    
    if ([self isDismissing]) {
        [self performDismissingTransition:[transitionContext isInteractive]];
    }
    else {
        [self performTransition:[transitionContext isInteractive]];
    }
}


#pragma mark - Animating the Transition

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

- (void)prepareTransitionParameters
{
    if (![self isDismissing]) {
        [self.transitionContainerView addSubview:self.presentedViewController.view];
        
        self.initialTransform = self.presentingViewController.view.transform;
        self.finalTransform = self.presentedViewController.view.transform;
        self.presentingViewController.view.frame = [self.transitionContext initialFrameForViewController:self.presentingViewController];
    } else {
        [self.transitionContainerView insertSubview:self.presentingViewController.view atIndex:0];
        
        self.initialTransform = self.presentedViewController.view.transform;
        self.finalTransform = self.presentingViewController.view.transform;
        self.presentingViewController.view.frame = [self.transitionContext finalFrameForViewController:self.presentingViewController];
    }
}

- (CGPoint)initialCenterForViewController:(UIViewController *)viewController
{
    CGRect initialFrame = [self.transitionContext initialFrameForViewController:viewController];
    return CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
}

- (CGPoint)finalCenterForViewController:(UIViewController *)viewController
{
    CGRect finalFrame = [self.transitionContext finalFrameForViewController:viewController];
    return CGPointMake(CGRectGetMidX(finalFrame), CGRectGetMidY(finalFrame));
}

- (CGRect)initialBoundsForViewController:(UIViewController *)viewController
{
    CGRect initialFrame = [self.transitionContext finalFrameForViewController:viewController];
    CGAffineTransform transform = (viewController == self.presentedViewController ? self.initialTransform : self.finalTransform);
    CGRect rotatedFrame = CGRectApplyAffineTransform(initialFrame, transform);
    return (CGRect) { .size = rotatedFrame.size };
}

- (CGRect)finalBoundsForViewController:(UIViewController *)viewController
{
    CGRect finalFrame = [self.transitionContext finalFrameForViewController:viewController];
    CGAffineTransform transform = (viewController == self.presentingViewController ? self.initialTransform : self.finalTransform);
    CGRect rotatedFrame = CGRectApplyAffineTransform(finalFrame, transform);
    return (CGRect) { .size = rotatedFrame.size };
}

- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view
{
    UIWindow *window = ([view isKindOfClass:[UIWindow class]] ? (UIWindow *)view : view.window);
    CGPoint windowPoint = [window convertPoint:point fromView:view];
    CGPoint screenPoint = [window convertPoint:windowPoint toWindow:nil];
    
    if (IOS_8_OR_LATER) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGAffineTransform transform = [self transformForInterfaceOrientation:orientation];
        screenPoint = [self applyTransform:CGAffineTransformInvert(transform) toPoint:screenPoint inRect:window.bounds];
    }
    
    return screenPoint;
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view
{
    UIWindow *window = ([view isKindOfClass:[UIWindow class]] ? (UIWindow *)view : view.window);
    
    if (IOS_8_OR_LATER) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGAffineTransform transform = [self transformForInterfaceOrientation:orientation];
        CGRect bounds = window.bounds;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            // in landscape the window bounds are changed in iOS 8
            // we expect portrait bounds
            bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
        }
        point = [self applyTransform:transform toPoint:point inRect:bounds];
    }
    
    CGPoint windowPoint = [window convertPoint:windowPoint fromWindow:nil];
    CGPoint viewPoint = [window convertPoint:point toView:view];
    
    return viewPoint;
}

- (CGPoint)applyTransform:(CGAffineTransform)transform toPoint:(CGPoint)point inRect:(CGRect)rect
{
    NSParameterAssert(CGPointEqualToPoint(rect.origin, CGPointZero));
    
    if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeRotation(M_PI))) {
        return CGPointMake((rect.size.width - point.x), (rect.size.height - point.y));
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeRotation(M_PI_2))) {
        return CGPointMake(point.y, (rect.size.width - point.x));
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeRotation(-M_PI_2))) {
        return CGPointMake((rect.size.height - point.y), point.x);
    } else {
        NSAssert(CGAffineTransformIsIdentity(transform), @"Unsupported transform");
        return point;
    }
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


#pragma mark - UIViewController Additions

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
