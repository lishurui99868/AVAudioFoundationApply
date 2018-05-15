//
//  LScrollView.m
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LScrollView.h"
#import "LLrcTool.h"
#import "LLrcModel.h"

@interface LScrollView ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation LScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.showsHorizontalScrollIndicator = NO;
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(self.frame.size.height * .5f, 0, self.frame.size.height * .5f, 0);
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
    _tableView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[LLrcTool lrcs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    LLrcModel *lrc = [LLrcTool lrcs][indexPath.row];
    cell.textLabel.text = lrc.lrc;
    cell.textLabel.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

@end
