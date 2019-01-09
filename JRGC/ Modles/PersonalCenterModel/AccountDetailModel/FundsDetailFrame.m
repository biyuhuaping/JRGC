//
//  FundsDetailFrame.m
//  JRGC
//
//  Created by NJW on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "FundsDetailFrame.h"
#import "FundsDetailModel.h"

// 标题背景的高度
#define UCFWaterNameHeight 44.0
// 分割线的高度
#define UCFLineHeight 0.5
// 昵称的字体
#define UCFContentFont [UIFont systemFontOfSize:12]

@implementation FundsDetailFrame

- (void)setFundsDetailModel:(FundsDetailModel *)fundsDetailModel
{
    _fundsDetailModel = fundsDetailModel;
    
    // 控件距屏幕边的距离
    CGFloat edgePadding = 15;
    // 控件的高度
    CGFloat height = 27.0;
    // 控件水平方向的间离
    CGFloat HPadding = 5;
    
    // 计算流水标题的frame
    CGFloat nameX = edgePadding;
    CGFloat nameY = 5.0;
    CGFloat nameW = ScreenWidth - edgePadding * 2;
    CGFloat nameH = height;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat listStartY = 38;
    // 计算金额及其title的frame
    CGSize standardSize = [self sizeWithText:@"冻结资金" font:UCFContentFont maxSize:CGSizeMake(MAXFLOAT, height)];
    
    CGFloat jineTitleX = edgePadding;
    CGFloat jineTitleY = listStartY;
    CGFloat jineTitleW = standardSize.width;
    CGFloat jineTitleH = height;
    _jinETitleF = CGRectMake(jineTitleX, jineTitleY, jineTitleW, jineTitleH);
    
    CGFloat jineX = CGRectGetMaxX(_jinETitleF) + HPadding;
    CGFloat jineY = jineTitleY;
    CGFloat jineW = ScreenWidth - edgePadding * 2 - HPadding - standardSize.width;
    CGFloat jineH = height;
    _jinEF = CGRectMake(jineX, jineY, jineW, jineH);
    
    // 计算冻结金额及其titile的frame
    CGFloat frozenJinETitleX = edgePadding;
    CGFloat frozenJinETitleY = CGRectGetMaxY(_jinETitleF) + 1;
    CGFloat frozenJinETitleW = standardSize.width;
    CGFloat frozenJinETitleH = height;
    _frozenJinETitleF = CGRectMake(frozenJinETitleX, frozenJinETitleY, frozenJinETitleW, frozenJinETitleH);
    
    CGFloat frozenJinEX = CGRectGetMaxX(_frozenJinETitleF) + HPadding;
    CGFloat frozenJinEY = frozenJinETitleY;
    CGFloat frozenJinEW = ScreenWidth - edgePadding * 2 - HPadding - frozenJinETitleW;
    CGFloat frozenJinEH = height;
    _frozenJinEF = CGRectMake(frozenJinEX, frozenJinEY, frozenJinEW, frozenJinEH);
    
    // 计算发生时间及其title的frame
    CGFloat happenTimeTitleX = edgePadding;
    CGFloat happenTimeTitleY = CGRectGetMaxY(_frozenJinETitleF) + 1;
    CGFloat happenTimeTitleW = standardSize.width;
    CGFloat happenTimeTitleH = height;
    _happendTimeTitleF = CGRectMake(happenTimeTitleX, happenTimeTitleY, happenTimeTitleW, happenTimeTitleH);
    
    CGFloat happenTimeX = CGRectGetMaxX(_happendTimeTitleF) + HPadding;
    CGFloat happenTimeY = happenTimeTitleY;
    CGFloat happenTimeW = ScreenWidth - edgePadding * 2 - HPadding - happenTimeTitleW;
    CGFloat happenTimeH = height;
    _happendTimeF = CGRectMake(happenTimeX, happenTimeY, happenTimeW, happenTimeH);
    
    // 计算备注及其title的frame
    CGSize markContentSize = [self sizeWithText:fundsDetailModel.remark font:UCFContentFont maxSize:CGSizeMake(200, MAXFLOAT)];
    
    CGFloat markTitleX = edgePadding;
    CGFloat markTitleY = CGRectGetMaxY(_happendTimeTitleF) + 1;
    CGFloat markTitleW = standardSize.width;
    CGFloat markTitleH = height;
    _markTitleF = CGRectMake(markTitleX, markTitleY, markTitleW, markTitleH);
    
    CGFloat markX = CGRectGetMaxX(_markTitleF) + HPadding;
    CGFloat markY = markTitleY;
    CGFloat markW = ScreenWidth - edgePadding * 2 - markTitleW - HPadding;
//    DDLogDebug(@"%d", (int)(markContentSize.height/height));
    CGFloat markH = (markContentSize.height > height) ? ((int)(markContentSize.height/height) * 15 + 20) : height;
    _markF = CGRectMake(markX, markY, markW, markH);
//    DDLogDebug(@"%@", NSStringFromCGRect(_markF));
    
    _cellHeight = CGRectGetMaxY(_markF) + HPadding *2;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
