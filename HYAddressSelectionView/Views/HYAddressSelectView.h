//
//  HYAddressSelectView.h
//  TestAPP2
//
//  Created by xiehy on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSelectView : UIView

@property (nonatomic, strong) NSArray *strArr;
@property (nonatomic, copy) NSString *selectedStr;
@property (nonatomic, strong) NSArray *hotCityArr;
@property (nonatomic, strong) UIColor *hotCityBgColor;

@property (nonatomic, copy) void (^selectedItem)(NSString *item);
@property (nonatomic, copy) void (^selectedHotItem)(NSString *item);

@end

NS_ASSUME_NONNULL_END
