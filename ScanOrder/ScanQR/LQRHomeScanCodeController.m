//
//  LQRHomeScanCodeController.m
//  LeyouGuide
//
//  Created by lvqirui on 2018/3/5.
//  Copyright © 2018年 lvqirui. All rights reserved.
//

#import "LQRHomeScanCodeController.h"
#import "UIView+SDAutoLayout.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "LQRManualCodeView.h"
#import "LQRMacro.h"
#import "YYKit.h"

#define kMargin kAutoWidthPixel_80px
#define kBorderW kAutoWidthPixel_144px
#define scanWindowH  (kScreenWidth - kMargin * 2)
#define scanWindowW  (kScreenWidth - kMargin * 2)

#define  COMETOZBARSCANVIEWCONTROLLERCOUNT @"ComeToZBarScanViewControllerCount"

@interface LQRHomeScanCodeController ()<UIAlertViewDelegate,UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LQRManualCodeViewDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;

@property (nonatomic,strong) UIView *containerView;//扫码容器视图
@property (nonatomic,strong) LQRManualCodeView *manualCodeView; //手动输入码视图
@property (nonatomic, assign) BOOL isScan;

@property (nonatomic,strong) UIView *netStatusView;
@property (nonatomic,strong) YYReachability *reachablity;

@property (nonatomic,strong) UIView *maskView;// 遮罩

@property (nonatomic,strong) UIBezierPath *originPath;
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@property (nonatomic,strong) UIImageView *scanImgView;
@property (nonatomic,strong) UIButton *flashBtn;
@property (nonatomic,strong) UIButton *manualCodeBtn;

@property (nonatomic,assign) BOOL scanCodeEnable;
@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation LQRHomeScanCodeController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_session) {
        [_session startRunning];
        [self resumeAnimation];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_session) {
        [_session stopRunning];
        if (self.flashBtn.selected == YES) {
            //闪光灯状态是打开的
            self.flashBtn.selected = NO;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8];
    self.title = @"扫一扫";
    self.view.clipsToBounds=YES;
    [self checkCameraAuth];//检查摄像头权限
    //1.相机遮罩
    [self setupMaskView];
    //2.扫描动画
    [self setupScanWindowView];
    //3.顶部导航
    [self setupNavView];
    dispatch_async(dispatch_get_main_queue(), ^{
        //4.初始化相机
        [self beginScanning];
        //5.开始动画
        [self resumeAnimation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
        //6.检测网络
        [self observeNetStatusChange];
    });
}


//检测网络
-(void)observeNetStatusChange
{
    
    self.reachablity = [YYReachability reachability];
    
    if (self.reachablity.status == YYReachabilityStatusNone) {
        self.netStatusView.hidden = NO;
        self.scanCodeEnable = NO;
    } else {
        self.netStatusView.hidden = YES;
        self.scanCodeEnable = YES;
    }
    
    
    __weak typeof(self) weakSelf = self;
    self.reachablity.notifyBlock = ^(YYReachability * _Nonnull reachability) {
        switch (reachability.status) {
            case YYReachabilityStatusNone:
            {
                weakSelf.netStatusView.hidden = NO;
                weakSelf.scanCodeEnable = NO;
            }
                break;
            default:
            {
                weakSelf.netStatusView.hidden = YES;
                weakSelf.scanCodeEnable = YES;
            }
                break;
        }
    };
}

- (BOOL)checkCameraAuth{
    if ([UIDevice systemVersion] > 8.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            [self showMessage:@"启动相机失败，请检查设备并开启权限"];
            return NO;
        }
    }
    return YES;
}
-(void)setupNavView{
    
    CGFloat btnW = kAutoWidthPixel_240px;
    CGFloat btnH = kAutoWidthPixel_72px;
    //1.相册
    
    UIView *btnView = [UIView new];
    btnView.frame = (CGRect){.size = CGSizeMake(32, 44)};
    
    UIButton * albumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [albumBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    albumBtn.frame = btnView.bounds;
    albumBtn.contentMode=UIViewContentModeScaleAspectFit;
    [albumBtn addTarget:self action:@selector(myAlbumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:albumBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    //2.闪光灯
    UIButton * flashBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"guide_light_on"] forState:UIControlStateNormal];
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"guide_light_off"] forState:UIControlStateSelected];
    flashBtn.contentMode=UIViewContentModeScaleAspectFit;
    [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    self.flashBtn = flashBtn;
    [self.containerView addSubview:flashBtn];
    
    flashBtn.sd_layout
    .widthIs(btnW)
    .heightIs(btnH)
    .rightSpaceToView(self.containerView, kAutoWidthPixel_94px)
    .topSpaceToView(self.scanWindow, kAutoWidthPixel_36px);
    
    //3.手输条码
    UIButton * manualCodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [manualCodeBtn setBackgroundImage:[UIImage imageNamed:@"guide_scan_input"] forState:UIControlStateNormal];
    manualCodeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [manualCodeBtn addTarget:self action:@selector(manualFillBarCode:) forControlEvents:UIControlEventTouchUpInside];
    self.manualCodeBtn = manualCodeBtn;
    [self.containerView addSubview:manualCodeBtn];
    
    manualCodeBtn.sd_layout
    .widthIs(btnW)
    .heightIs(btnH)
    .leftSpaceToView(self.containerView, kAutoWidthPixel_94px)
    .topSpaceToView(self.scanWindow, kAutoWidthPixel_36px);
    
}

//相机遮罩
- (void)setupMaskView
{
    //扫码容器视图
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerView];
    
    //创建一个View
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.6;
    self.maskView = maskView;
    [self.containerView addSubview:maskView];
    //贝塞尔曲线 画一个矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *rectBpath = [[UIBezierPath bezierPathWithRect:CGRectMake(kMargin, kBorderW +NavigationBarHeight, scanWindowW, scanWindowW-2)] bezierPathByReversingPath];
    [bpath appendPath:rectBpath];
    self.originPath = bpath;
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    self.maskLayer = shapeLayer;
    //添加图层蒙板
    maskView.layer.mask = shapeLayer;
    
}

- (void)setupScanWindowView
{
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW +SatueBarHeight+44, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    [self.containerView addSubview:_scanWindow];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code"]];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.frame = _scanWindow.bounds;
    self.scanImgView = backImageView;
    [_scanWindow addSubview:backImageView];

    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    
    UILabel * tipLabel = [[UILabel alloc]init];
    tipLabel.frame = CGRectMake(0, _scanWindow.frame.origin.y - kAutoWidthPixel_36px - kWord_Font_AutoWidth_28px.lineHeight, kScreenWidth, kWord_Font_AutoWidth_28px.lineHeight);
    tipLabel.text = @"将取景框对准二维码/条形码，即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 1;
    tipLabel.font = kWord_Font_AutoWidth_28px;
    tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel = tipLabel;
    [self.containerView addSubview:tipLabel];
    
    UIView *netStatusView = [[UIView alloc] initWithFrame:self.view.bounds];
    netStatusView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UILabel *netStatusLab = [[UILabel alloc] initWithFrame:self.scanWindow.frame];
    netStatusLab.font = kWord_Font_AutoWidth_30px;
    netStatusLab.textColor = [UIColor whiteColor];
    netStatusLab.text = @"当前网络不可用\n请检查网络设置";
    netStatusLab.numberOfLines = 0;
    netStatusLab.textAlignment = NSTextAlignmentCenter;
    [netStatusView addSubview:netStatusLab];
    netStatusView.hidden = YES;
    self.netStatusView = netStatusView;
    [self.view addSubview:netStatusView];
}

- (void)beginScanning
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    output.rectOfInterest = CGRectMake((kBorderW +NavigationBarHeight) / kScreenHeight, kMargin/kScreenWidth, scanWindowH / kScreenHeight, scanWindowW / kScreenWidth);
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    [_session startRunning];
    self.scanCodeEnable = YES;  //扫码功能可用
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (self.scanCodeEnable == NO) {
        return ;
    }
    
    if (metadataObjects.count>0) {
        [_session stopRunning];
        self.flashBtn.selected = NO;
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //查询订单详情
        [self fetchInfoForCode:metadataObject.stringValue];
    }
}

#pragma mark-> 我的相册
-(void)myAlbumBtnClick{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //4.转场动画
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        [self showMessage:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！"];
    }
    
}
#pragma mark-> imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        CIImage *img = [CIImage imageWithCGImage:image.CGImage];
        CGRect rect =  img.extent;
        if ((rect.size.width / rect.size.height) > 200 ||
            (rect.size.height / rect.size.width) > 200) {
            [self showMessage:@"该图片没有包含一个二维码"];
            return;
        }
        NSArray *features = [detector featuresInImage:img];
        
        if (features.count >=1) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //查询订单信息
             [self fetchInfoForCode:scannedResult];
        }
        else{
            [self showMessage:@"该图片没有包含一个二维码"];
        }
    }];
    
    
}
#pragma mark-> 闪光灯
-(void)openFlash:(UIButton*)button{
    
    NSLog(@"闪光灯");
    button.selected = !button.selected;
    if (button.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

#pragma mark-> 开关闪光灯
- (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                if ([UIDevice systemVersion] < 10.0) {
                    [device setFlashMode:AVCaptureFlashModeOn];
                } else {
                    [AVCapturePhotoSettings photoSettings].flashMode = AVCaptureFlashModeOn;
                }
                
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                if ([UIDevice systemVersion] < 10.0) {
                    [device setFlashMode:AVCaptureFlashModeOff];
                } else {
                    [AVCapturePhotoSettings photoSettings].flashMode = AVCaptureFlashModeOff;
                }
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark-> 切换到手动输入条形码
-(void)manualFillBarCode:(UIButton *)btn
{
    self.scanCodeEnable = NO;  //扫码不可用
    [self.scanNetImageView.layer removeAnimationForKey:@"translationAnimation"];
    
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *appendPath = [[UIBezierPath bezierPathWithRect: CGRectMake(kMargin, kBorderW +NavigationBarHeight, scanWindowW, 54)] bezierPathByReversingPath];
    [toPath appendPath:appendPath];
    self.maskLayer.path = toPath.CGPath;

    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id _Nullable)(self.originPath.CGPath);
    maskAnimation.toValue = (__bridge id _Nullable)(toPath.CGPath);
    maskAnimation.duration = 0.5;
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.maskLayer addAnimation:maskAnimation forKey:@"path"];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scanImgView.frame = CGRectMake(0, 0, self.scanImgView.frame.size.width, 54);
        self.scanWindow.frame = CGRectMake(self.scanWindow.frame.origin.x, self.scanWindow.frame.origin.y, self.scanImgView.frame.size.width, 54);
        [self.scanWindow updateLayout];
        
        self.flashBtn.alpha = 0;
        self.manualCodeBtn.alpha = 0;
        self.tipLabel.alpha = 0;
    } completion:^(BOOL finished) {
//        //手动输入条形码
        LQRManualCodeView *manualView = [[[NSBundle mainBundle] loadNibNamed:@"LQRManualCodeView" owner:nil options:nil] lastObject];
        manualView.frame = self.view.bounds;
        manualView.delegate = self;
        [self.view addSubview:manualView];
        self.manualCodeView = manualView;
        
        CALayer *layer = [CALayer layer];
        layer.frame = self.maskView.bounds;
        self.maskView.layer.mask = layer;
//        //隐藏扫码
//        self.containerView.hidden = YES;
        
    }];
}

#pragma protocol for LQRManualCodeView
//切换到图形扫码
-(void)switchToScanCodeViewBtnClick
{
    self.maskView.layer.mask = self.maskLayer;
    
    self.manualCodeView.hidden = YES;
    [self.manualCodeView removeFromSuperview];
    self.containerView.hidden = NO;
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id _Nullable)(self.maskLayer.path);
    maskAnimation.toValue = (__bridge id _Nullable)(self.originPath.CGPath);
    maskAnimation.duration = 0.5;
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.maskLayer addAnimation:maskAnimation forKey:@"path"];
    self.maskLayer.path = self.originPath.CGPath;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scanImgView.frame = CGRectMake(0, 0, scanWindowW, scanWindowH);
        self.scanWindow.frame = CGRectMake(kMargin, kBorderW +SatueBarHeight+44, scanWindowW, scanWindowH);
        [self.scanWindow updateLayout];
        
        self.flashBtn.alpha = 1;
        self.manualCodeBtn.alpha = 1;
        self.tipLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self resumeAnimation];
        self.scanCodeEnable = YES;
    }];
    
}

//查询订单
-(void)fetchInfoForCode:(NSString *)code
{
    [self showMessage:[NSString stringWithFormat:@"条码*******%@",code]];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowHeight = self.view.width_sd - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.width_sd;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowHeight);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
}

#pragma mark -- UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            [_session startRunning];
//            break;
//
//        default:
//            break;
//    }
//}

-(void)showMessage:(NSString *)message
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_session startRunning];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
