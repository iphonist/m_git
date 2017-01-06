//
//  CustomUIKit.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 벤치비. All rights reserved.
//

#import "CustomUIKit.h"



@implementation CustomUIKit


+ (UIButton *)buttonWithTitle:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor target:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedBullet:(NSString *)imageNamedBullet imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    
    // UIImage는 별다른 변경사항이 없다면 setBackgroundImage 속성으로 사용하는데
    // 이미지의 속성을 변경해야 하는 일이 생긴다면 변수를 선언하고 사용하는 것이 좋음. 향후 확장을 위해 변수를 사용
    UIImage *imageButtonNormal  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedNormal ofType:nil]];
    UIImage *imageButtonPressed = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedPressed ofType:nil]];
    //	UIImage *imageButtonBullet  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedBullet ofType:nil]];
    //    UIImage *imageButtonPressed = [CustomUIKit customImageNamed:imageNamedPressed];
    //    UIImage *imageButtonNormal = [CustomUIKit customImageNamed:imageNamedNormal];
    //     UIImage *imageButtonBullet = [CustomUIKit customImageNamed:imageNamedBullet];
    
    
    // 이미지는 Scale 에 맞게 Up Scale, Down Scale을 함. 리소스 줄이는데 사용
    // UIImage *newImage = [imageButton stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    // 정렬
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    
    // 버튼 글자 색상
    [button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [button setTitleColor:fontColor forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient, use a transparent color
    //	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    // 버튼 글자의 마진 조정. Bullet 여부에 따라 조정한다.
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(29.0f, 22.0f, 0.0f, 0.0f)];
    
    // 버튼 이미지 설정
    if (imageNamedNormal) [button setBackgroundImage:imageButtonNormal  forState:UIControlStateNormal];
    if (imageNamedPressed) [button setBackgroundImage:imageButtonPressed forState:UIControlStateHighlighted];
    
    // 버튼 눌린 경우 엑션 설정
    [button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    
    // bullet 추가
    //	if (imageNamedBullet) {
    //		NSInteger bx;
    //		UIImageView *imageView = [[UIImageView alloc] initWithImage:imageButtonBullet];
    //		CGSize size = [title sizeWithFont:fontSize];
    //
    //		// bx = (frame.size.width / 2 - (([title length] * fontSize) * 2.7) / 3);
    //		bx = ((frame.size.width - size.width) / 2 - 26); // icon 16px + margin 10px
    //
    //		if (bx < 0) bx = 5;
    //
    //		imageView.frame = CGRectMake(bx, frame.size.height / 3.5, 16, 16);
    //		[button addSubview:imageView];
    ////		[imageView release];
    //	}
    
    return button;
}

+ (UIButton *)buttonWithTarget:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *imageButtonNormal  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedNormal ofType:nil]];
    UIImage *imageButtonPressed = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedPressed ofType:nil]];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    
    
    [button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient,
    
    
    // 버튼 이미지 설정
    if (imageNamedNormal) [button setBackgroundImage:imageButtonNormal  forState:UIControlStateNormal];
    if (imageNamedPressed) [button setBackgroundImage:imageButtonPressed forState:UIControlStateHighlighted];
    
    // 버튼 눌린 경우 엑션 설정
    [button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return button;
}



+ (UILabel *)labelWithText:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.text = title;
    label.textAlignment = alignText; // NSTextAlignmentCenter;
    label.numberOfLines = numberOfLines;
    label.textColor = fontColor;
    [label setBackgroundColor:[UIColor clearColor]];
    //	[label setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]]; // Helvetica-Bold
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (UILabel *)labelWithText:(NSString *)title bold:(BOOL)bold fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.text = title;
    label.textAlignment = alignText; // NSTextAlignmentCenter;
    label.numberOfLines = numberOfLines;
    label.textColor = fontColor;
    [label setBackgroundColor:[UIColor clearColor]];
    //	[label setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]]; // Helvetica-Bold
    if(bold)
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    else
        label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}


+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg
{
    if([title length]<1)
        title = @"미래에셋증권FMC";//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
    [alert show];
    
}

+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg delegate:(UIViewController *)con tag:(int)t
{
    if([title length]<1)
        title = @"미래에셋증권FMC";//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:con
                                          cancelButtonTitle:@"아니오"
                                          otherButtonTitles:@"예", nil];
    alert.tag = t;
    [alert show];
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame keyboardType:(UIKeyboardType)ktype placeholder:(NSString *)placeholder text:(NSString *)text clearButtonMode:(UITextFieldViewMode)cmode
{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame]; // 180
    textField.keyboardType = ktype;
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeholder;
    textField.text = text;
    textField.clearButtonMode = cmode;
    
    return textField;
    
}


+ (UIImage *)customImageNamed:(NSString *)name
{
    UIImage *img;
    NSString *imagePath;
    
    imagePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    img = [UIImage imageWithContentsOfFile:imagePath];
    
    
    return img;
}

+ (void)customImageNamed:(NSString *)name block:(void(^)(UIImage *image))block
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //load image
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //cache the image
            //            [cache setObject:image forKey:path];
            
            //return the image
            block(image);
        });
    });
}

+ (UIImageView *) createImageViewWithOfFiles:(NSString *)imgName withFrame:(CGRect)frame
{
    UIImage *img;
    NSString *imagePath;
    UIImageView *imageView;
    
    imagePath = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
    img = [UIImage imageWithContentsOfFile:imagePath];
    imageView = [[UIImageView alloc] initWithImage:img];
    
    imageView.frame = frame;
    
    return imageView;
}



+ (UIButton *)backButtonWithTitle:(NSString *)num target:(id)target selector:(SEL)selector{
    
    NSLog(@"setBackButton %@",num);
    
    NSString *back;
    
    
    back = @"";
    
    CGSize size = [back sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"size.width %f",size.width);
    
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.frame = CGRectMake(0, 0, 10, 18);
    
    UIImage *backImage = [CustomUIKit customImageNamed:@"barbutton_navigtaionbar_back.png"];//[[CustomUIKit customImageNamed:@"barbutton_navigtaionbar_back.png"]stretchableImageWithLeftCapWidth:32-3 topCapHeight:0];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = backImageView.frame;
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    //    UILabel *label = [[UILabel alloc]init];
    //    label.textColor = RGB(41,41,41);//[UIColor whiteColor];
    ////    label.shadowOffset = CGSizeMake(0, -1);
    ////    label.shadowColor = [UIColor darkGrayColor];
    //    label.numberOfLines = 0;
    //    label.lineBreakMode = UILineBreakModeWordWrap;
    //    label.font = [UIFont boldSystemFontOfSize:15];
    //    label.frame = CGRectMake(28,6,size.width,size.height);
    //    label.text = back;
    //    label.backgroundColor = [UIColor clearColor];
    //    [button addSubview:label];
    
    return button;
}

+ (UIButton *)emptyButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return button;
}

@end
