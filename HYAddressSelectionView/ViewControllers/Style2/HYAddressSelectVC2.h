//
//  HYAddressSelectVC2.h
//  TestAPP2
//
//  Created by xiehy on 2021/2/7.
//

#import "HYPopupVC.h"
@class HYAddressSelectView;

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSelectVC2 : HYPopupVC

@property (nonatomic, copy) NSString *selectedAddress;
@property (nonatomic, strong) NSDictionary *hotCityInfo;

@property (nonatomic, copy) void (^selectedFinish)(NSString *address);

@end

NS_ASSUME_NONNULL_END
