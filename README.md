# KNMModalTransition

KNMModalTransition is a modal transition base class that provides some
abstractions over `UIViewControllerTransitioningDelegate` and `UIViewControllerAnimatedTransitioning`.


# Installation

The preferred way is using [CocoaPods](http://cocoapods.org). Include
the following in your `Podfile` and run `pod install`.

    pod 'KNMModalTransition'

Alternatively just copy the sources into your project.


# Usage

To create a modal transition create a subclass of `KNMModalTransition`.

`KNMModalTransition` implements both `UIViewControllerTransitioningDelegate`
and `UIViewControllerAnimatedTransitioning`. To make things easier it
provides its own set of methods that are called when animating.


## Provided Properties

`KNMModalTransition` provides the container view to animate in as
`transitionContainerView`, as well as the presenting and presented view
controller using `presentingViewController` and `presentedViewController`
respectively. If necessary you can access the transition context using
`transitionContext`.


## Transition Animations

To animate a transition implement `-performTransition:`, to animate the
dismissal implement `-performDismissingTransition:`. When done call
`-finishAnimation:` to let the transition know your animation is completed.
If you pass a block to `-finishAnimation:` it will get executed after the
system is notified that the transaction is done, but before any properties
are invalidated. The block gets passed a boolean that tells wether the
animation was completed or canceled (useful in interactive transitions).

    - (void)performTransition:(BOOL)interactive {
        self.presentedViewController.view.alpha = 0.0f;
        [UIView animateWithDuration:self.duration animations:^{
            self.presentedViewController.view.alpha = 1.0f;
        } completion:^{
            [self finishAnimation:nil];
        }];
    }

`-performDismissingTransition:` works the same way.


## Changing Orientation

`KNMModalTransition` provides helpers that make dealing with orientation
changes a bit more convenient.

> *Note:* Since we're changing orientations, there will be transforms on
> the views. Don't forget to always work with `bounds` and `center` as
> opposed to `frame`. Weird things happen if you don't.

There are two properties, `initialTransform` and `finalTransform`, that
return the transform needed for the _presented_  view controller to be
in the correct orientation at the start (initial) and end (final) of
the transition.

To get inital and final centers and bounds you can use
`-initial[Center|Bounds]ForViewController:` and the `final` variants
thereof.

If you need to store a point on the screen so you can apply it to a view
later you can use `-convertPoint:fromView:` and `-convertPoint:toView:`. 


## Interactive Dismissals

To make an interctive dismissal provide a gesture recognizer or anything
that can drive the progress of your dismissal.

To start an interactive dismissal call `-beginInteractiveDismissalTransition:`
on your custom transition. The block is optional and called when the transition
completes. The transition is then driven by a `UIPercentDrivenInteractiveTransition`.

While your transition is in progress call `-updateInteractiveTransitionToProgress:`,
and when it's done call `-finishInteractiveTransition`. If you want to
cancel the animation call `-cancelInteractiveTransition`.


## Examples

There is a sample project that you can run with `pod try KNMModalTransition`.
