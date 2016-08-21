//
//  PresentingAnimator.m
//  WePeiYang
//
//  Created by Allen X on 8/20/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

#import "PresentingAnimator.h"

@implementation PresentingAnimator


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}



- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds) * 0.75f,
                              CGRectGetHeight(transitionContext.containerView.bounds) * 0.75f);
    CGPoint p = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);
    toView.center = p;
    
    [transitionContext.containerView addSubview:toView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];

    
}

@end
