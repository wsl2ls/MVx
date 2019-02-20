//
//  ViewModel.m
//  MultilevelList
//
//  Created by 王双龙 on 2019/2/13.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel ()

@end

@implementation ViewModel

- (instancetype)init{
    
    if (self == [super init]) {
        [self initializeConfi];
    }
    return self;
}

- (void)initializeConfi{
    _dataSource = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    self.selectedObject = [RACSubject subject];
    [self.selectedObject subscribeNext:^(id x) {
        NSDictionary * info = x;
        NSIndexPath *indexPath = info[@"cellIndexPath"];
        SLNodeModel * nodeModel = weakSelf.dataSource[indexPath.row];
        nodeModel.selected = [info[@"isSelected"] boolValue];
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:nodeModel];
        [weakSelf selectedChildrenNodes:nodeModel.level selected:nodeModel.selected atIndexPath:indexPath];
    }];
    
    self.expandObject = [RACSubject subject];
    [self.expandObject subscribeNext:^(id x) {
        NSDictionary * info = x;
        NSIndexPath *indexPath = info[@"cellIndexPath"];
        SLNodeModel * nodeModel = weakSelf.dataSource[indexPath.row];
        nodeModel.expand = [info[@"isExpand"] boolValue];
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:nodeModel];
        if (nodeModel.expand) {
            [weakSelf expandChildrenNodesLevel:nodeModel.level atIndexPath:indexPath];
        }else{
            [weakSelf hiddenChildrenNodesLevel:nodeModel.level atIndexPath:indexPath];
        }
    }];
    
    self.reloadObject = [RACSubject subject];
    self.insertObject = [RACSubject subject];
    self.deleteObject = [RACSubject subject];
    
}

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
        node.leaf = (node.level < 4) ? NO : YES;
        node.root = NO;
        node.expand = NO;
        node.selected = nodeModel.selected;
        [self.dataSource insertObject:node atIndex:insertLocation + i];
        [insertNodeRows addObject:[NSIndexPath indexPathForRow:insertLocation + i inSection:0]];
    }
    
    //插入展开cell
    [self.insertObject sendNext:insertNodeRows];
    
    //更新新插入的元素之后的所有cell的cellIndexPath
    NSMutableArray * reloadRows = [NSMutableArray array];
    int reloadLocation = insertLocation + (int)insertNodeRows.count;
    for (int i = reloadLocation; i < self.dataSource.count; i++) {
        [reloadRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    //告诉view刷新界面
    [self.reloadObject sendNext:reloadRows];
    
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
    [self.deleteObject sendNext:deleteNodeRows];
    
    //更新删除的元素之后的所有cell的cellIndexPath
    NSMutableArray * reloadRows = [NSMutableArray array];
    int reloadLocation = deleteLocation;
    for (int i = reloadLocation; i < self.dataSource.count; i++) {
        [reloadRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    //告诉view刷新界面
    [self.reloadObject sendNext:reloadRows];

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
    [self.reloadObject sendNext:selectedNodeRows];
}


@end
