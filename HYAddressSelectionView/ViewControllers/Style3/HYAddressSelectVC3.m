//
//  HYAddressSelectVC3.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/8.
//

#import "HYAddressSelectVC3.h"
#import <objc/runtime.h>

@interface HYAddressSelectVC3 ()<
UIPickerViewDataSource,
UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView1;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView2;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView3;

@property (nonatomic, strong) NSDictionary *chinaData;
@property (nonatomic, strong) NSMutableArray *currentProvinceArr;
@property (nonatomic, strong) NSMutableArray *currentCityArr;
@property (nonatomic, strong) NSMutableArray *currentAreaArr;

@property (nonatomic, copy) NSString *selectedProvince;
@property (nonatomic, copy) NSString *selectedCity;
@property (nonatomic, copy) NSString *selectedArea;

@end

@implementation HYAddressSelectVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentProvinceArr = [NSMutableArray arrayWithCapacity:32];
    self.currentCityArr = [NSMutableArray arrayWithCapacity:20];
    self.currentAreaArr = [NSMutableArray arrayWithCapacity:20];
    
    self.selectedAddress = [self.selectedAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.selectedAddress.length > 0) {
        NSArray *arr = [self.selectedAddress componentsSeparatedByString:@" "];
        
        self.selectedProvince = arr[0];
        self.selectedCity = arr[1];
        self.selectedArea = arr[2];
        
        NSArray *provinceArr = self.chinaData.allKeys;
        NSArray *cityArr = ((NSDictionary *)self.chinaData[self.selectedProvince]).allKeys;
        NSArray *areaArr = ((NSDictionary *)self.chinaData[self.selectedProvince])[self.selectedCity];
        
        [self.currentProvinceArr addObjectsFromArray:provinceArr];
        [self.currentCityArr addObjectsFromArray:cityArr];
        [self.currentAreaArr addObjectsFromArray:areaArr];
        
        [self.pickerView1 reloadComponent:0];
        [self.pickerView2 reloadComponent:0];
        [self.pickerView3 reloadComponent:0];
        
        NSInteger provinceIdx = [provinceArr indexOfObject:self.selectedProvince];
        NSInteger cityIdx = [cityArr indexOfObject:self.selectedCity];
        NSInteger areaIdx = [areaArr indexOfObject:self.selectedArea];
        [self.pickerView1 selectRow:provinceIdx inComponent:0 animated:YES];
        [self.pickerView2 selectRow:cityIdx inComponent:0 animated:YES];
        [self.pickerView3 selectRow:areaIdx inComponent:0 animated:YES];
    }else {
        [self.currentProvinceArr addObjectsFromArray:self.chinaData.allKeys];
        [self pickerView:self.pickerView1 didSelectRow:0 inComponent:0];
        [self pickerView:self.pickerView2 didSelectRow:0 inComponent:0];
        [self pickerView:self.pickerView3 didSelectRow:0 inComponent:0];
    }
}

- (IBAction)clickSureBtn {
    if (self.selectedFinish) {
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@", self.selectedProvince, self.selectedCity, self.selectedArea];
        self.selectedFinish(address);
    }
    [self hide];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 修改选中条样式
    NSArray *pickerViewArr = @[self.pickerView1, self.pickerView2, self.pickerView3];
    for (UIPickerView *pickerView in pickerViewArr) {
        NSArray *subviews = pickerView.subviews;
        if (subviews.count > 0) {
            UIView *view2 = subviews.lastObject;
            view2.backgroundColor = [UIColor yellowColor];
            view2.alpha = 0.2;
            view2.layer.masksToBounds = NO;
            view2.layer.cornerRadius = 0;
            view2.frame = CGRectMake(0, view2.frame.origin.y, view2.frame.size.width + view2.frame.origin.x * 2, view2.frame.size.height);
        }
    }
}

#pragma mark - Getter / Setter
- (NSDictionary *)chinaData {
    if (!_chinaData) {
        NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"China" ofType:@"plist"];
        _chinaData = [[NSDictionary dictionaryWithContentsOfFile:plistFilePath] objectForKey:@"中国"];
    }
    return _chinaData;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
            return self.currentProvinceArr.count;
        case 2:
            return self.currentCityArr.count;
        case 3:
            return self.currentAreaArr.count;
        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
    }

    switch (pickerView.tag) {
        case 1:
            label.text = self.currentProvinceArr[row];
            break;
        case 2:
            label.text = self.currentCityArr[row];
            break;
        case 3:
            label.text = self.currentAreaArr[row];
            break;
        default:
            break;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1: {
            self.selectedProvince = self.currentProvinceArr[row];
            
            NSInteger oldSelectedCityAtIdx = [self.pickerView2 selectedRowInComponent:0];
            NSInteger oldSelectedAreaAtIdx = [self.pickerView3 selectedRowInComponent:0];
            
            NSDictionary *cityInfo = self.chinaData[self.selectedProvince];
            NSArray *cityArr = cityInfo.allKeys;
            if (oldSelectedCityAtIdx >= cityArr.count) {
                oldSelectedCityAtIdx = cityArr.count - 1;
            }
            NSArray *areaArr = cityInfo[cityArr[oldSelectedCityAtIdx]];
            if (oldSelectedAreaAtIdx >= areaArr.count) {
                oldSelectedAreaAtIdx = areaArr.count - 1;
            }
            
            [self.currentCityArr removeAllObjects];
            [self.currentCityArr addObjectsFromArray:cityArr];
            
            [self.currentAreaArr removeAllObjects];
            [self.currentAreaArr addObjectsFromArray:areaArr];
            
            [self.pickerView2 reloadComponent:0];
            [self.pickerView3 reloadComponent:0];
            
            self.selectedCity = self.currentCityArr[oldSelectedCityAtIdx];
            self.selectedArea = self.currentAreaArr[oldSelectedAreaAtIdx];
            break;
        }
        case 2: {
            self.selectedCity = self.currentCityArr[row];
            
            NSDictionary *cityInfo = self.chinaData[self.selectedProvince];
            NSArray *areaArr = cityInfo[self.selectedCity];
            
            [self.currentAreaArr removeAllObjects];
            [self.currentAreaArr addObjectsFromArray:areaArr];
            
            [self.pickerView3 reloadComponent:0];
            
            NSInteger oldSelectedAreaAtIdx = [self.pickerView3 selectedRowInComponent:0];
            if (oldSelectedAreaAtIdx >= self.currentAreaArr.count) {
                oldSelectedAreaAtIdx = self.currentAreaArr.count - 1;
            }
            self.selectedArea = self.currentAreaArr[oldSelectedAreaAtIdx];
            break;
        }
        case 3: {
            self.selectedArea = self.currentAreaArr[row];
            break;
        }
        default:
            break;
    }
}

@end
