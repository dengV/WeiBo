//
//  RootViewController.h
//  WeiBo
//
//  Created by Hack on 15-5-6.
//  Copyright (c) 2015年 SunHaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController<UINavigationControllerDelegate>
{
    UIView *_tabbarView;
    
    UIImageView *_sliderView;
    
    UIImageView *_badgeView;
}


- (void)hiddenBadgeView;

- (void)showTabbar:(BOOL)show;

@end
