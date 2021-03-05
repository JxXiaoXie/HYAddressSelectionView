//
//  HYPopupVC.h
//  HYTools
//
//  Created by xiehy on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPopupVC : UIViewController

@property (nonatomic, weak) IBOutlet UIView *animationContentView;

- (void)showFromVC:(UIViewController *)vc;
- (void)showFromVC:(UIViewController *)vc bgColor:(UIColor *) bgColor;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
