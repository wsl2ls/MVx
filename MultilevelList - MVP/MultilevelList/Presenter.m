//
//  Presenter.m
//  MultilevelList
//
//  Created by 王双龙 on 2019/2/12.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import "Presenter.h"

@implementation Presenter

#pragma mark - DataSouce

// 获取并初始化 树根结点数组
- (void)setDataSOurce {
    for (int i = 0; i < 4; i++) {
        SLNodeModel * node = [[SLNodeModel alloc] init];
        node.parentID = @"";
        node.childrenID = @"";
        node.level = 1;
        node.name = [NSString stringWithFormat:@"第%d级结点",node.level];
        node.leaf = 0;
        node.root = YES;
        node.expand = NO;
        node.selected = NO;
        [self.dataSource addObject:node];
    }
}

/**
 获取并展开父结点的子结点数组 数量随机产生
 @param level 父结点的层级
 @param indexPath 父结点所在的位置
 */
- (void)expandChildrenNodesLevel:(int)level atIndexPath:(NSIndexPath *)indexPath {
    SLNodeModel * nodeModel = self.dataSource[indexPath.row];
    //模拟数据请求 生成假数据
    NSMutableArray * insertNodeRows = [NSMutableArray array];
    int insertLocation = (int)indexPath.row + 1;
    for (int i = 0; i < arc4random()%9; i++) {
        SLNodeModel * node = [[SLNodeModel alloc] init];
        node.parentID = @"";
        node.childrenID = @"";
        node.level = level + 1;
        node.name = [NSString stringWithFormat:@"第%d级结点",node.level];
        node.leaf = (node.level < MaxLevel) ? NO : YES;
        node.root = NO;
        node.expand = NO;
        node.selected = nodeModel.selected;
        [self.dataSource insertObject:node atIndex:insertLocation + i];
        [insertNodeRows addObject:[NSIndexPath indexPathForRow:insertLocation + i inSection:0]];
    }
    
    //插入展开cell
    if ([self.delegate respondsToSelector:@selector(insertRowsAtIndexPaths:)]) {
        [self.delegate insertRowsAtIndexPaths:insertNodeRows];
    }
    
    //更新新插入的元素之后的所有cell的cellIndexPath
    NSMutableArray * reloadRows = [NSMutableArray array];
    int reloadLocation = insertLocation + (int)insertNodeRows.count;
    for (int i = reloadLocation; i < self.dataSource.count; i++) {
        [reloadRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
  
    //告诉view刷新界面
    if ([self.delegate respondsToSelector:@selector(presenterReloadRows:)]) {
        [self.delegate presenterReloadRows:reloadRows];
    }
    
}

/**
 获取并隐藏父结点的子结点数组
 @param level 父结点的层级
 @param indexPath 父结点所在的位置
 */
- (void)hiddenChildrenNodesLevel:(int)level atIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * deleteNodeRows = [NSMutableArray array];
    int length = 0;
    int deleteLocation = (int)indexPath.row + 1;
    for (int i = deleteLocation; i < self.dataSource.count; i++) {
        SLNodeModel * node = self.dataSource[i];
        if (node.level > level) {
            [deleteNodeRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            length++;
        }else{
            break;
        }
    }
    [self.dataSource removeObjectsInRange:NSMakeRange(deleteLocation, length)];
    
    //删除合并cell
    if ([self.delegate respondsToSelector:@selector(deleteRowsAtIndexPaths:)]) {
        [self.delegate deleteRowsAtIndexPaths:deleteNodeRows];
    }
    
    //更新删除的元素之后的所有cell的cellIndexPath
    NSMutableArray * reloadRows = [NSMutableArray array];
    int reloadLocation = deleteLocation;
    for (int i = reloadLocation; i < self.dataSource.count; i++) {
        [reloadRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
   
     //告诉view刷新界面
    if ([self.delegate respondsToSelector:@selector(presenterReloadRows:)]) {
        [self.delegate presenterReloadRows:reloadRows];
    }
}

/**
 更新当前结点下所有子结点的选中状态
 @param level 选中的结点层级
 @param selected 是否选中
 @param indexPath 选中的结点位置
 */
- (void)selectedChildrenNodes:(int)level selected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * selectedNodeRows = [NSMutableArray array];
    int deleteLocation = (int)indexPath.row + 1;
    for (int i = deleteLocation; i < self.dataSource.count; i++) {
        SLNodeModel * node = self.dataSource[i];
        if (node.level > level) {
            node.selected = selected;
            [selectedNodeRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }else{
            break;
        }
    }
    
     //告诉view刷新界面
    if ([self.delegate respondsToSelector:@selector(presenterReloadRows:)]) {
        [self.delegate presenterReloadRows:selectedNodeRows];
    }
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - PresenterDelegate

- (void)nodeTableViewCellSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath {
    SLNodeModel * nodeModel = self.dataSource[indexPath.row];
    nodeModel.selected = selected;
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:nodeModel];
    [self selectedChildrenNodes:nodeModel.level selected:selected atIndexPath:indexPath];
}

- (void)nodeTableViewCellExpand:(BOOL)expand atIndexPath:(NSIndexPath *)indexPath {
    SLNodeModel * nodeModel = self.dataSource[indexPath.row];
    nodeModel.expand = expand;
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:nodeModel];
    if (expand) {
        [self expandChildrenNodesLevel:nodeModel.level atIndexPath:indexPath];
    }else{
        [self hiddenChildrenNodesLevel:nodeModel.level atIndexPath:indexPath];
    }
}

@end
