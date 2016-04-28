//
//  YLViewController.m
//  YLUtilityDemos
//
//  Created by yilin on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "YLViewController.h"
#import "QREncoding.h"

@interface YLViewController ()

@end

@implementation YLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatQRCode_2016_4_27];
    
}

- (void)testBoundingRectWithSizeMethods_2016_3_27
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

- (void)testNSDictionary_2016_4_3
{
    NSDictionary *dicOne = [NSDictionary dictionaryWithObject: @"hello"  forKey:@"key"];
    NSString *dicOneValue = dicOne[@"key"];
    
    NSDictionary *dicTwo = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Kate", @"name",
                         @"080-123-456", @"tel",
                         @"東京都", @"address",nil];
    
    NSArray *key = [NSArray arrayWithObjects:@"name", @"tel", @"address", nil];
    NSArray *value = [NSArray arrayWithObjects:@"Kate", @"080-123-456", @"中国", nil];
    NSDictionary *dicThree = [NSDictionary dictionaryWithObjects:value
                                                         forKeys:key];
    int count = [dicThree count];
    NSArray *allKey = [dicThree allKeys];
    NSArray *allValue = [dicThree allValues];
    BOOL isEqual = [dicThree isEqualToDictionary:dicTwo]; //两个字典是否相等
    //遍历
    for(NSString *key in dicThree)
    {
        NSLog(@"key:%@ value:%@",key,dicThree[key]);
    }
    
    NSDictionary *dictFour = @{@"name":@"Kate", @"tel":@"080-123-456",@"address":@"中国"};
    [dictFour enumerateKeysAndObjectsUsingBlock:^(id  key, id  obj, BOOL *  stop) {
        NSLog(@"key:%@ value:%@",key,obj);
    }];
    
    //NSMutableDictionary 简单使用
    NSMutableDictionary *dictFive = [NSMutableDictionary dictionary];
    //像字典中追加一个新的 key5 和 value5
    [dictFive setObject:@"value5" forKey:@"key5"];
    [dictFive addEntriesFromDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    //将字典5的对象内容设置与字典1的对象内容相同
    [dictFive setDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    //删除键所对应的键值对
    [dictFive removeObjectForKey:@"name"];
    //修改key对应的value的值
    dictFive[@"address"] = @"beijing";
    //删除数组中的所有key 对应的键值对
    NSArray *array = @[@"tel",@"address",@"key3"];
    [dictFive removeObjectsForKeys:array];
    //移除字典中的所有对象
    [dictFive removeAllObjects];

}
- (void)creatQRCode_2016_4_27
{
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.5f), imageSize, imageSize)];
    //生成二维码图片
    imageView.image = [QREncoding createQRcodeForString:@"http://www.alipay.com" withSize:imageView.bounds.size.width withRed:255 green:0 blue:0];
    //添加中心图片
    UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifubao.png"]];
    centerImage.frame= CGRectMake(0, 0, 38.f, 38.f);
    centerImage.center = CGPointMake(CGRectGetWidth(imageView.frame)/2.f, CGRectGetHeight(imageView.frame)/2.f);
    [imageView addSubview:centerImage];
    [self.view addSubview:imageView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
