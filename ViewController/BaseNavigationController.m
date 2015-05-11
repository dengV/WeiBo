//
//  BaseNavigationController.m
//  WeiBo
//
//  Created by Hack on 15-5-6.
//  Copyright (c) 2015年 SunHaoRan. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initNavTitle:(NSString *)leftTItle rightTitle:(NSString *)rightTitle
{
    //创建导航栏右侧的按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:leftTItle
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self//方法在本类里
                                                             action:@selector(switchToVC2:)];
    
    self.navigationItem.leftBarButtonItem = leftBar;
    //创建导航栏右侧的按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:rightTitle
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self//方法在本类里
                                                             action:@selector(switchToVC2:)];
    
    self.navigationItem.rightBarButtonItem = rightBar;

}


- (void)switchToVC2:(id)sender//跳转到第二个视图
{
    
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
