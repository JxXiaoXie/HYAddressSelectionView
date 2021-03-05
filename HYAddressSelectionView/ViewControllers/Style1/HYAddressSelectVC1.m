//
//  HYAddressSelectVC1.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/4.
//

#import "HYAddressSelectVC1.h"

#import "HYAddressSelectView.h"

@interface HYAddressSelectVC1 ()<
UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *selectedInfoView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraint_selectedInfoView_height;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *addressSelectViewArr;
@property (nonatomic, strong) NSMutableArray *addressLabelArr;
@property (nonatomic, strong) NSDictionary *chinaData;

@end

@implementation HYAddressSelectVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressLabelArr = [NSMutableArray arrayWithCapacity:4];
    self.addressSelectViewArr = [NSMutableArray arrayWithCapacity:4];
    self.constraint_selectedInfoView_height.constant = 0;
    
    self.selectedAddress = [self.selectedAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.selectedAddress.length > 0) {
        self.selectedInfoView.hidden = NO;
        self.constraint_selectedInfoView_height.constant = 44;
        
        NSArray *arr = [self.selectedAddress componentsSeparatedByString:@" "];
        for (NSInteger i = 1; i <= arr.count; i++) {
            NSString *str = arr[i - 1];
            [self createLabel:str tag:i];
            
            HYAddressSelectView *view = [self getAddressSelectView:i];
            view.selectedStr = str;
            view.strArr = [self getDataArr:i];
            if (i == 1) {
                view.hotCityArr = self.hotCityInfo.allKeys;
            }
        }
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame), 0) animated:NO];
    }else {
        HYAddressSelectView *view = [self getAddressSelectView:1];
        view.strArr = self.chinaData.allKeys;
        view.hotCityArr = self.hotCityInfo.allKeys;
    }
}

/// 获取省市区数据
/// @param tag (1:省 2:市 3:区 4:镇)
- (NSArray *)getDataArr:(NSInteger) tag {
    NSArray *dataArr = @[];
    switch (tag) {
        case 1: {
            dataArr = self.chinaData.allKeys;
            break;
        }
        case 2: {
            UILabel *label = self.addressLabelArr[0];
            NSString *selectedProvince = label.text;
            
            NSDictionary *cityInfo = [self.chinaData objectForKey:selectedProvince];
            dataArr = cityInfo.allKeys;
            break;
        }
        case 3: {
            UILabel *label0 = self.addressLabelArr[0];
            UILabel *label1 = self.addressLabelArr[1];
            NSString *selectedProvince = label0.text;
            NSString *selectedCity = label1.text;
            
            NSDictionary *cityInfo = [self.chinaData objectForKey:selectedProvince];
            dataArr = cityInfo[selectedCity];
            break;
        }
        default:
            break;
    }
    return dataArr;
}

/// 创建AddressSelectView
/// @param tag 标识（1:省 2:市 3:区 4:镇）
- (HYAddressSelectView *)getAddressSelectView:(NSInteger) tag {
    HYAddressSelectView *addressSelectView = tag <= self.addressSelectViewArr.count ? self.addressSelectViewArr[tag - 1] : nil;
    if (addressSelectView) {
        return addressSelectView;
    }
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    self.scrollView.contentSize = CGSizeMake(width * tag, height);
    
    addressSelectView = [[HYAddressSelectView alloc] initWithFrame:CGRectMake(width * (tag - 1), 0, width, height)];
    [self.scrollView addSubview:addressSelectView];
    
    __weak __typeof(self) weakSelf = self;
    addressSelectView.selectedItem = ^(NSString * _Nonnull item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf selectedItem:item tag:tag];
    };
    addressSelectView.selectedHotItem = ^(NSString * _Nonnull item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf selectedHotItem:item tag:tag];
        
    };
    [self.addressSelectViewArr addObject:addressSelectView];
    
    return addressSelectView;
}

/// 创建省市区镇标签
- (UILabel *)createLabel:(NSString *) labelText tag:(NSInteger) tag {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.text = labelText;
    label.textColor = [UIColor blackColor];
    label.tag = tag;
    [self.selectedInfoView addSubview:label];
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddressLabel:)];
    [label addGestureRecognizer:tapGest];
    
    CGFloat width = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    CGFloat height = self.constraint_selectedInfoView_height.constant;
    UILabel *lastLabel = self.addressLabelArr.lastObject;
    if (lastLabel) {
        for (UILabel *leftLabel in self.addressLabelArr) {
            [leftLabel sizeToFit];
            leftLabel.frame = CGRectMake(leftLabel.frame.origin.x, 0, leftLabel.frame.size.width, height);
        }
        
        [self.selectedInfoView bringSubviewToFront:label];
        label.frame = CGRectMake(CGRectGetMinX(lastLabel.frame), 0, width, height);
        [UIView animateWithDuration:0.25 animations:^{
            label.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame) + 10, 0, width, height);
        }];
    }else {
        label.frame = CGRectMake(0, 0, width, height);
    }
    [self.addressLabelArr addObject:label];
    
    return label;
}

- (void)clickAddressLabel:(UIGestureRecognizer *) gest {
    NSInteger viewTag = gest.view.tag;
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * (viewTag - 1), 0) animated:YES];
}

- (void)selectedItem:(NSString *) item tag:(NSInteger) tag {
    if (tag == 1 && self.selectedInfoView.hidden) {
        // 显示选中地址展示View
        self.selectedInfoView.hidden = NO;
        self.constraint_selectedInfoView_height.constant = 44;
        [self createLabel:@"请选择" tag:1];
    }
    
    if (self.addressLabelArr.count > tag) {
        for (NSInteger i = tag; i < self.addressLabelArr.count; i++) {
            UILabel *label = self.addressLabelArr[i];
            [label removeFromSuperview];
        }
        [self.addressLabelArr removeObjectsInRange:NSMakeRange(tag, self.addressLabelArr.count - tag)];
    }
    
    UILabel *label = self.addressLabelArr.lastObject;
    label.text = item;
    
    NSArray *strArr = [self getDataArr:tag + 1];
    if (strArr.count <= 0) {
        [self sureSelect];
        return;
    }
    
    HYAddressSelectView *addressSelectView = [self getAddressSelectView:tag + 1];
    addressSelectView.strArr = strArr;
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    [self.scrollView setContentOffset:CGPointMake(width * tag, 0) animated:YES];
    
    [self createLabel:@"请选择" tag:tag + 1];
}

- (void)selectedHotItem:(NSString *) item tag:(NSInteger) tag {
    NSString *address = self.hotCityInfo[item];
    NSArray *arr = [address componentsSeparatedByString:@" "];
    for (NSInteger i = 1; i <= arr.count; i++) {
        NSString *str = arr[i - 1];
        [self selectedItem:str tag:i];
    }
}

- (void)sureSelect {
    if (self.selectedFinish) {
        NSMutableString *str = [NSMutableString string];
        for (UILabel *label in self.addressLabelArr) {
            [str appendFormat:@"%@ ", label.text];
        }
        self.selectedFinish(str);
    }
    
    [self hide];
}

#pragma mark - Getter / Setter
- (NSDictionary *)chinaData {
    if (!_chinaData) {
        NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"China" ofType:@"plist"];
        _chinaData = [[NSDictionary dictionaryWithContentsOfFile:plistFilePath] objectForKey:@"中国"];
    }
    return _chinaData;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = round(x / CGRectGetWidth(scrollView.bounds));
    if (index < 0 || index >= self.addressLabelArr.count) {
        return;
    }
    
    for (NSInteger i = 0; i < self.addressLabelArr.count; i++) {
        UILabel *label = self.addressLabelArr[i];
        if (i == index) {
            label.textColor = [UIColor redColor];
        }else {
            label.textColor = [UIColor blackColor];
        }
    }
}

@end
