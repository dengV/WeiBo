//
//  RootViewController.m
//  WeiBo
//
//  Created by Hack on 15-5-6.
//  Copyright (c) 2015年 SunHaoRan. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

/**
 初始化子视图控制器
 */
-(void)_initSubViewController;
/**
 自定义Tabbar视图
 */
-(void)_initTabbarView;



@end

@implementation RootViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (CurrentVersion() >=7.0) {
             [self.tabBar setHidden:YES];
        }else
        {
            [self hideTabBar:YES];
        }
    }
    return  self;
}


//IOS6下隐藏TabBar
- (void) hideTabBar:(BOOL) hidden{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight - 47, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenHeight)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenHeight - 47)];
            }
        }
    }
    [UIView commitAnimations];
}


#pragma mark - Private Methods
/**
 初始化子视图控制器
 */
-(void)_initSubViewController
{
    HomeViewController *home = [[HomeViewController alloc] init] ;
    MessageViewController *message = [[MessageViewController alloc] init];
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    
    NSArray *views = @[home,message,compose,discover,profile];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        
       
        navigation.delegate = self;
        [viewControllers addObject:navigation];
        
    }
    self.viewControllers = viewControllers;
}

/**
 自定义Tabbar视图
 */
-(void)_initTabbarView
{
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    [self.view addSubview:_tabbarView];
    
    
    UIImageView *tabbarImageView = [UIFactory createImageView:@"tabbar_background@2x.png"];
    
    tabbarImageView.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarImageView];
    
    
    NSArray *background = @[@"tabbar_home@2x.png",@"tabbar_message_center@2x.png",@"tabbar_compose_icon_add_highlighted@2x.png",@"tabbar_discover@2x.png",@"tabbar_profile@2x.png"];
    
    NSArray *highlight = @[@"tabbar_home_highlighted@2x.png",@"tabbar_message_center_highlighted@2x.png",@"tabbar_compose_background_icon_add@2x.png",@"tabbar_discover_highlighted@2x.png",@"tabbar_profile_highlighted@2x.png"];
    NSArray *titleArry = @[@"首页",@"消息",@"",@"发现",@"我"];
//    NSArray *selected = @[@"tabbar_home_selected",@"tabbar_message_center_selected",@"",@"tabbar_discover_selected",@"tabbar_profile_selected"];
    
    for (NSInteger i = 0; i < background.count; i++) {
        NSString *backgroundName = [background objectAtIndex:i];
        NSString *highlightName = [highlight objectAtIndex:i];
        UILabel *lab =[[UILabel alloc]init];
        
        lab.text = [titleArry objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:10.0];
        lab.textColor = [UIColor grayColor];
        UIButton *button = [UIFactory createButton:backgroundName highlight:highlightName];
        button.tag = i;
        if (i == 2) {
            button.frame = CGRectMake((64-30)/2+i*64, (34-30)/2, 30, 30);
            lab.frame = CGRectMake((64-30)/2+i*64, (64-25)/2, 30, 30);
        }
        else
        {
            button.frame = CGRectMake((64-30)/2+i*64, (34-30)/2, 30, 30);
            lab.frame = CGRectMake((64-30)/2+i*64, (64-25)/2, 30, 30);

        }
        
        [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:lab];
        [_tabbarView addSubview:button];
    }
    
    _sliderView = [UIFactory createImageView:@"tabbar_slider@2x.png"];
    [_sliderView setBackgroundColor:[UIColor clearColor]];
    [_sliderView setFrame:CGRectMake(0, 0, 64, 44)];
    [_tabbarView addSubview:_sliderView];
}


-(void)selectTab:(UIButton *)button
{
    if (button.tag != 2)
    {
        [UIView animateWithDuration:0.2 animations:^{
            //            CGRect frame = self.sliderView.frame;
            //            frame.origin.x = button.frame.origin.x;
            //            self.sliderView.frame = frame;
            _sliderView.center = button.center;
        }];
        
        if (button.tag == self.selectedIndex && button.tag == 0) {
            UINavigationController *homeNav = [self.viewControllers firstObject];
            HomeViewController *homeCtrl = [homeNav.viewControllers firstObject];
//            [homeCtrl refreshLoading];
        }
        
        self.selectedIndex = button.tag;
    }else
    {
        //        NSArray *viewController = self.viewControllers;
        //        __block UINavigationController *nav = [viewController objectAtIndex:1];
        
        CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
        [menuView addMenuItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"tabbar_compose_idea"] andSelectedBlock:^{
            
            SendViewController *sendView = [[SendViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendView];
            
            RootViewController * rootView = (RootViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
            [rootView presentViewController:nav animated:YES completion:^{
                
            }];
            
        }];
        [menuView addMenuItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"tabbar_compose_photo"] andSelectedBlock:^{
            NSLog(@"Photo selected");
        }];
        [menuView addMenuItemWithTitle:@"拍摄" andIcon:[UIImage imageNamed:@"tabbar_compose_camera"] andSelectedBlock:^{
            NSLog(@"Quote selected");
            
        }];
        [menuView addMenuItemWithTitle:@"签到" andIcon:[UIImage imageNamed:@"tabbar_compose_lbs"] andSelectedBlock:^{
            NSLog(@"Link selected");
            
        }];
        [menuView addMenuItemWithTitle:@"点评" andIcon:[UIImage imageNamed:@"tabbar_compose_review"] andSelectedBlock:^{
            NSLog(@"Chat selected");
            
        }];
        [menuView addMenuItemWithTitle:@"更多" andIcon:[UIImage imageNamed:@"tabbar_compose_more"] andSelectedBlock:^{
            NSLog(@"Video selected");
            
        }];
        
        
        
        [menuView show];
    }
}
- (void)adjustView:(BOOL)showTabbar
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight;
            }
            else
            {
                subView.height = ScreenHeight - 44 - 20 - 45;
            }
        }
    }
}

#pragma mark - UINavigationDelegate Method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }
    else if (count == 1)
    {
        [self showTabbar:YES];
    }
}

#pragma mark - Custom Method

- (void)hiddenBadgeView
{
    _badgeView.hidden = YES;
}

- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^{
        if (show) {
            _tabbarView.left = 0;
        }
        else
        {
            _tabbarView.left = -ScreenWidth;
        }
    }];
    
    [self adjustView:show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initSubViewController];
    [self _initTabbarView];

    // Do any additional setup after loading the view.
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
