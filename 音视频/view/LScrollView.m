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
@property (nonatomic, assign) int index;
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
    if (self.index == indexPath.row) {
        cell.textLabel.textColor = [UIColor magentaColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20.f];
    } else {
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime < _currentTime) {
        self.index = 0;
    }
    _currentTime = currentTime;
    NSArray *lrcs = [LLrcTool lrcs];
    [_tableView reloadData];
    // 通过当前时间找到时间对应的歌词
    for (int i = 0; i < lrcs.count; i ++) {
        LLrcModel *lrc = lrcs[i];
        NSTimeInterval time = [LLrcTool setUpTimeWithLrcTime:lrc.time];
        if (i + 1 < lrcs.count) {
            LLrcModel *nextLrc = lrcs[i + 1];
            NSTimeInterval nextTime = [LLrcTool setUpTimeWithLrcTime:nextLrc.time];
            if (time < currentTime && currentTime < nextTime && i != self.index) {
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
                NSIndexPath *nowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                self.index = i;
                [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath, nowIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
}

@end
