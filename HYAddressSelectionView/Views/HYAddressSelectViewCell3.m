//
//  HYAddressSelectViewCell3.m
//  TestAPP2
//
//  Created by xiehy on 2021/2/7.
//

#import "HYAddressSelectViewCell3.h"
#import "HYAddressSelectViewCell4.h"

@interface HYAddressSelectViewCell3 ()<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation HYAddressSelectViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HYAddressSelectViewCell4" bundle:nil] forCellWithReuseIdentifier:@"CellIdentifier_HYAddressSelectViewCell4"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.frame) / 4, 36);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYAddressSelectViewCell4 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier_HYAddressSelectViewCell4" forIndexPath:indexPath];
    cell.label.text = self.dataArr[indexPath.item];
    if (self.dataBgColor) {
        cell.label.backgroundColor = self.dataBgColor;
        cell.label.layer.masksToBounds = YES;
        cell.label.layer.cornerRadius = (36 - 10) * 0.5;
    }else {
        cell.label.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedItem) {
        self.selectedItem(self.dataArr[indexPath.item]);
    }
}

@end
