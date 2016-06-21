//
//  MVViewController.m
//  MVRightSlideView
//
//  Created by wangcw on 16/6/21.
//  Copyright © 2016年 guosen. All rights reserved.
//

#import "MVViewController.h"
#import "MVRightSlideView.h"

@interface MVViewController ()

@property (nonatomic, strong) MVRightSlideView *rightSlideView;

@end

@implementation MVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat top = 64.f + 20.f;
    CGSize size =  CGSizeMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - 84.f * 2) ;
    
    _rightSlideView = [[MVRightSlideView alloc] initWithRootView:self.view rightViewTop:top rightViewSize:size];
    _rightSlideView.animationSpeed = 0.5f;
    _rightSlideView.gestureEnabled = YES;
    
    UIView *rightView = [[UIView alloc] initWithFrame:_rightSlideView.rightView.bounds];
    rightView.backgroundColor = [UIColor redColor];
    [_rightSlideView.rightView addSubview:rightView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
