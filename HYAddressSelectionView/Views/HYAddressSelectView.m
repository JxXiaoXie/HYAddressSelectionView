//
//  HYAddressSelectView.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/5.
//

#import "HYAddressSelectView.h"
#import "HYAddressSelectViewCell2.h"
#import "HYAddressSelectViewCell3.h"

#import "BMChineseSort.h"

@interface HYAddressSelectView ()<
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UITableView *leftTableView;
@property (nonatomic, weak) IBOutlet UITableView *rightTableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraint_rightTableView_height;

@property (nonatomic, strong) NSArray *letterArr;
@property (nonatomic, strong) NSArray *sortedStrArr;

@end

@implementation HYAddressSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createViewFromXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self createViewFromXib];
    }
    return self;
}

- (void)createViewFromXib {
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"HYAddressSelectView" owner:self options:nil];
    UIView *view = viewArr.firstObject;
    [self addSubview:view];

    view.frame = self.bounds;
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell {
    [self.leftTableView registerNib:[UINib nibWithNibName:@"HYAddressSelectViewCell2" bundle:nil] forCellReuseIdentifier:@"CellReuseIdentifier_HYAddressSelectViewCell2"];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"HYAddressSelectViewCell3" bundle:nil] forCellReuseIdentifier:@"CellReuseIdentifier_HYAddressSelectViewCell3"];
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellReuseIdentifier_UITableViewCell"];
}

#pragma mark - Getter / Setter
- (void)setStrArr:(NSArray *)strArr {
    _strArr = strArr;
    
    // 根据拼音排序字符串
    self.leftTableView.hidden = YES;
    self.rightTableView.hidden = YES;
    [self.activityIndicatorView startAnimating];
    
    [BMChineseSort sortAndGroup:_strArr key:nil finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (!isSuccess) {
            return;
        }
        
        self.leftTableView.hidden = NO;
        self.rightTableView.hidden = NO;
        [self.activityIndicatorView stopAnimating];
        
        self.letterArr = sectionTitleArr;
        self.sortedStrArr = sortedObjArr;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
        self.constraint_rightTableView_height.constant = (self.bounds.size.height / 26.f) * self.letterArr.count;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (tableView.tag) {
        case 1:
            return 1 + self.letterArr.count;
        case 2:
            return 1;
        default:
            return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 1: {
            if (section == 0) {
                return self.hotCityArr.count > 0 ? 1 : 0;
            }
            
            NSArray *arr = self.sortedStrArr[section - 1];
            return arr.count;
        }
        case 2: {
            return self.letterArr.count;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 1: {
            if (indexPath.section == 0) {
                HYAddressSelectViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier_HYAddressSelectViewCell3" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.dataBgColor = self.hotCityBgColor;
                cell.dataArr = self.hotCityArr;
                __weak __typeof(self) weakSelf = self;
                cell.selectedItem = ^(NSString * _Nonnull item) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.selectedHotItem) {
                        strongSelf.selectedHotItem(item);
                    }
                };
                return cell;
            }
            
            NSArray *arr = self.sortedStrArr[indexPath.section - 1];
            NSString *showStr = arr[indexPath.row];
            
            HYAddressSelectViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier_HYAddressSelectViewCell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.letterLabel.hidden = indexPath.row == 0 ? NO : YES;
            cell.letterLabel.text = self.letterArr[indexPath.section - 1];
            cell.nameLabel.text = showStr;
            if ([showStr isEqualToString:self.selectedStr]) {
                cell.nameLabel.textColor =  [UIColor redColor];
                cell.nameLabel.transform = CGAffineTransformMakeScale(1.q, 1.1);
            }else {
                cell.nameLabel.textColor = [UIColor blackColor];
                cell.nameLabel.transform = CGAffineTransformIdentity;
            }
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier_UITableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.letterArr[indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            cell.textLabel.textColor = [UIColor colorWithRed:130 / 255.f green:136 / 255.f blue:167/ 255.f alpha:1];
            cell.backgroundColor = [UIColor colorWithRed:238 / 255.f green:241 / 255.f blue:252/ 255.f alpha:1];
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 1: {
            if (indexPath.section == 0) {
                return;
            }
            
            NSArray *arr = self.sortedStrArr[indexPath.section - 1];
            self.selectedStr = arr[indexPath.row];
            [tableView reloadData];
            
            if (self.selectedItem) {
                self.selectedItem(self.selectedStr);
            }
            break;
        }
        case 2: {
            NSIndexPath *idxIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row + 1];
            [self.leftTableView scrollToRowAtIndexPath:idxIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 1: {
            if (indexPath.section == 0) {
                return self.hotCityArr.count > 0 ? ceilf(self.hotCityArr.count / 4.f) * 36 + 50 : 0;
            }
            return 40;
        }
        case 2: {
            return CGRectGetHeight(self.bounds) / 26.f;
        }
        default:
            return 0;
    }
}

@end
