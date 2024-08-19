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
#import "UILabel+Misc.h"
@interface UCFBidFootBoardView()
@property(nonatomic, strong) UIView     *firstSectionView;
@property(nonatomic, strong) YYLabel *limitAmountMessLabel;
@property(nonatomic, strong) UIView     *secondSectionView;
@property(nonatomic, strong) UIView     *thirdSectionView;
@property(nonatomic, strong) UIView     *fourSectionView;
@property(nonatomic, strong) NZLabel    *contractMsgLabel;
//@property(nonatomic, strong) UIView     *fiveSectionView;
@property(nonatomic, strong) UIView     *sixSectionView;
@property(nonatomic, strong) UIView     *sevenSectionView;
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, weak)UCFPureTransPageViewModel *myTransVM;
@property(nonatomic, weak)UCFCollectionViewModel    *myCollectionVM;


@end
@implementation UCFBidFootBoardView
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"limitAmountMess",@"limitAmountNum",@"cfcaContractName",@"contractMsg"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"limitAmountMess"]) {
            NSString *limitAmountMess = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (limitAmountMess.length > 0) {
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:limitAmountMess];
                text.yy_color = [Color color:PGColorOptionTitleGray];
                text.yy_font = [Color gc_Font:14];

                selfWeak.limitAmountMessLabel.attributedText = text;
                selfWeak.firstSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.firstSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"limitAmountNum"]) {
            NSString *limitAmountNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (limitAmountNum.length > 0) {
                NSString *string = [selfWeak.limitAmountMessLabel.attributedText string];
                NSMutableAttributedString *attri_str = [[NSMutableAttributedString alloc] initWithString:string];
                attri_str.yy_color = [Color color:PGColorOptionTitleGray];
                attri_str.yy_font = [Color gc_Font:14];
                [attri_str yy_setColor: [Color color:PGColorOptionTitleGray] range:[selfWeak.limitAmountMessLabel.text rangeOfString:limitAmountNum]];
                selfWeak.limitAmountMessLabel.font = [Color gc_Font:14];
                selfWeak.limitAmountMessLabel.attributedText = attri_str;
                [selfWeak.limitAmountMessLabel sizeToFit];
            }
        } else if ([keyPath isEqualToString:@"cfcaContractName"]) {
            NSString *cfcaContractName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (cfcaContractName.length > 0) {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"contractMsg"]) {
            NSArray *contractMsg = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (contractMsg.count > 0) {
                NSString *totalStr = [NSString stringWithFormat:@"本人已阅读并同意签署"];
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [[contractMsg objectAtIndex:i] valueForKey:@"contractName"];
                    totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
                }
                selfWeak.contractMsgLabel.text = totalStr;
//                __weak typeof(self) weakSelf = self;
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[[contractMsg objectAtIndex:i] valueForKey:@"contractName"]] ;
                    [selfWeak.contractMsgLabel setFontColor:[Color color:PGColorOptionCellContentBlue] range:[totalStr rangeOfString:tmpStr] lineSpace:5];
                    
                    [selfWeak.contractMsgLabel addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
                        NSLog(@"111");
                        [selfWeak totalString:linkModel.linkString];
                    }];
                    
                }
                selfWeak.fourSectionView.myVisibility = MyVisibility_Visible;
          
            } else {
                selfWeak.fourSectionView.myVisibility = MyVisibility_Gone;
            }
        }
    }];
}
- (void)showTransView:(UCFPureTransPageViewModel *)viewModel
{
    self.myTransVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"isShowCFCA",@"isShowRisk",@"isShowHonerTip",@"contractMsg"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"isShowCFCA"]) {
           BOOL isShowCFCA = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isShowCFCA) {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"isShowRisk"]) {
            BOOL isShowRisk = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isShowRisk) {
                selfWeak.thirdSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.thirdSectionView.myVisibility = MyVisibility_Gone;
            }
        }  else if ([keyPath isEqualToString:@"contractMsg"]) {
            NSArray *contractMsg = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (contractMsg.count > 0) {
                NSString *totalStr = [NSString stringWithFormat:@"本人已阅读并同意签署"];
                for (int i = 0; i < contractMsg.count; i++) {
                    UCFTransPureContractmsg *md = [contractMsg objectAtIndex:i];
                    NSString *tmpStr = md.contractName;
                    totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
                }
                selfWeak.contractMsgLabel.text = totalStr;
                //                __weak typeof(self) weakSelf = self;
                for (int i = 0; i < contractMsg.count; i++) {
                    UCFTransPureContractmsg *md = [contractMsg objectAtIndex:i];

                    NSString *tmpStr = [NSString stringWithFormat:@"《%@》",md.contractName] ;
                    [selfWeak.contractMsgLabel setFontColor:[Color color:PGColorOptionCellContentBlue] range:[totalStr rangeOfString:tmpStr] lineSpace:5];
                    
                    [selfWeak.contractMsgLabel addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
                        [selfWeak totalString:linkModel.linkString];
                    }];
                    
                }
                selfWeak.fourSectionView.myVisibility = MyVisibility_Visible;
                
            } else {
                selfWeak.fourSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"isShowHonerTip"]) {
            BOOL isShowHonerTip = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isShowHonerTip) {
                selfWeak.sevenSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.sevenSectionView.myVisibility = MyVisibility_Gone;
            }
        }
    }];
}
- (void)blindCollectionView:(UCFCollectionViewModel *)viewModel
{
    self.myCollectionVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"cfcaContractName",@"isShowRisk",@"contractMsg"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"cfcaContractName"]) {
            NSString *cfcaContractName = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (cfcaContractName.length > 0) {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.secondSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"contractMsg"]) {
            NSArray *contractMsg = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (contractMsg.count > 0) {
                NSString *totalStr = [NSString stringWithFormat:@"本人已阅读并同意签署"];
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [contractMsg objectAtIndex:i];
                    totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
                }
                selfWeak.contractMsgLabel.text = totalStr;
                //                __weak typeof(self) weakSelf = self;
                for (int i = 0; i < contractMsg.count; i++) {
                    NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[contractMsg objectAtIndex:i]];
                    [selfWeak.contractMsgLabel setFontColor:[Color color:PGColorOptionCellContentBlue] range:[totalStr rangeOfString:tmpStr] lineSpace:5];
                    
                    [selfWeak.contractMsgLabel addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
//                        NSLog(@"111");
                        [selfWeak totalString:linkModel.linkString];
                    }];
                    
                }

                [selfWeak.contractMsgLabel sizeToFit];
                selfWeak.fourSectionView.myVisibility = MyVisibility_Visible;
                
            } else {
                selfWeak.fourSectionView.myVisibility = MyVisibility_Gone;
            }
        } else if ([keyPath isEqualToString:@"isShowRisk"]) {
            BOOL isShowRisk = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isShowRisk) {
                selfWeak.thirdSectionView.myVisibility = MyVisibility_Visible;
            } else {
                selfWeak.thirdSectionView.myVisibility = MyVisibility_Gone;
            }
        }
    }];
}
- (void)totalString:(NSString *)constractName
{
    constractName = [constractName stringByReplacingOccurrencesOfString:@"《" withString:@""];
    constractName = [constractName stringByReplacingOccurrencesOfString:@"》" withString:@""];
    if (self.myVM) {
        DDLogDebug(@"%@",constractName);
        [self.myVM bidViewModel:self.myVM WithContractName:constractName];
    }
    if (self.myTransVM) {
        DDLogDebug(@"%@",constractName);
        [self.myTransVM bidViewModel:self.myTransVM WithContractName:constractName];
    }
    if (self.myCollectionVM) {
        [self.myCollectionVM bidViewModel:self.myCollectionVM WithContractName:constractName];
        
        
    }
}
- (void)createAllShowView
{
    [self createSectionOne];
    [self createSectionTwo];
    [self createSectionThree];
    [self createSectionFour];
    [self createSectionsix];
}
- (void)createTransShowView
{
    [self createSectionTwo];
    [self createSectionThree];
    [self createSectionFour];
    [self createSectionSeven];
}
- (void)createCollectionView
{
    [self createSectionTwo];
    [self createSectionThree];
    [self createSectionFour];
    //下周一来了添加这两个的占位
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
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.firstSectionView addSubview:imageView];
    
    YYLabel *limitAmountMessLabel = [[YYLabel alloc] init];
//    limitAmountMessLabel.backgroundColor = [UIColor redColor];
    limitAmountMessLabel.font = [Color gc_Font:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    //不要删除，需要占位，要不数据反射回来 这个lab的frame 会变成0
    limitAmountMessLabel.text = @"经过风险评估，您本次出借金额上限为1000万";
    limitAmountMessLabel.centerYPos.equalTo(view.centerYPos).offset(1.5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    [self.firstSectionView addSubview:limitAmountMessLabel];
    self.limitAmountMessLabel = limitAmountMessLabel;
    [limitAmountMessLabel sizeToFit];
}
- (void)createSectionTwo
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.firstSectionView.bottomPos);
    view.wrapContentHeight = YES;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.secondSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 9;
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.secondSectionView addSubview:imageView];
    
    NSString *showStr = @"本人阅读并同意《CFCA数字证书服务协议》";
    
    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.bottomPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.textColor = [Color color:PGColorOptionTitleGray];
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [self.secondSectionView addSubview:limitAmountMessLabel];
    [limitAmountMessLabel sizeToFit];

    limitAmountMessLabel.userInteractionEnabled = YES;
    [limitAmountMessLabel setFontColor:[Color color:PGColorOptionCellContentBlue] range:[showStr rangeOfString:@"《CFCA数字证书服务协议》"]];
    __weak typeof(self) weakSelf = self;
    [limitAmountMessLabel addLinkString:@"《CFCA数字证书服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf totalString:linkModel.linkString];
    }];

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
    imageView.myTop = 9;
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.thirdSectionView addSubview:imageView];
   
    NSString *showStr = @"本人阅读并悉知《网络借贷出借风险及禁止性行为提示》中风险";;

    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.textColor = [Color color:PGColorOptionTitleGray];
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [limitAmountMessLabel sizeToFit];
    limitAmountMessLabel.bottomPos.equalTo(self.bottomPos).offset(5);
    limitAmountMessLabel.userInteractionEnabled = YES;
    [limitAmountMessLabel setFontColor:[Color color:PGColorOptionCellContentBlue] range:[showStr rangeOfString:@"《网络借贷出借风险及禁止性行为提示》"] lineSpace:5];
    __weak typeof(self) weakSelf = self;
    [limitAmountMessLabel addLinkString:@"《网络借贷出借风险及禁止性行为提示》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf totalString:linkModel.linkString];
    }];
    [self.thirdSectionView addSubview:limitAmountMessLabel];

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
    imageView.myTop = 9;
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.fourSectionView addSubview:imageView];
    
    NSString *showStr = @"本人已阅读并同意签署";;
    
    NZLabel *limitAmountMessLabel = [[NZLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.text = showStr;
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    limitAmountMessLabel.rightPos.equalTo(self.rightPos).offset(15);
    limitAmountMessLabel.bottomPos.equalTo(self.bottomPos).offset(5);
    limitAmountMessLabel.textColor = [Color color:PGColorOptionTitleGray];
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [limitAmountMessLabel sizeToFit];
    limitAmountMessLabel.userInteractionEnabled = YES;
    self.contractMsgLabel = limitAmountMessLabel;
    [self.fourSectionView addSubview:limitAmountMessLabel];
}



- (void)createSectionsix
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.fourSectionView.bottomPos);
    view.wrapContentHeight = YES;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.sixSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 9;
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.sixSectionView addSubview:imageView];
    
    YYLabel *limitAmountMessLabel = [[YYLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 -15;
    //不要删除，需要占位，要不数据反射回来 这个lab的frame 会变成0
    limitAmountMessLabel.text = @"本人接受筹标期内资金不计利息，出借意向不可撤销";
    limitAmountMessLabel.textColor = [Color color:PGColorOptionTitleGray];
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.bottomPos.equalTo(@5);
    limitAmountMessLabel.rightPos.equalTo(@15);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    [self.sixSectionView addSubview:limitAmountMessLabel];
    [limitAmountMessLabel sizeToFit];
}
- (void)createSectionSeven
{
    UIView *view = [MyRelativeLayout new];
    view.backgroundColor = [UIColor clearColor];
    view.topPos.equalTo(self.fourSectionView.bottomPos);
    view.wrapContentHeight = YES;
    view.myHorzMargin = 0;
    [self addSubview:view];
    self.sevenSectionView = view;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.myLeading = 15;
    imageView.myTop = 9;
    imageView.mySize = CGSizeMake(8, 8);
    imageView.image = [UIImage imageNamed:@"point.png"];
    [self.sevenSectionView addSubview:imageView];
    
    YYLabel *limitAmountMessLabel = [[YYLabel alloc] init];
    limitAmountMessLabel.font = [UIFont systemFontOfSize:14.0f];
    limitAmountMessLabel.numberOfLines = 0;
    limitAmountMessLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 -15;
    //不要删除，需要占位，要不数据反射回来 这个lab的frame 会变成0
    limitAmountMessLabel.text = @"单笔尊享项目仅支持一对一转让，不支持部分购买";
    limitAmountMessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitAmountMessLabel.wrapContentHeight = YES;   //高度自动计算。
    limitAmountMessLabel.textColor = [Color color:PGColorOptionTitleGray];
    limitAmountMessLabel.topPos.equalTo(@5);
    limitAmountMessLabel.bottomPos.equalTo(@5);
    limitAmountMessLabel.rightPos.equalTo(@15);
    limitAmountMessLabel.leftPos.equalTo(imageView.leftPos).offset(15);
    [self.sevenSectionView addSubview:limitAmountMessLabel];
    [limitAmountMessLabel sizeToFit];
}
@end
