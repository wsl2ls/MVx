//
//  ViewController.m
//  MultilevelList
//
//  Created by 王双龙 on 2019/1/11.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import "ViewController.h"
#import "SLNodeModel.h"
#import "SLNodeTableViewCell.h"
#import "ViewModel.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (strong, nonatomic) NSMutableArray * selectedSource;

@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TableView 多级列表";
    self.selectedSource = [NSMutableArray array];

    self.dataSource = self.viewModel.dataSource;

}

#pragma mark - Getter

- (ViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ViewModel alloc] init];
        [_viewModel setDataSOurce];
        [_viewModel.reloadObject subscribeNext:^(id x) {
            [self presenterReloadRows:x];
        }];
        [_viewModel.insertObject subscribeNext:^(id x) {
            [self insertRowsAtIndexPaths:x];
        }];
        [_viewModel.deleteObject subscribeNext:^(id x) {
            [self deleteRowsAtIndexPaths:x];
        }];
    }
    return _viewModel;
}

#pragma mark - Help Methods

- (void)presenterReloadRows:(NSArray<NSIndexPath *> *)rows{
    if (rows.count == 0) {
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertRowsAtIndexPaths:(NSArray <NSIndexPath *> *)rows {
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rows] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
- (void)deleteRowsAtIndexPaths:(NSArray <NSIndexPath *> *)rows {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLNodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[SLNodeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    SLNodeModel * node = self.dataSource[indexPath.row];
    cell.leaf = node.leaf;
    cell.name = node.name;
    cell.level = node.level;
    cell.leaf = node.leaf;
    cell.expand = node.expand;
    cell.isSelected = node.selected;
    
    __weak typeof(_viewModel) weakViewModel = _viewModel;
   
    cell.viewModel = weakViewModel;
    cell.cellSize = CGSizeMake(self.view.frame.size.width, 44);
    cell.cellIndexPath = indexPath;
    [cell refreshCell];
    
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
