//
//  ViewController.m
//  TableViewSectionDemo
//
//  Created by jhmac on 2020/9/1.
//  Copyright © 2020 iTBoyer. All rights reserved.
//

#import "ViewController.h"
#import "SectionModel.h"
#import "SectionView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //使用UITableViewStylePlain样式创建表格，这不妨碍你使用头部视图
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self.tableView registerClass:[SectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
}
//懒加载
- (NSMutableArray *)sectionData{
    if (_sectionData == nil) {
        _sectionData = [[NSMutableArray alloc]init];
        for (int i=0; i<40; i++) {
            SectionModel *model = [[SectionModel alloc]init];
            model.title = [NSString stringWithFormat:@"%d",i];
            model.isExpand = NO;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int j=0; j<10; j++) {
                CellModel *cell = [[CellModel alloc]init];
                cell.title = [NSString stringWithFormat:@"LivenCell==Section:%d,Row:%d",i,j];
                [array addObject:cell];
            }
            model.cellArray = array;
            [_sectionData addObject:model];
        }
    }
    return _sectionData;

}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SectionModel *model = _sectionData[section];
    return model.isExpand?model.cellArray.count:0;
//    return model.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    SectionModel *section = _sectionData[indexPath.section];
    CellModel *model = section.cellArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    SectionModel *model = _sectionData[section];
    view.model = model;
    //更变了section的cell数量，所以要刷新
    __weak typeof(self) weakSelf = self;
    view.block = ^(BOOL isExpanded){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
//        [weakSelf section:section insertOrDelete:isExpanded];
    };
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)section:(NSInteger)sectionIndex insertOrDelete:(BOOL)insert{

//    1. 这个方法用于在调用插入，删除，选择方法时，同时有动画效果。
//    2. 用endUpdate能动画改变行高，而无需relaod这个cell。
//    3. beginUpdate和endUpdate成对使用，其包含的block里面，如果没有插入删除，选择的方法被使用。有可能导致这个table view的一些属性失效，例如行的数量。
//    4. 不应该在这个block范围里调用 reloadData，或者reloadRowsAtIndexPaths。一旦使用，必须自己执行和管理自己的动画效果。
//    第三点和第四点比较重要。也是导致闪退的原因。reloadData会引起，获取单元格高度，以及cell的重新加载。这会导致一些动画对应的行号产生变化。从而闪退。

//    beginUpdates方法和endUpdates方法是什么呢？
//
//    这两个方法，是配合起来使用的，标记了一个tableView的动画块。
//
//    分别代表动画的开始开始和结束。
//
//    两者成对出现，可以嵌套使用。
//
//    一般，在添加，删除，选择 tableView中使用，并实现动画效果。
//
//    在动画块内，不建议使用reloadData方法，如果使用，会影响动画。

//    一般在UITableView执行：删除行，插入行，删除分组，插入分组时，使用！用来协调UITableView的动画效果。
    [self.tableView beginUpdates];
    SectionModel *section = self.sectionData[sectionIndex];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:section.cellArray.count];
    [section.cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:sectionIndex];
        [indexPaths addObject:indexP];
    }];
    if (insert) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
}

@end
