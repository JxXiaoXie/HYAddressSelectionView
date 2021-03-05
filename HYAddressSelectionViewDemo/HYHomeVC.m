//
//  HYHomeVC.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/4.
//

#import "HYHomeVC.h"
#import "HYAddressSelectVC1.h"
#import "HYAddressSelectVC2.h"
#import "HYAddressSelectVC3.h"

@implementation HYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
}

- (IBAction)clickBtn1:(id)sender {
    HYAddressSelectVC1 *vc = [[HYAddressSelectVC1 alloc] init];
    vc.selectedAddress = self.label1.text;
    vc.hotCityInfo = @{
        @"北京市": @"北京",
        @"上海市": @"上海",
        @"广州市": @"广东 广州市",
        @"深圳市": @"广东 深圳市",
        @"重庆市": @"重庆"
    };
    [vc showFromVC:self];
    __weak __typeof(self) weakSelf = self;
    vc.selectedFinish = ^(NSString * _Nonnull address) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.label1.text = address;
    };
}

- (IBAction)clickBtn2:(id)sender {
    HYAddressSelectVC2 *vc = [[HYAddressSelectVC2 alloc] init];
    vc.selectedAddress = self.label2.text;
    vc.hotCityInfo = @{
        @"北京市": @"北京",
        @"上海市": @"上海",
        @"广州市": @"广东 广州市",
        @"深圳市": @"广东 深圳市",
        @"重庆市": @"重庆"
    };
    [vc showFromVC:self];
    __weak __typeof(self) weakSelf = self;
    vc.selectedFinish = ^(NSString * _Nonnull address) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.label2.text = address;
    };
}

- (IBAction)clickBtn3:(id)sender {
    HYAddressSelectVC3 *vc = [[HYAddressSelectVC3 alloc] init];
    vc.selectedAddress = self.label3.text;
    [vc showFromVC:self];
    __weak __typeof(self) weakSelf = self;
    vc.selectedFinish = ^(NSString * _Nonnull address) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.label3.text = address;
    };
}

@end
