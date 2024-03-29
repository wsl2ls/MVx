//
//  SLNodeTableViewCell.m
//  MultilevelList
//
//  Created by 王双龙 on 2019/1/11.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import "SLNodeTableViewCell.h"

@interface SLNodeTableViewCell ()

@property (nonatomic, strong) UIButton *selectedBtn; // 选中按钮
@property (nonatomic, strong) UILabel *nameLabel; // 名字
@property (nonatomic, strong) UIButton *expandBtn; // 展开按钮
@property (nonatomic, strong) UIView *line; // 细线

@end

@implementation SLNodeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectedBtn = [[UIButton alloc] init];
        [_selectedBtn addTarget:self action:@selector(selectedClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectedBtn];
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        _expandBtn = [[UIButton alloc] init];
        [_expandBtn addTarget:self action:@selector(expandBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_expandBtn];
    }
    return self;
}

#pragma mark - Help Methods

- (void)refreshCell {
    
    if(self.isSelected){
        [_selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"disSelected"] forState:UIControlStateNormal];
    }
    if (self.expand) {
        [_expandBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
    }else{
        [_expandBtn setImage:[UIImage imageNamed:@"noExpand"] forState:UIControlStateNormal];
    }
    
    CGSize selectedSize = CGSizeMake(20, 20);
    CGSize expandSize = CGSizeMake(20, 20);
    _selectedBtn.frame = CGRectMake(8 + (self.level - 1) * selectedSize.width, (self.cellSize.height - selectedSize.height)/2.0, selectedSize.width, selectedSize.height);
    _expandBtn.frame = CGRectMake(self.cellSize.width - 8 - expandSize.width, (self.cellSize.height - expandSize.height)/2.0, selectedSize.width, selectedSize.height);
    _nameLabel.frame = CGRectMake(_selectedBtn.frame.origin.x + selectedSize.width + 8, 0, _expandBtn.frame.origin.x - 8 - (_selectedBtn.frame.origin.x + selectedSize.width + 8), self.cellSize.height);
    _nameLabel.text = self.name;
    
    if (_leaf) {
        _expandBtn.hidden = YES;
    }else{
        _expandBtn.hidden = NO;
    }
    
}

#pragma mark - Event Handle

- (void)selectedClicked:(UIButton *)btn {
    if(!self.isSelected){
        [_selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"disSelected"] forState:UIControlStateNormal];
    }
    self.isSelected = !self.isSelected;
    [_viewModel.selectedObject sendNext:@{@"isSelected":@(self.selected), @"cellIndexPath" :self.cellIndexPath}];
}

- (void)expandBtnClicked:(UIButton *)btn {
    if (!self.expand) {
        [_expandBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
    }else{
        [_expandBtn setImage:[UIImage imageNamed:@"noExpand"] forState:UIControlStateNormal];
    }
    self.expand = !self.expand;
     [_viewModel.expandObject sendNext:@{@"isExpand":@(self.expand), @"cellIndexPath" :self.cellIndexPath}];
}

@end
