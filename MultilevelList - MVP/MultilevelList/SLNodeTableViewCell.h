//
//  SLNodeTableViewCell.h
//  MultilevelList
//
//  Created by 王双龙 on 2019/1/11.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Presenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLNodeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *name; //结点名字
@property (nonatomic, assign) int level; // 结点层级 从1开始
@property (nonatomic, assign) BOOL leaf;  // 树叶(Leaf) If YES：此结点下边没有结点咯；
@property (nonatomic, assign) BOOL expand; // 是否展开
@property (nonatomic, assign) BOOL isSelected; // 是否选中

@property (nonatomic, strong) NSIndexPath *cellIndexPath; // cell的位置
@property (nonatomic, assign) CGSize cellSize; // 宽高
@property (nonatomic, weak) id <PresenterDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)refreshCell;

@end

NS_ASSUME_NONNULL_END
