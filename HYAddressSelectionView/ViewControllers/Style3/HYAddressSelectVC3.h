//
//  HYAddressSelectVC3.h
//  TestAPP2
//
//  Created by xiehy on 2021/2/8.
//

#import "HYPopupVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSelectVC3 : HYPopupVC

@property (nonatomic, copy) NSString *selectedAddress;
@property (nonatomic, copy) void (^selectedFinish)(NSString *address);

@end

NS_ASSUME_NONNULL_END
