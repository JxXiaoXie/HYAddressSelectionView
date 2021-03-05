//
//  HYAddressSelectVC2.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/7.
//

#import "HYAddressSelectVC2.h"

#import "HYAddressSelectVC2Cell.h"
#import "HYAddressSelectView.h"

@interface HYAddressSelectVC2 ()<
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *selectedInfoView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraint_selectedInfoView_height;
@property (nonatomic, weak) IBOutlet UIView *separatorView;
@property (nonatomic, weak) IBOutlet HYAddressSelectView *addressSelectView;

@property (nonatomic, strong) NSDictionary *chinaData;
@property (nonatomic, strong) NSMutableArray *selectedItemArr;

@property (nonatomic, assign) NSInteger currentSelectType;

@end

@implementation HYAddressSelectVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedItemArr = [NSMutableArray arrayWithCapacity:4];
    
    [self.selectedInfoView registerNib:[UINib nibWithNibName:@"HYAddressSelectVC2Cell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier_HYAddressSelectVC2Cell"];
    
    self.selectedAddress = [self.selectedAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.selectedAddress.length > 0) {
        // 显示选中地址展示View
        [self.selectedItemArr addObjectsFromArray:[self.selectedAddress componentsSeparatedByString:@" "]];
        [self reloadTableView];
        
        self.addressSelectView.selectedStr = self.selectedItemArr.lastObject;
        self.addressSelectView.strArr = [self getDataArr:self.selectedItemArr.count];
        
        [self showSelectedInfoView];
        self.currentSelectType = self.selectedItemArr.count;
    }else {
        self.addressSelectView.strArr = [self getDataArr:1];
        
        self.constraint_selectedInfoView_height.constant = 0;
        self.currentSelectType = 1;
    }
    
    __weak __typeof(self) weakSelf = self;
    self.addressSelectView.selectedItem = ^(NSString * _Nonnull item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf selectedItem:item];
    };
    self.addressSelectView.selectedHotItem = ^(NSString * _Nonnull item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf selectedHotItem:item];
    };
}

- (void)selectedItem:(NSString *) item {
    [self showSelectedInfoView];
    
    if (self.selectedItemArr.count > self.currentSelectType) {
        [self.selectedItemArr removeObjectsInRange:NSMakeRange(self.currentSelectType, self.selectedItemArr.count - self.currentSelectType)];
    }
    if (self.selectedItemArr.count >= self.currentSelectType) {
        [self.selectedItemArr replaceObjectAtIndex:self.selectedItemArr.count - 1 withObject:item];
    }else {
        [self.selectedItemArr addObject:item];
    }
    
    self.currentSelectType = self.currentSelectType + 1;
    NSArray *strArr = [self getDataArr:self.currentSelectType];
    if (strArr.count <= 0) {
        [self sureSelect];
        return;
    }
    self.addressSelectView.strArr = strArr;
    
    [self.selectedItemArr addObject:@"请选择"];
    [self reloadTableView];
}

// 显示选中地址展示View
- (void)showSelectedInfoView {
    if (self.selectedInfoView.hidden) {
        self.selectedInfoView.hidden = NO;
        self.separatorView.hidden = NO;
    }
}

- (void)reloadTableView {
    self.constraint_selectedInfoView_height.constant = self.selectedItemArr.count * 40;
    [self.selectedInfoView reloadData];
}

- (void)selectedHotItem:(NSString *) item {
    NSString *address = self.hotCityInfo[item];
    [self.selectedItemArr removeAllObjects];
    [self.selectedItemArr addObjectsFromArray:[address componentsSeparatedByString:@" "]];
    
    self.currentSelectType = self.selectedItemArr.count;
    [self selectedItem:self.selectedItemArr.lastObject];
}

- (void)sureSelect {
    if (self.selectedFinish) {
        NSString *address = [self.selectedItemArr componentsJoinedByString:@" "];
        self.selectedFinish(address);
    }
    
    [self hide];
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
            NSString *selectedProvince = self.selectedItemArr[0];
            
            NSDictionary *cityInfo = [self.chinaData objectForKey:selectedProvince];
            dataArr = cityInfo.allKeys;
            break;
        }
        case 3: {
            NSString *selectedProvince = self.selectedItemArr[0];
            NSString *selectedCity = self.selectedItemArr[1];
            
            NSDictionary *cityInfo = [self.chinaData objectForKey:selectedProvince];
            dataArr = cityInfo[selectedCity];
            break;
        }
        default:
            break;
    }
    return dataArr;
}

#pragma mark - Getter / Setter
- (NSDictionary *)chinaData {
    if (!_chinaData) {
        NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"China" ofType:@"plist"];
        _chinaData = [[NSDictionary dictionaryWithContentsOfFile:plistFilePath] objectForKey:@"中国"];
    }
    return _chinaData;
}

- (void)setCurrentSelectType:(NSInteger)currentSelectType {
    _currentSelectType = currentSelectType;
    
    if (self.currentSelectType == 1) {
        self.addressSelectView.hotCityBgColor = [UIColor colorWithRed:229 / 255.f green:229 / 255.f blue:229/ 255.f alpha:1];
        self.addressSelectView.hotCityArr = self.hotCityInfo.allKeys;
    }else {
        self.addressSelectView.hotCityArr = @[];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedItemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.selectedItemArr[indexPath.row];
    HYAddressSelectVC2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier_HYAddressSelectVC2Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES;
    }else if (indexPath.row == self.selectedItemArr.count - 1) {
        cell.bottomLineView.hidden = YES;
    }else {
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = NO;
    }
    if ([str isEqualToString:@"请选择"]) {
        cell.dotView.backgroundColor = [UIColor whiteColor];
        cell.dotView.layer.borderColor = [UIColor redColor].CGColor;
    }else {
        cell.dotView.backgroundColor = [UIColor redColor];
        cell.dotView.layer.borderColor = [UIColor redColor].CGColor;
    }
    if (indexPath.row == self.currentSelectType - 1) {
        cell.label.textColor = [UIColor redColor];
    }else {
        cell.label.textColor = [UIColor blackColor];
    }
    cell.label.text = str;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectType = indexPath.row + 1;
    [tableView reloadData];
    self.addressSelectView.selectedStr = self.selectedItemArr[indexPath.row];
    self.addressSelectView.strArr = [self getDataArr:self.currentSelectType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
