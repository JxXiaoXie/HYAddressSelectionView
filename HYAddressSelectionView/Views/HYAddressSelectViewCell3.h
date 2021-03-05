//
//  HYAddressSelectViewCell3.h
//  TestAPP2
//
//  Created by xiehy on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSelectViewCell3 : UITableViewCell

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIColor *dataBgColor;
@property (nonatomic, copy) void (^selectedItem)(NSString *item);

@end

NS_ASSUME_NONNULL_END
