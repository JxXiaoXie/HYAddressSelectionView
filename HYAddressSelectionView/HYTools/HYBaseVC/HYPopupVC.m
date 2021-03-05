//
//  HYPopupVC.m
//  HYTools
//
//  Created by xiehy on 2021/2/5.
//

#import "HYPopupVC.h"

@interface HYPopupVC ()<
UIGestureRecognizerDelegate>

@end

@implementation HYPopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTransparentBgView:)];
    tapGest.delegate = self;
    [self.view addGestureRecognizer:tapGest];
}

- (void)clickTransparentBgView:(UIGestureRecognizer *) gesture {
    // 点击透明背景View
    CGPoint location = [gesture locationInView:self.animationContentView];
    if (!CGRectContainsPoint(self.animationContentView.bounds, location)) {
        [self hide];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    }
    return NO;
}

- (void)showFromVC:(UIViewController *)vc {
    [self showFromVC:vc bgColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
}

- (void)showFromVC:(UIViewController *)vc bgColor:(UIColor *) bgColor {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.view.backgroundColor = [UIColor clearColor];
    self.animationContentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(UIScreen.mainScreen.bounds));
    [vc presentViewController:self animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = bgColor;
            self.animationContentView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.animationContentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(UIScreen.mainScreen.bounds));
    } completion:^(BOOL finished) {
       [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
