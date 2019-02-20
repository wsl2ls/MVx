//
//  Presenter.h
//  MultilevelList
//
//  Created by 王双龙 on 2019/2/12.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNodeModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static int const MaxLevel = 4; //最大的层级数

@protocol PresenterDelegate <NSObject>
@optional
- (void)nodeTableViewCellSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath; //选中的代理
- (void)nodeTableViewCellExpand:(BOOL)expand atIndexPath:(NSIndexPath *)indexPath;  //展开/合并的代理
- (void)presenterReloadRows:(NSArray <NSIndexPath *> *)rows; // 刷新cell
- (void)insertRowsAtIndexPaths:(NSArray <NSIndexPath *> *)rows; //插入
- (void)deleteRowsAtIndexPaths:(NSArray <NSIndexPath *> *)rows; //删除
@end

@interface Presenter : NSObject <PresenterDelegate>

@property (strong, nonatomic) NSMutableArray * dataSource;

@property (nonatomic, weak) id <PresenterDelegate> delegate;

// 获取并初始化 树根结点数组
- (void)setDataSOurce;

@end

NS_ASSUME_NONNULL_END
