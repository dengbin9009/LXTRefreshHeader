//
//  FDHomeDismissingAnimator.m
//  Popping
//
//  Created by DaBin on 2017/1/5.
//  Copyright © 2017年 André Schneider. All rights reserved.
//

#import "FDHomeDismissingAnimator.h"
#import <POP/POP.h>

@implementation FDHomeDismissingAnimator 

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(0.0);
    [fromVC.view pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    [alphaAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
