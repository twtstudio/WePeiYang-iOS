//
//  DismissingAnimator.h
//  WePeiYang
//
//  Created by Allen X on 8/20/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

#import "DismissingAnimator.h"
#import "POP.h"

@implementation DismissingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    
    POPBasicAnimation *closeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    closeAnimation.toValue = @(-fromView.layer.position.y);
    [closeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    POPSpringAnimation *scaleDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleDownAnimation.springBounciness = 20;
    scaleDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    [fromView.layer pop_addAnimation:closeAnimation forKey:@"closeAnimation"];
    [fromView.layer pop_addAnimation:scaleDownAnimation forKey:@"scaleDown"];
 
}

@end
