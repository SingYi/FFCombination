//
//  FFCollectionViewCell.m
//  FFCombination
//
//  Created by 石燚 on 2017/12/9.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFCollectionViewCell.h"

@interface FFCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FFCollectionViewCell



- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
