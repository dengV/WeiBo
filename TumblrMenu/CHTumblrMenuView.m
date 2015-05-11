//
//  CHTumblrMenuView.m
//  TumblrMenu
//
//  Created by HangChen on 12/9/13.
//  Copyright (c) 2013 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "CHTumblrMenuView.h"
#import <AudioToolbox/AudioToolbox.h>
#define CHTumblrMenuViewTag 1999
#define CHTumblrMenuViewImageHeight 71
#define CHTumblrMenuViewTitleHeight 20
#define CHTumblrMenuViewVerticalPadding 10
#define CHTumblrMenuViewHorizontalMargin 20
#define CHTumblrMenuViewRriseAnimationID @"CHTumblrMenuViewRriseAnimationID"
#define CHTumblrMenuViewDismissAnimationID @"CHTumblrMenuViewDismissAnimationID"
#define CHTumblrMenuViewAnimationTime 0.36
#define CHTumblrMenuViewAnimationInterval (CHTumblrMenuViewAnimationTime / 5)


@interface CHTumblrMenuItemButton : UIControl
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block;
@property(nonatomic,copy)CHTumblrMenuViewSelectedBlock selectedBlock;
@end

@implementation CHTumblrMenuItemButton
{
    UIImageView *iconView_;
    UILabel *titleLabel_;
    
}

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block
{
    self = [super init];
    if (self) {
        iconView_ = [UIImageView new];
        iconView_.image = icon;
        titleLabel_ = [UILabel new];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor blackColor];
        titleLabel_.text = title;
        titleLabel_.font = [UIFont systemFontOfSize:14.0f];
        _selectedBlock = block;
        [self addSubview:iconView_];
        [self addSubview:titleLabel_];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    iconView_.frame = CGRectMake(0, 0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight);
    titleLabel_.frame = CGRectMake(0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight, CHTumblrMenuViewTitleHeight);
}


@end

@implementation CHTumblrMenuView
{
    UIImageView *backgroundView_;
    NSMutableArray *buttons_;
    
    //ToolBar底部按钮
    UIButton *_addBut;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
        self.backgroundColor = [UIColor clearColor];
        backgroundView_ = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView_.image = [[UIImage imageNamed:@"tabbar_compose_below_background@2x.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:6];
        backgroundView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView_];
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];
        
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_background@2x.png"]];
        [imageView setFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        [self addSubview:imageView];
        
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add@2x.png"] forState:UIControlStateNormal];
        [_addBut setFrame:CGRectMake((imageView.width - 24) / 2, (imageView.height - 24) / 2, 24, 24)];
        [imageView addSubview:_addBut];
        
    }
    return self;
}

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block
{
    CHTumblrMenuItemButton *button = [[CHTumblrMenuItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [buttons_ addObject:button];
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index
{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;

    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;

    CGFloat itemHeight = (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * CHTumblrMenuViewHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - CHTumblrMenuViewHorizontalMargin * 2 - CHTumblrMenuViewImageHeight * 3) / 2.0;
    
    CGFloat offsetX = CHTumblrMenuViewHorizontalMargin;
    offsetX += (CHTumblrMenuViewImageHeight+ verticalPadding) * columnIndex;
    
    offsetY += (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight + CHTumblrMenuViewVerticalPadding) * rowIndex;

    
    return CGRectMake(offsetX, offsetY, CHTumblrMenuViewImageHeight, (CHTumblrMenuViewImageHeight+CHTumblrMenuViewTitleHeight));

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        CHTumblrMenuItemButton *button = buttons_[i];
        button.frame = [self frameForButtonAtIndex:i];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[CHTumblrMenuItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in buttons_) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)dismiss:(id)sender
{
    [self dropAnimation];
    double delayInSeconds = CHTumblrMenuViewAnimationTime  + CHTumblrMenuViewAnimationInterval * (buttons_.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperview];
    });
}


- (void)buttonTapped:(CHTumblrMenuItemButton*)btn
{
    [self dismiss:nil];
    double delayInSeconds = CHTumblrMenuViewAnimationTime  + CHTumblrMenuViewAnimationInterval * (buttons_.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        btn.selectedBlock();
    });
}

- (void)riseAnimation
{
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);


    for (NSUInteger index = 0; index < buttons_.count; index++) {
        CHTumblrMenuItemButton *button = buttons_[index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        
        if (columnIndex == 1) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.3;
        }
        else if(columnIndex == 2) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.6;
        }

        CABasicAnimation *positionAnimation;
        
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewRriseAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.duration = 0.2;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];
        
#pragma mark 系统提供的声音及振动服务
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"composer_open" ofType:@"wav"];
//        NSURL *url = [NSURL fileURLWithPath:filePath];
//        SystemSoundID soundId;
//        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
//        AudioServicesPlayAlertSound(soundId);
    }
}

- (void)dropAnimation
{
    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    
    for (int index = buttons_.count-1; index >= 0; index--) {
        CHTumblrMenuItemButton *button = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = (buttons_.count - 1 - index) / columnCount;
        NSUInteger columnIndex = index % columnCount;

        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        if (columnIndex == 1) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval*0.3;
        }
        else if(columnIndex == 0) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 0.6;
        }
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewDismissAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
        
        
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D fromValue = _addBut.layer.transform;
        // 设置动画开始的属性值
        anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
        // 绕Z轴旋转180度
        CATransform3D toValue = CATransform3DRotate(fromValue, - M_PI_4 / 6, 0 , 0 , 1);
        // 设置动画结束的属性值
        anim.toValue = [NSValue valueWithCATransform3D:toValue];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.duration = 0.2;
        _addBut.layer.transform = toValue;
        anim.removedOnCompletion = YES;
        [_addBut.layer addAnimation:anim forKey:nil];
        
#pragma mark 系统提供的声音及振动服务
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"composer_close" ofType:@"wav"];
//        NSURL *url = [NSURL fileURLWithPath:filePath];
//        SystemSoundID soundId;
//        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
//        AudioServicesPlayAlertSound(soundId);
        
    }

}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSUInteger columnCount = 3;
    if([anim valueForKey:CHTumblrMenuViewRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
//        [_addBut setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close@2x.png"] forState:UIControlStateNormal];
    }
    else if([anim valueForKey:CHTumblrMenuViewDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;

        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
    
}


- (void)show
{
    
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
   
        
    appRootViewController = window.rootViewController;
    
 
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:CHTumblrMenuViewTag]) {
        [[topViewController.view viewWithTag:CHTumblrMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    
    [self riseAnimation];
}


@end
