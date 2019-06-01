//
//  ViewController.m
//  ScanOrder
//
//  Created by 吕其瑞 on 2019/6/1.
//  Copyright © 2019年 吕其瑞. All rights reserved.
//

#import "ViewController.h"
#import "LQRHomeScanCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)scanQR:(id)sender {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                     dispatch_main_async_safe(^{
                         LQRHomeScanCodeController *scanCode = [[LQRHomeScanCodeController alloc] init];
                         [self.navigationController pushViewController:scanCode animated:YES];
                     });
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            //限制
        {
            [self showMessage];
        }
            break;
        case AVAuthorizationStatusDenied:
            //权限拒绝
        {
            [self showMessage];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            dispatch_main_async_safe(^{
                LQRHomeScanCodeController *scanCode = [[LQRHomeScanCodeController alloc] init];
                [self.navigationController pushViewController:scanCode animated:YES];
            });
        }
            break;
        default:
            break;
    }
    
}


-(void)showMessage
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}



@end
