//
//  HYAddressSelectVC1.h
//  TestAPP2
//
//  Created by xiehy on 2021/2/4.
//

#import "HYPopupVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSelectVC1 : HYPopupVC

@property (nonatomic, copy) NSString *selectedAddress;
@property (nonatomic, strong) NSDictionary *hotCityInfo;

@property (nonatomic, copy) void (^selectedFinish)(NSString *address);

@end

NS_ASSUME_NONNULL_END
