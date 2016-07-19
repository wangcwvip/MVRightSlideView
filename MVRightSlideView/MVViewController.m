//
//  MVViewController.m
//  MVRightSlideView
//
//  Created by wangcw on 16/6/21.
//  Copyright © 2016年 guosen. All rights reserved.
//

#import "MVViewController.h"
#import "MVRightSlideView.h"
#import "AppDelegate.h"

@interface MVViewController ()

@property (nonatomic, strong) MVRightSlideView *rightSlideView;

@end

@implementation MVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *rootView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:rootView];
    
    UIButton *bbt = [[UIButton alloc] initWithFrame:CGRectMake(320.f, 200.f, 100.f, 100.f)];
    [bbt setTitle:@"ffkk" forState:UIControlStateNormal];
    [bbt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bbt addTarget:self action:@selector(ffkkAction) forControlEvents:UIControlEventTouchUpInside];
    bbt.backgroundColor = [UIColor redColor];
    [rootView addSubview:bbt];
    
    CGFloat top = 64.f + 20.f;
    CGSize size =  CGSizeMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - 84.f * 2) ;
    
    _rightSlideView = [[MVRightSlideView alloc] initWithRootView:nil rightViewTop:top rightViewSize:size];
//    _rightSlideView.hotArea = CGRectMake(CGRectGetWidth(self.view.frame) - 88.f, 84.f, 88.f, CGRectGetHeight(self.view.frame) - 104.f);
//    _rightSlideView.gestureEnabled = YES;
//    _rightSlideView.gestureDetectTop = top;
//    _rightSlideView.gestureDetectSize = CGSizeMake(20.f, size.height);
    
    UIView *rightView = [[UIView alloc] initWithFrame:_rightSlideView.rightView.bounds];
    rightView.backgroundColor = [UIColor redColor];
    [_rightSlideView.rightView addSubview:rightView];
}

- (void)ffkkAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ok" message:@"sure" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
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
