//
//  ViewController.m
//  仿京东消息侧滑删除
//
//  Created by 姚胜龙 on 16/12/20.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "ViewController.h"
#import "JDMessageCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, JDMessageCellDelegate> {
    JDMessageCell *cellAtMode; //正在编辑的cell
}

@property (weak, nonatomic) IBOutlet UITableView *jdTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register cell
    [_jdTableView registerNib:[UINib nibWithNibName:@"JDMessageCell" bundle:nil] forCellReuseIdentifier:@"JDMessageCell"];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDMessageCell *jdCell = [tableView dequeueReusableCellWithIdentifier:@"JDMessageCell"];
    [jdCell configCellWith:[NSDictionary dictionary]];
    jdCell.delegate = self;
    return jdCell;
}

#pragma maek - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 201.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果存在正在编辑的cell 点击其他的cell时，退出编辑
    if (cellAtMode) {
        [cellAtMode quitEditMode];
        [self enableTableViewEditAction:YES];
        cellAtMode = nil;
        NSLog(@"编辑退出");
    }
    else {
        NSLog(@"点击了%ld组", indexPath.section);
    }
}

- (void)enableTableViewEditAction:(BOOL)enable {
    self.jdTableView.scrollEnabled = enable;
    for (NSInteger index = 0; index < self.jdTableView.numberOfSections; index++) {
        JDMessageCell *salesCell = [self.jdTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        [salesCell enableEditAction:enable];
    }
}

#pragma mark - JDMessageCellDelegate
//实现cell的代理方法
- (void)cellBeginEditMode:(JDMessageCell *)cell {
    [self enableTableViewEditAction:NO];
    [cell enableEditAction:YES];
    cellAtMode = cell;
}
//结束编辑了
- (void)cellEndEditMode:(JDMessageCell *)cell {
    [self enableTableViewEditAction:YES];
    cellAtMode = nil;
}

- (void)deleteMessageInCell:(JDMessageCell *)cell {
    NSInteger index = [self.jdTableView indexPathForCell:cell].section;
    [self removeCellAtIndex:index];
}

#pragma mark - Helper Method
- (void)removeCellAtIndex:(NSInteger)index {
    NSLog(@"删除了第%ld组", index);
    //这里要看tableView是plain 还是grouped ->我这里使用的是分组形式的
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
