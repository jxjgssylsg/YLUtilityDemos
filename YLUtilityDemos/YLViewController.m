//
//  ViewController.m
//  YLUtilityDemos
//
//  Created by mingdffe on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "YLViewController.h"

@interface YLViewController ()

//方法1:测试boundingRectWithSize方法
- (void)testBoundingRectWithSizeMethods;

@end

@implementation YLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testBoundingRectWithSizeMethods];
    
}

- (void)testBoundingRectWithSizeMethods
{
    
    UILabel *lbTemp =[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 700)];
    lbTemp.backgroundColor = [UIColor brownColor];
    lbTemp.lineBreakMode =  NSLineBreakByCharWrapping;
    lbTemp.numberOfLines = 0;
    lbTemp.text = @"天天\n上课,还挂科,是在是蛋疼.....希望这个地球更加美丽漂亮,随便写些东西都不是容易的事情啊";
    NSRange allRange = [lbTemp.text rangeOfString:lbTemp.text];
    [self.view addSubview:lbTemp];
    
    
    NSMutableParagraphStyle *tempParagraph = [[NSMutableParagraphStyle alloc] init];
    tempParagraph.lineSpacing = 20;
    tempParagraph.firstLineHeadIndent = 20.f;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:lbTemp.text];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:tempParagraph} range:allRange];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    lbTemp.frame = CGRectMake(50, 50, rect.size.width, rect.size.height);
    lbTemp.attributedText = attrStr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
