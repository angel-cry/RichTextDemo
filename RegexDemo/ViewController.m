//
//  ViewController.m
//  RegexDemo
//
//  Created by majian on 15/10/15.
//  Copyright © 2015年 majian. All rights reserved.
//

#import "ViewController.h"
#define KGifts @[@"[哈哈]",@"[hehe]"]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString * originString = @"哪个混蛋把我的跳绳剪的那么短！！！<img src='[喵喵].png'> <img src='[doge].png'> <img src='[喵喵].png'> <img src='[doge].png'> <img src='[喵喵].png'> <img src='[doge].png'> <img src='[doge].png'> <img src='[doge].png'> <img src='[喵喵].png'> <img src='[喵喵].png'> <img src='[ali僵尸跳].png'><img src='[ali微博益起来]'>";
    NSMutableAttributedString * attStr = [self stringToAttibuteString2:originString];
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    lbl.numberOfLines = 0;
    lbl.attributedText = attStr;
    [self.view addSubview:lbl];
}

- (NSMutableAttributedString *)stringToAttibuteString2:(NSString *)str2 {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:str2];
    NSString * zhengze = @"<[\\u4e00-\\u9fa5a-zA-Z0-9 .'’\\[\\]=]+>";
    NSRegularExpression * reEx = [NSRegularExpression regularExpressionWithPattern:zhengze options:0 error:nil];
    NSArray * resArrayI = [reEx matchesInString:str2 options:0 range:NSMakeRange(0, str2.length)];
    
    for (int index = (int)(resArrayI.count - 1); index >= 0; index--) {
        NSTextCheckingResult * res = resArrayI[index];
        NSString *text = [str2 substringWithRange:res.range];
        NSString * zhengze2 = @"<[a-z]+";
        NSRegularExpression * reEx2 = [NSRegularExpression regularExpressionWithPattern:zhengze2 options:0 error:nil];
        NSArray * subResArrayI = [reEx2 matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        NSTextCheckingResult * res2 = [subResArrayI firstObject];
        NSString * className = [text substringWithRange:res2.range];
        if ([className isEqualToString:@"<img"]) {
            NSString * imgZhengze = @"'[\\[\\u4e00-\\u9fa5a-z\\].]+'"; //src='[a-z.\[\]]+'
            NSRegularExpression * imgReEX = [NSRegularExpression regularExpressionWithPattern:imgZhengze options:0 error:nil];
            NSArray * imgResArrayI = [imgReEX matchesInString:text options:0 range:NSMakeRange(0, text.length)];
            if (nil != imgResArrayI && imgResArrayI.count > 0) {
                NSTextCheckingResult * imgSrcCheckingRes = [imgResArrayI firstObject];
                NSString * imgNameTemp = [text substringWithRange:imgSrcCheckingRes.range];
                NSString * imgName = [imgNameTemp substringWithRange:NSMakeRange(1, imgNameTemp.length - 2)];
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:imgName];
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //替换图片附件
                [attributeString replaceCharactersInRange:res.range
                                     withAttributedString:imageStr];
            }
        }
    }
    
    return attributeString;
}


- (NSMutableAttributedString *)stringToAttributeString:(NSString *)text {
    //先把普通的字符串text转化生成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:text];
    //正则表达式，例如[呵呵]这种形式的通配符
    NSString * zhengze = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError * error;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //遍历字符串，获得所有的匹配字符串
    NSArray * arr = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
     NSArray * imageNameArrayI = KGifts;
    for (int index = (int)(arr.count - 1); index >= 0;index--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[index];
        NSString * textR = [text substringWithRange:result.range];
        if ([imageNameArrayI containsObject:textR]) {
            //添加附件、图片
            NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:textR];
            NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
            //替换图片附件
            [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];
        }
    }
    
    return attStr;
}

@end























