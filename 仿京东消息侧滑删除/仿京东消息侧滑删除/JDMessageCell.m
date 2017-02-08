//
//  JDMessageCell.m
//  仿京东消息侧滑删除
//
//  Created by 姚胜龙 on 16/12/20.
//  Copyright © 2016年 姚胜龙. All rights reserved.
//

#import "JDMessageCell.h"

@interface JDMessageCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;

@end

@implementation JDMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //这些属性都可以在Xib中设置 为了显示设置了什么属性写了出来
    _bgScrollView.userInteractionEnabled = NO;
    _bgScrollView.bounces = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.delegate = self;
    //解决cell原生侧滑删除冲突
    [self.contentView addGestureRecognizer:_bgScrollView.panGestureRecognizer];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width * 2, _bgScrollView.frame.size.height);

    //给cell的rightView空白区域添加个手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitEditCell:)];
    tap.numberOfTapsRequired = 1;
    [self.rightView addGestureRecognizer:tap];
}

- (void)configCellWith:(NSDictionary *)dict {
    [_bgScrollView setContentOffset:CGPointZero animated:NO];
    _bgScrollView.userInteractionEnabled = NO;
}

- (void)enableEditAction:(BOOL)canEdit {
    if (canEdit) {
        [self.contentView addGestureRecognizer:_bgScrollView.panGestureRecognizer];
    }
    else {
        [self.contentView removeGestureRecognizer:_bgScrollView.panGestureRecognizer];
    }
}
//退出编辑模式
- (void)quitEditMode{
    [_bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    _bgScrollView.userInteractionEnabled = NO;
}

- (void)quitEditCell:(UITapGestureRecognizer *)gesture {
    [self quitEditMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellEndEditMode:)]) {
        [self.delegate cellEndEditMode:self];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat cellWidth = scrollView.frame.size.width;
    if (scrollView.contentOffset.x >= cellWidth / 2.0) {
        scrollView.userInteractionEnabled = YES;
        //此时cell处于编辑状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellBeginEditMode:)]) {
            [self.delegate cellBeginEditMode:self];
        }
    }
    else {
        scrollView.userInteractionEnabled = NO;
        //cell 退出编辑状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellEndEditMode:)]) {
            [self.delegate cellEndEditMode:self];
        }
    }
}

#pragma mark - Button Action
- (IBAction)cancelBtnAction:(id)sender {
    [self quitEditMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellEndEditMode:)]) {
        [self.delegate cellEndEditMode:self];
    }
}

- (IBAction)deleteBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMessageInCell:)]) {
        [self.delegate deleteMessageInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
