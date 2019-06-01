//
//  LQRManualCodeView.h
//  LeyouGuide
//
//  Created by lvqirui on 2018/3/2.
//  Copyright © 2018年 lvqirui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LQRManualCodeViewDelegate

//切换到扫码
-(void)switchToScanCodeViewBtnClick;
//手动输入码信息查询
-(void)fetchInfoForCode:(NSString *)code;

@end

@interface LQRManualCodeView : UIView

@property (nonatomic,weak) id<LQRManualCodeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
