//
//  LQRManualCodeView.m
//  LeyouGuide
//
//  Created by lvqirui on 2018/3/2.
//  Copyright © 2018年 lvqirui. All rights reserved.
//

#import "LQRManualCodeView.h"
#import "LQRMacro.h"
@interface LQRManualCodeView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTFTopConstraint;
@end

@implementation LQRManualCodeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.codeTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.codeTFTopConstraint.constant = kAutoWidthPixel_144px+SatueBarHeight+44;
}

-(void)textFieldChanged:(NSNotification *)noti
{
    if (self.codeTF.text.length > 0) {
        self.sureBtn.enabled = YES;
    } else {
        self.sureBtn.enabled = NO;
    }
}

- (IBAction)switchToScanCodeView:(id)sender {
    //返回到扫码
    [self.delegate switchToScanCodeViewBtnClick];
}

//根据条形码信息查询订单信息
- (IBAction)searchBarCodeBtnClick:(id)sender {
    //移除字符串中的空字符
    NSString *code = [self.codeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.delegate fetchInfoForCode:code];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
