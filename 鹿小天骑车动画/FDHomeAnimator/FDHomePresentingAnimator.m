//
//  FDHomePresentingAnimator.m
//  Popping
//
//  Created by DaBin on 2017/1/5.
//  Copyright © 2017年 André Schneider. All rights reserved.
//

#import "FDHomePresentingAnimator.h"
#import <POP/POP.h>

@implementation FDHomePresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds),
                              CGRectGetHeight(transitionContext.containerView.bounds));
    
    [transitionContext.containerView addSubview:toView];
    
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.fromValue = @(0.0);
    alphaAnimation.toValue = @(1.0);
    [toView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    [alphaAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
