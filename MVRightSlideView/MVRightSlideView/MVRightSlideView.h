//
//  MVRightSlideView.h
//  AotoLayoutTest
//
//  Created by wangcw on 16/6/16.
//  Copyright © 2016年 guosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVRightSlideViewDelegate;

@interface MVRightSlideView : UIView

@property (nonatomic, readonly, strong) UIView *rightView;
@property (nonatomic, readonly, assign) BOOL showing;

@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *rightMaskColor;
@property (nonatomic, assign) NSTimeInterval animationSpeed;

@property (nonatomic, assign) BOOL gestureEnabled;
@property (nonatomic, assign) BOOL hideWhenTap;
@property (nonatomic, assign) CGFloat gestureDetectTop;
@property (nonatomic, assign) CGSize gestureDetectSize;

@property (nonatomic, weak) id <MVRightSlideViewDelegate> delegate;

- (instancetype)initWithRootView:(UIView *)rootView rightViewTop:(CGFloat)rightViewTop rightViewSize:(CGSize)rightViewSize;

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;

@end


@protocol MVRightSlideViewDelegate <NSObject>

@optional
- (BOOL)rightSlideView:(MVRightSlideView *)rightSlideView shouldReceiveGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

- (void)willShowRightSlideView:(MVRightSlideView *)rightSlideView;
- (void)didShowRightSlideView:(MVRightSlideView *)rightSlideView;

- (void)willHideRightSlideView:(MVRightSlideView *)rightSlideView;
- (void)didHideRightSlideView:(MVRightSlideView *)rightSlideView;

@end