//
//  UCFBidFootBoardView.m
//  JRGC
//
//  Created by zrc on 2018/12/18.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidFootBoardView.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "NZLabel.h"
@interface UCFBidFootBoardView()
@property(nonatomic, strong) UIView     *firstSectionView;
@property(nonatomic, strong) YYLabel *limitAmountMessLabel;
@property(nonatomic, strong) UIView     *secondSectionView;
@property(nonatomic, strong) UIView     *thirdSectionView;
@property(nonatomic, strong) UIView     *fourSectionView;
@property(nonatomic, strong) NZLabel    *contractMsgLabel;
@property(nonatomic, strong) UIView     *fiveSectionView;
@property(nonatomic, strong) UIView     *sixSectionView;

@property(nonatomic, weak)UCFBidViewModel *myVM;

@end
@implementation UCFBidFootBoardView
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    [self.KVOController observe:viewModel keyPaths:@[@"limitAmountMess",@"limitAmountNum",@"cfcaContractName",@"contractMsg"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"limitAmountMess"]) {
            NSString *limitAmountMess = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (limitAmountMess.length > 0) {
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:limitAmountMess];
                text.yy_color = UIColorWithRGB(0x999999);
                _limitAmountMessLabel.text = limitAmountMess;
                [_limitAmountMessLabel sizeToFit];
                _limitAmountMessLabel.attributedText = text;
                self.firstSectionView.myVisibility = MyVisibility_Visible;
            } else {
                self.firstSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"limitAmountNum"]) {
            NSString *limitAmountNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (limitAmountNum.length > 0) {
                NSString *string = [_limitAmountMessLabel.attributedText string];
                NSMutableAttributedString *attri_str = [[NSMutableAttributedString alloc] initWithString:string];
                attri_str.yy_color = UIColorWithRGB(0x999999);
                [attri_str yy_setColor:UIColorWithRGB(0xf3ab47) range:[_limitAmountMessLabel.text rangeOfString:limitAmountNum]];
                _limitAmountMessLabel.attributedText = attri_str;
                [_limitAmountMessLabel sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"cfcaContractName"]) {
            NSString *cfcaContractName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (cfcaContractName.length > 0) {
                _secondSectionView.myVisibility = MyVisibility_Visible;
            } else {
                _secondSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"contractMsg"]) {
            NSArray *contractMsg = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (contractMsg.count > 0) {
                NSString *totalStr = [NSString stringWithFormat:@"本人已阅读并同意签署"];
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [[contractMsg objectAtIndex:i] valueForKey:@"contractName"];
                    totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
                }
                self.contractMsgLabel.text = totalStr;
                __weak typeof(self) weakSelf = self;
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[[contractMsg objectAtIndex:i] valueForKey:@"contractName"]] ;
                    [self.contractMsgLabel setFontColor:UIColorWithRGB(0x4aa1f9) range:[totalStr rangeOfString:tmpStr]];
                    
                    [self.contractMsgLabel addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
                        NSLog(@"111");
                        [weakSelf totalString:linkModel.linkString];
                    }];
                    
                }
                _fourSectionView.myVisibility = MyVisibility_Visible;
          
            } else {
                _fourSectionView.myVisibility = MyVisibility_Gone;
            }
        }
    }];
}
- (void)totalString:(NSString *)constractName
{
    constractName = [constractName stringByReplacingOccurrencesOfString:@"《" withString:@""];
    constractName = [constractName stringByReplacingOccurrencesOfString:@"》" withString:@""];
    DLog(@"%@",constractName);
    [self.myVM bidViewModel:self.myVM WithContractName:constractName];
}
- (void)createAllShowView
{
    [self createSectionOne];
    [self createSectionTwo];
    [self createSectionThree];
    [self createSectionFour];
    [self createSectionsix];
}
- (void)createSectionOne
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.myTop = 0;
    view.myHeight = 20;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.firstSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.centerYPos.equalTo(view.centerYPos).offset(1.5);
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.firstSectionView addSubview:imageView];
    
    YYLabel *limitAmountMessLabel = [[YYLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    //不要删除，需要占位，要不数据反射回来 这个lab的frame 会变成0
//    limitAmountMessLabel.text = @"经过风险评估，您本次出借金额上限为1000万";
    limitAmountMessLabel.centerYPos.equalTo(view.centerYPos).offset(1.5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    [self.firstSectionView addSubview:limitAmountMessLabel];
    self.limitAmountMessLabel = limitAmountMessLabel;
    [limitAmountMessLabel sizeToFit];
}
- (void)createSectionTwo
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.firstSectionView.bottomPos);
    view.myHeight = 20;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.secondSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.centerYPos.equalTo(view.centerYPos).offset(1.5);
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.secondSectionView addSubview:imageView];
    
    NSString *showStr = @"本人阅读并同意《CFCA数字证书服务协议》";
    
    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    [limitAmountMessLabel sizeToFit];
    limitAmountMessLabel.centerYPos.equalTo(view.centerYPos).offset(1.5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.textColor = UIColorWithRGB(0x999999);
    [self.secondSectionView addSubview:limitAmountMessLabel];
    
    limitAmountMessLabel.userInteractionEnabled = YES;
    [limitAmountMessLabel setFontColor:UIColorWithRGB(0x4aa1f9) range:[showStr rangeOfString:@"《CFCA数字证书服务协议》"]];
    __weak typeof(self) weakSelf = self;
    [limitAmountMessLabel addLinkString:@"《CFCA数字证书服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        //        [weakSelf totalString:text andRange:range];
        NSLog(@"111");
        [weakSelf totalString:linkModel.linkString];
    }];
    
    
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:showStr];
//    text.yy_color = UIColorWithRGB(0x999999);
//    __weak typeof(self) weakSelf = self;
//    [text yy_setTextHighlightRange:[showStr rangeOfString:@"《CFCA数字证书服务协议》"]
//                             color:UIColorWithRGB(0x4aa1f9)
//                   backgroundColor:[UIColor lightGrayColor]
//                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//                             [weakSelf totalString:text andRange:range];
//                         }];
//    limitAmountMessLabel.attributedText = text;
}
- (void)createSectionThree
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.secondSectionView.bottomPos);
    view.wrapContentHeight = YES;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.thirdSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 10;
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.thirdSectionView addSubview:imageView];
   
    NSString *showStr = @"本人阅读并悉知《网络借贷出借风险及禁止性行为提示》中风险";;

    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.textColor = UIColorWithRGB(0x999999);
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [limitAmountMessLabel sizeToFit];
    [self.thirdSectionView addSubview:limitAmountMessLabel];
    limitAmountMessLabel.bottomPos.equalTo(self.bottomPos).offset(5);
    limitAmountMessLabel.userInteractionEnabled = YES;
    [limitAmountMessLabel setFontColor:UIColorWithRGB(0x4aa1f9) range:[showStr rangeOfString:@"《网络借贷出借风险及禁止性行为提示》"]];
    __weak typeof(self) weakSelf = self;
    [limitAmountMessLabel addLinkString:@"《网络借贷出借风险及禁止性行为提示》" block:^(ZBLinkLabelModel *linkModel) {
//        [weakSelf totalString:text andRange:range];
        [weakSelf totalString:linkModel.linkString];
        NSLog(@"111");
    }];
    
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:showStr];
//    text.yy_color = UIColorWithRGB(0x999999);
//     __weak typeof(self) weakSelf = self;
//    [text yy_setTextHighlightRange:[showStr rangeOfString:@"《网络借贷出借风险及禁止性行为提示》"]
//                             color:UIColorWithRGB(0x4aa1f9)
//                   backgroundColor:[UIColor lightGrayColor]
//                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//                             NSLog(@"111");
//                             [weakSelf totalString:text andRange:range];
//                         }];
//    limitAmountMessLabel.attributedText = text;
}
- (void)createSectionFour
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.thirdSectionView.bottomPos);
    view.wrapContentHeight = YES;
//    view.myHeight = 20;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.fourSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 10;
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.fourSectionView addSubview:imageView];
    
    NSString *showStr = @"本人已阅读并同意签署";;
    
    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.bottomPos.equalTo(self.bottomPos).offset(5);
    limitAmountMessLabel.textColor = UIColorWithRGB(0x999999);
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [limitAmountMessLabel sizeToFit];
    limitAmountMessLabel.userInteractionEnabled = YES;
    self.contractMsgLabel = limitAmountMessLabel;
    [self.fourSectionView addSubview:limitAmountMessLabel];
}

- (void)createSectionfive
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.fourSectionView.bottomPos);
    view.wrapContentHeight = YES;
    //    view.myHeight = 20;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.fiveSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 11.5;
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.fiveSectionView addSubview:imageView];
    
    NSString *showStr = @"同意并认可";;
    
    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.bottomPos.equalTo(self.bottomPos).offset(5);
    limitAmountMessLabel.textColor = UIColorWithRGB(0x999999);
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [limitAmountMessLabel sizeToFit];
    self.contractMsgLabel = limitAmountMessLabel;
    self.contractMsgLabel.userInteractionEnabled = YES;
    [self.fiveSectionView addSubview:limitAmountMessLabel];
}


- (void)createSectionsix
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.fourSectionView.bottomPos);
    view.myHeight = 20;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.sixSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 7;
    imageView.mySize = CGSizeMake(5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.sixSectionView addSubview:imageView];
    
    YYLabel *limitAmountMessLabel = [[YYLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:12.0f];
    limitAmountMessLabel.numberOfLines = 0;
    //不要删除，需要占位，要不数据反射回来 这个lab的frame 会变成0
    limitAmountMessLabel.text = @"本人接受筹标期内资金不计利息，出借意向不可撤销";
    limitAmountMessLabel.textColor = UIColorWithRGB(0x999999);
    limitAmountMessLabel.centerYPos.equalTo(view.centerYPos).offset(1.5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(10);
    [self.sixSectionView addSubview:limitAmountMessLabel];
    [limitAmountMessLabel sizeToFit];
}
@end
