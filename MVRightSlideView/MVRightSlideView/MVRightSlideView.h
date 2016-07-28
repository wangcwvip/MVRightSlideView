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

@property (nonatomic, readonly, assign) BOOL isShowing;
@property (nonatomic, readonly, strong) UIView *rightView;

@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *rightMaskColor;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL hideWhenTap;
@property (nonatomic, assign) CGRect hotArea;
@property (nonatomic, assign) CGFloat widthForSlideBack;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, weak) id <MVRightSlideViewDelegate> delegate;

- (instancetype)initWithRootView:(UIView *)rootView rightViewTop:(CGFloat)rightViewTop rightViewSize:(CGSize)rightViewSize;

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;

@end


@protocol MVRightSlideViewDelegate <NSObject>

@optional

- (void)willShowRightSlideView:(MVRightSlideView *)rightSlideView;
- (void)didShowRightSlideView:(MVRightSlideView *)rightSlideView;

- (void)willHideRightSlideView:(MVRightSlideView *)rightSlideView;
- (void)didHideRightSlideView:(MVRightSlideView *)rightSlideView;

@end