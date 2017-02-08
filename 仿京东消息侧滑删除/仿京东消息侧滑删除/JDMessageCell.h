//
//  JDMessageCell.h
//  仿京东消息侧滑删除
//
//  Created by 姚胜龙 on 16/12/20.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDMessageCellDelegate;
@interface JDMessageCell : UITableViewCell

@property (nonatomic, assign) id<JDMessageCellDelegate> delegate;
//使用数据初始化cell 这里不一定是dictionary 也有可能是model
- (void)configCellWith:(NSDictionary *)dict;

// 判断是否有cell处于编辑模式下
- (void)enableEditAction:(BOOL)canEdit;
//退出编辑模式
- (void)quitEditMode;

@end

@protocol JDMessageCellDelegate <NSObject>
//cell 开始编辑模式
- (void)cellBeginEditMode:(JDMessageCell *)cell;
// cell 结束编辑模式
- (void)cellEndEditMode:(JDMessageCell *)cell;
//删除这条记录
- (void)deleteMessageInCell:(JDMessageCell *)cell;

@end
