//
//  ViewModel.h
//  MultilevelList
//
//  Created by 王双龙 on 2019/2/13.
//  Copyright © 2019年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReactiveCocoa/ReactiveCocoa/RACSubject.h"
#import "SLNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

static int const MaxLevel = 4; //最大的层级数

@interface ViewModel : NSObject

@property(nonatomic,strong) RACSubject *selectedObject; //选中信号
@property(nonatomic,strong) RACSubject *expandObject;  //展开合并信号

@property(nonatomic,strong) RACSubject *reloadObject;  //刷新cell信号
@property(nonatomic,strong) RACSubject *insertObject;  //插入cell信号
@property(nonatomic,strong) RACSubject *deleteObject;  //删除cell信号

@property (strong, nonatomic) NSMutableArray * dataSource;

- (void)setDataSOurce;

@end

NS_ASSUME_NONNULL_END
