//
//  MVRightSlideView.m
//  AotoLayoutTest
//
//  Created by wangcw on 16/6/16.
//  Copyright © 2016年 guosen. All rights reserved.
//

#import "MVRightSlideView.h"

@interface RealRightView : UIView

- (void)setRealFrame:(CGRect)frame;

@end

@implementation RealRightView

- (void)setFrame:(CGRect)frame
{
    
}

- (void)setBounds:(CGRect)bounds
{
    
}

- (void)setRealFrame:(CGRect)frame
{
    [super setFrame:frame];
}

@end



@interface MVRightSlideView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *userRootView;
@property (nonatomic, weak) UIView *sysRootView;
@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, strong) RealRightView *realRightView;
@property (nonatomic, assign) CGFloat rightViewTop;
@property (nonatomic, assign) CGSize rightViewSize;

@property (nonatomic, strong) UIView *rootMaskView;
@property (nonatomic, strong) UIView *rightMaskView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) NSNumber *rightViewGestureStartX;
@property (assign, nonatomic) BOOL rightViewShowingBeforeGesture;
@property (nonatomic, assign) BOOL shouldReceiveTapGestureRecognizer;
@property (nonatomic, assign) BOOL shouldReceivePanGestureRecognizer;

@end


@implementation MVRightSlideView

- (instancetype)initWithRootView:(UIView *)rootView rightViewTop:(CGFloat)rightViewTop rightViewSize:(CGSize)rightViewSize
{
    if (self = [super init])
    {
        _userRootView = rootView;
        _sysRootView = [[UIApplication sharedApplication] keyWindow];
        _rightViewTop = rightViewTop;
        _rightViewSize = rightViewSize;
        
        [self setupDefaults];
    }
    
    return self;
}

- (void)setupDefaults
{
    if (_userRootView == nil)
    {
        _userRootView = _sysRootView;
    }
    
    _isShowing = NO;
    _hideWhenTap = YES;
    _hotArea = CGRectMake(CGRectGetWidth(_userRootView.frame) - 44.f, 0.f, 44.f, CGRectGetHeight(_userRootView.frame));
    _slideWidthForChangeState = 0.f;
    _animationDuration = 0.5;
    _shouldReceivePanGestureRecognizer = YES;
    _shouldReceiveTapGestureRecognizer = YES;
    
    _maskColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _rightMaskColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    _rootMaskView = [[UIView alloc] init];
    _rootMaskView.backgroundColor = _maskColor;
    _rootMaskView.alpha = 0.f;
    _rootMaskView.hidden = YES;
    _rootMaskView.frame = _sysRootView.bounds;
    [self addSubview:_rootMaskView];
    
    _realRightView = [[RealRightView alloc] init];
    _realRightView.backgroundColor = [UIColor clearColor];
    _realRightView.hidden = YES;
    [self addSubview:_realRightView];
    
    _rightMaskView = [[UIView alloc] init];
    _rightMaskView.backgroundColor = _rightMaskColor;
    _rightMaskView.alpha = 0.f;
    _rightMaskView.frame = _realRightView.bounds;
    _rightMaskView.hidden = YES;
    [_realRightView addSubview:_rightMaskView];
    
    self.clipsToBounds = YES;
    [super setBackgroundColor:[UIColor clearColor]];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    _tapGesture.delegate = self;
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.numberOfTouchesRequired = 1;
    _tapGesture.cancelsTouchesInView = NO;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.delegate = self;
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.cancelsTouchesInView = YES;
    
    [self setRootView:_userRootView];
    [self layoutViewsWithPercentage:0.f];
    [self setEnabled:YES];
}

- (UIView *)rightView
{
    return _realRightView;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    _tapGesture.enabled = enabled;
    _panGesture.enabled = enabled;
}

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!_isShowing)
    {
        [self showRightViewPrepare];
        
        [self showRightViewAnimated:animated fromPercentage:0.f completionHandler:completionHandler];
    }
}

- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (_isShowing)
    {
        [self hideRightViewAnimated:animated fromPercentage:1.f completionHandler:completionHandler];
    }
}

- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    if (_isShowing)
    {
        [self hideRightViewAnimated:animated completionHandler:completionHandler];
    }
    else
    {
        [self showRightViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if (!_hideWhenTap)
    {
        return;
    }
    
    _shouldReceiveTapGestureRecognizer = [self shouldReceiveGestureRecognizer:gestureRecognizer];
    if (!_shouldReceiveTapGestureRecognizer)
    {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hideRightViewAnimated:YES completionHandler:nil];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        _shouldReceivePanGestureRecognizer = [self shouldReceiveGestureRecognizer:gestureRecognizer];
    }
    if (!_shouldReceivePanGestureRecognizer)
    {
        return;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    CGSize size = self.frame.size;

    if (_realRightView)
    {
        if (!_rightViewGestureStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged))
        {
            _tapGesture.enabled = NO;
            
            CGFloat interactiveX = (_isShowing ? size.width - _rightViewSize.width : size.width);
            BOOL velocityDone = (_isShowing ? velocity.x > 0.f : velocity.x < 0.f);
            
            CGFloat width = CGRectGetWidth(_hotArea);
            CGFloat shiftLeft = (_isShowing? width / 2.f :  width);
            CGFloat shiftRight = width;
            
            BOOL needProcess = NO;
            if (_isShowing)
            {
                if (location.x <= interactiveX + shiftRight)
                {
                    needProcess = YES;
                }
                else if (location.y < CGRectGetMinY(_realRightView.frame) || location.y > CGRectGetMaxY(_realRightView.frame))
                {
                    needProcess = YES;
                }
            }
            else if (location.x >= interactiveX - shiftLeft && location.x <= interactiveX + shiftRight && location.y >= CGRectGetMinY(_hotArea) && location.y <= CGRectGetMaxY(_hotArea))
            {
                needProcess = YES;
            }
            
            if (velocityDone && needProcess)
            {
                _rightViewGestureStartX = [NSNumber numberWithFloat:location.x];
                _rightViewShowingBeforeGesture = _isShowing;
                
                if (!_isShowing)
                {
                    [self setRootView:_sysRootView];
                    
                    [self showRightViewPrepare];
                }
            }
        }
        else if (_rightViewGestureStartX)
        {
            CGFloat firstVar = 0.f;
            if (_rightViewShowingBeforeGesture)
            {
                firstVar = (location.x - (size.width - _rightViewSize.width)) - (_rightViewSize.width - (size.width - _rightViewGestureStartX.floatValue));
            }
            else
            {
                firstVar = (location.x - (size.width - _rightViewSize.width)) + (size.width - _rightViewGestureStartX.floatValue);
            }

            CGFloat percentage = 1.f - firstVar / _rightViewSize.width;
            if (percentage < 0.f)
            {
                percentage = 0.f;
            }
            else if (percentage > 1.f)
            {
                percentage = 1.f;
            }
            
            if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
            {
                [self layoutViewsWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && _rightViewGestureStartX)
            {
                CGFloat ratio = _slideWidthForChangeState / _rightViewSize.width;
                if ((velocity.x < 0.f && percentage < 1.f && percentage >= ratio) || (velocity.x == 0.f && percentage >= 0.5) || (velocity.x > 0.f && percentage >= 1 - ratio))
                {
                    [self showRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if ((velocity.x < 0.f && percentage < ratio) || (velocity.x == 0.f && percentage < 0.5) || (velocity.x > 0.f && percentage < 1 - ratio))
                {
                    [self hideRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if (percentage == 0.f)
                {
                    [self hideRightViewComleteAfterGesture];
                }
                else if (percentage == 1.f)
                {
                    [self didShowRightSlideView];
                }
                else
                {
                    NSLog(@"FK");
                }
                
                _rightViewGestureStartX = nil;
                _tapGesture.enabled = YES;
            }
            else
            {
                _tapGesture.enabled = YES;
                return;
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == _tapGesture)
    {
        return ([touch.view isEqual:_rootMaskView]);
    }
    else if (gestureRecognizer == _panGesture)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Show Or Hide

- (void)showRightViewPrepare
{
    _isShowing = YES;

    [self endEditing:YES];
    [self layoutViewsWithPercentage:0.f];
    [self showOrHideViewsWithDelay:0];
    
    [self willShowRightSlideView];
}

- (void)showRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    if (animated)
    {
        [MVRightSlideView animateStandardWithDuration:_animationDuration
                                           animations:^(void)
         {
             [self layoutViewsWithPercentage:1.f];
         }
                                           completion:^(BOOL finished)
         {
             if (finished)
             {
                 [self showOrHideViewsWithDelay:0];
             }
             if (completionHandler)
             {
                 completionHandler();
             }
             
             [self didShowRightSlideView];
         }];
    }
    else
    {
        [self layoutViewsWithPercentage:1.f];
        
        [self showOrHideViewsWithDelay:0];
        if (completionHandler)
        {
            completionHandler();
        }
        
        [self didShowRightSlideView];
    }
}

- (void)hideRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    [self willHideRightSlideView];
    
    if (animated)
    {
        [MVRightSlideView animateStandardWithDuration:_animationDuration
                                           animations:^(void)
         {
             [self layoutViewsWithPercentage:0.f];
         }
                                           completion:^(BOOL finished)
         {
             _isShowing = NO;
             
             if (finished)
             {
                 [self showOrHideViewsWithDelay:0];
             }
             if (completionHandler)
             {
                 completionHandler();
             }
             
             [self didHideRightSlideView];
         }];
    }
    else
    {
        _isShowing = NO;

        [self layoutViewsWithPercentage:0.f];
        
        [self showOrHideViewsWithDelay:0];
        
        if (completionHandler)
        {
            completionHandler();
        }
        
        [self didHideRightSlideView];
    }
}

- (void)hideRightViewComleteAfterGesture
{
    _isShowing = NO;
    
    [self willHideRightSlideView];

    [self showOrHideViewsWithDelay:0.25f];
    
    [self didHideRightSlideView];
}

- (void)layoutViewsWithPercentage:(CGFloat)percentage
{
    CGSize size = self.frame.size;
    
    _rootMaskView.alpha = percentage;
    _rightMaskView.alpha = 1.f - percentage;
    
    CGFloat xStart = size.width - _rightViewSize.width + _rightViewSize.width * (1.f - percentage);
    [_realRightView setRealFrame:CGRectMake(xStart, _rightViewTop, _rightViewSize.width, _rightViewSize.height)];
    _rightMaskView.frame = _realRightView.bounds;
    _rightMaskView.layer.cornerRadius = _realRightView.layer.cornerRadius;
}

- (void)showOrHideViewsWithDelay:(NSTimeInterval)delay
{
    if (!_isShowing)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootMaskView.hidden = YES;
                               _rightMaskView.hidden = YES;
                               _realRightView.hidden = YES;
                               
                               [self setRootView:_userRootView];
                           });
        }
        else
        {
            _rootMaskView.hidden = YES;
            _rightMaskView.hidden = YES;
            _realRightView.hidden = YES;
            
            [self setRootView:_userRootView];
        }
    }
    else
    {
        _rootMaskView.hidden = NO;
        _rightMaskView.hidden = NO;
        _realRightView.hidden = NO;
        [_realRightView bringSubviewToFront:_rightMaskView];
    }
}

- (void)setRootView:(UIView *)rootView
{
    if (_rootView != rootView)
    {
        if (rootView == _userRootView)
        {
            [super setFrame:_userRootView.bounds];
            [_userRootView insertSubview:self atIndex:0];
            
            if (_rootView == _sysRootView)
            {
                _rightViewTop = [_sysRootView convertPoint:CGPointMake(0.f, _rightViewTop) toView:_userRootView].y;
            }
        }
        else if (rootView == _sysRootView)
        {
            if (_rootView == _userRootView)
            {
                _rightViewTop = [self convertPoint:CGPointMake(0.f, _rightViewTop) toView:_sysRootView].y;
                
                [super setFrame:_sysRootView.bounds];
                [_sysRootView addSubview:self];
            }
        }
        
        [_rootView removeGestureRecognizer:_panGesture];
        [_rootView removeGestureRecognizer:_tapGesture];
        
        _rootView = rootView;
        
        [_rootView addGestureRecognizer:_panGesture];;
        [_rootView addGestureRecognizer:_tapGesture];
    }
}

#pragma mark - Support

+ (void)animateStandardWithDuration:(NSTimeInterval)duration animations:(void(^)())animations completion:(void(^)(BOOL finished))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:animations
                         completion:completion];
    }
    else
    {
        [UIView animateWithDuration:duration*0.66
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:completion];
    }
}

- (BOOL)shouldReceiveGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shouldReceiveGestureRecognizer");
    
    if (_delegate && [_delegate respondsToSelector:@selector(rightSlideView:shouldReceiveGestureRecognizer:)] && ![_delegate rightSlideView:self shouldReceiveGestureRecognizer:gestureRecognizer])
    {
        return NO;
    }
    
    return YES;
}

- (void)willShowRightSlideView
{
    NSLog(@"willShowRightSlideView");
    
    if (_delegate && [_delegate respondsToSelector:@selector(willShowRightSlideView:)])
    {
        [_delegate willShowRightSlideView:self];
    }
}

- (void)didShowRightSlideView
{
    NSLog(@"didShowRightSlideView");
    
    if (_delegate && [_delegate respondsToSelector:@selector(didShowRightSlideView:)])
    {
        [_delegate didShowRightSlideView:self];
    }
}

- (void)willHideRightSlideView
{
    NSLog(@"willHideRightSlideView");
    
    if (_delegate && [_delegate respondsToSelector:@selector(willHideRightSlideView:)])
    {
        [_delegate willHideRightSlideView:self];
    }
}

- (void)didHideRightSlideView
{
    NSLog(@"didHideRightSlideView");
    
    if (_delegate && [_delegate respondsToSelector:@selector(didHideRightSlideView:)])
    {
        [_delegate didHideRightSlideView:self];
    }
}

#pragma mark - Protect Old

- (void)setFrame:(CGRect)frame
{
    
}

- (void)setBounds:(CGRect)bounds
{
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    
}

@end
