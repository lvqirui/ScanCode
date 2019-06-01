//
//  Pixel_s.h
//  leyouShop
//
//  Created by lvqirui on 16/6/17.
//  Copyright © 2016年 lvqirui.com. All rights reserved.
//
#define kPixelZero 0.0 //零
#define kPixelLine 0.5 //线不做适配
#define kPixelLine_2Px 1 //线不做适配
#define kPixelLine_4Px 2 //线不做适配

#define kPixel_4px 2.0
#define kPixel_6px 3.0
#define kPixel_7px 3.5
#define kPixel_8px 4.0
#define kPixel_10px 5.0
#define kPixel_12px 6.0
#define kPixel_13px 6.5
#define kPixel_16px 8.0
#define kPixel_20px 10.0
#define kPixel_22px 11.0
#define kPixel_23px 11.5
#define kPixel_24px 12.0
#define kPixel_26px 13.0
#define kPixel_28px 14.0
#define kPixel_30px 15.0
#define kPixel_32px 16.0
#define kPixel_34px 17.0
#define kPixel_35px 17.5
#define kPixel_36px 18.0
#define kPixel_38px 19.0
#define kPixel_40px 20.0
#define kPixel_44px 22.0
#define kPixel_45px 22.5
#define kPixel_46px 23.0
#define kPixel_47px 23.5
#define kPixel_48px 24.0
#define kPixel_50px 25.0
#define kPixel_58px 29.0
#define kPixel_60px 30.0
#define kPixel_68px 34.0
#define kPixel_70px 35.0
#define kPixel_74px 37.0
#define kPixel_80px 40.0
#define kPixel_82px 41.0
#define kPixel_88px 44.0
#define kPixel_90px 45.0
#define kPixel_100px 50.0
#define kPixel_105px 52.5
#define kPixel_108px 54.0
#define kPixel_110px 55.0
#define kPixel_120px 60.0
#define kPixel_122px 61.0
#define kPixel_124px 62.0
#define kPixel_136px 68.0
#define kPixel_152px 76.0
#define kPixel_160px 80.0
#define kPixel_162px 81.0
#define kPixel_168px 84.0
#define kPixel_174px 87.0
#define kPixel_175px 87.5
#define kPixel_180px 90.0
#define kPixel_190px 95.0
#define kPixel_200px 100.0
#define kPixel_220px 110.0
#define kPixel_208px 104.0
#define kPixel_270px 135.0
#define kPixel_300px 150.0
#define kPixel_344px 172.0
#define kPixel_500px 250.0
#define kPixel_750px 375.0

//自动适配宽度
#define kAutoWidthPixel_4px 2.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_6px 3.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_7px 3.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_8px 4.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_10px 5.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_12px 6.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_13px 6.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_16px 8.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_20px 10.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_22px 11.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_23px 11.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_24px 12.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_26px 13.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_27px 13.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_28px 14.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_30px 15.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_32px 16.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_33px 16.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_34px 17.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_35px 17.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_36px 18.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_38px 19.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_40px 20.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_44px 22.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_45px 22.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_46px 23.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_47px 23.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_48px 24.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_50px 25.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_52px 26.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_58px 29.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_60px 30.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_63px 31.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_68px 34.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_70px 35.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_72px 36.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_80px 40.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_82px 41.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_88px 44.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_90px 45.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_94px 47.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_100px 50.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_105px 52.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_108px 54.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_110px 55.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_120px 60.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_122px 61.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_124px 62.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_136px 68.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_144px 72.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_152px 76.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_160px 80.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_162px 81.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_168px 84.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_170px 85.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_174px 87.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_175px 87.5 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_176px 88.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_180px 90.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_190px 95.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_194px 97.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_200px 100.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_208px 104.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_220px 110.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_240px 120.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_264px 132.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_270px 135.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_300px 150.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_344px 172.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_500px 250.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_530px 265.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)
#define kAutoWidthPixel_750px 375.0 * (([[UIScreen mainScreen] bounds].size.width)/kPixel_750px)


#define kWord_Font_AutoWidth_48px                [UIFont systemFontOfSize:kAutoWidthPixel_48px]
#define kWord_Font_AutoWidth_42px                [UIFont systemFontOfSize:kAutoWidthPixel_42px]
#define kWord_Font_AutoWidth_40px                [UIFont systemFontOfSize:kAutoWidthPixel_40px]
#define kWord_Font_AutoWidth_36px                [UIFont systemFontOfSize:kAutoWidthPixel_36px]
#define kWord_Font_AutoWidth_34px                [UIFont systemFontOfSize:kAutoWidthPixel_34px]
#define kWord_Font_AutoWidth_33px                [UIFont systemFontOfSize:kAutoWidthPixel_33px]
#define kWord_Font_AutoWidth_32px                [UIFont systemFontOfSize:kAutoWidthPixel_32px]
#define kWord_Font_AutoWidth_30px                [UIFont systemFontOfSize:kAutoWidthPixel_30px]
#define kWord_Font_AutoWidth_28px                [UIFont systemFontOfSize:kAutoWidthPixel_28px]
#define kWord_Font_AutoWidth_26px                [UIFont systemFontOfSize:kAutoWidthPixel_26px]
#define kWord_Font_AutoWidth_24px                [UIFont systemFontOfSize:kAutoWidthPixel_24px]
#define kWord_Font_AutoWidth_22px                [UIFont systemFontOfSize:kAutoWidthPixel_22px]
#define kWord_Font_AutoWidth_20px                [UIFont systemFontOfSize:kAutoWidthPixel_20px]


#ifndef SatueBarHeight
#define SatueBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#endif

#ifndef kiOS8_10
#define kiOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#endif

#ifndef kiOS10Later
#define kiOS10Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#endif

#ifndef NavigationBarHeight
#define NavigationBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#endif

#define DGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

//#endif /* Pixel_s_h */
