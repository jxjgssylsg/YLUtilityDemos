
# YLUtilityDemos  for  iOS

**This Repo 是 iOS 学习开发中经常需要用到的 Demo,希望由浅入深的 Demo 能够将基本的原理和常用方法讲清楚. Demo 源于自己编写或网络学习整理**

### 欢迎参与或讨论, 互助成长.
-----------

#使用方式
**使用方式:**

1. 在`YLViewController.h`中搜索你需要的找的 Demo 的关键字,找到这个方法的序号就行了.
2. 在`YLViewController.m`的 'viewDidLoad' 中调用这个方法便可以了.

##原则:  

- **Demo 应具有隔离性,保证学习和使用简单,描述原理，方便学习和扩展使用.**    
  如果 Demo 涉及内容较少的话就不要创建新的文件了,直接在`YLViewController.h`声明一个方法,在`YLViewController.m`完成后,  
  可以在`YLViewController.m`的`viewDidLoad`方法中调用.结构保持清晰.    
  **例如**:写一个关于`testBoundingRectWithSizeMethods`方法使用的 Demo,设计内容较小,不需要新建文件和类.   
 **具体操作步骤:**  
 **1.在YLViewController.h加入一个方法,写上方法序号.如:** 
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    [self testBoundingRectWithSizeMethods];
}
```

 **2.在 `YLViewController.m` 实现- (void)testBoundingRectWithSizeMethods 方法,如:**  
```objective-c
- (void)testBoundingRectWithSizeMethods {
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

``` 
 **3.最后可以在 viewDidLoad 方法中调用就是一个方法的 Demo 了.**

* 如果 Demo 涉及内容较多,需要新建文件和类,遵守如下规则    
    * 根据 Demo 需要的文件和类放在相对应的文件夹中.保持目录清晰
    * 同样也是在 `YLViewController.h` 中声明一个方法,在 `YLViewController.m` 实现调用其他文件,参照项目中的`方法3`
 
>**NOTE:**参照项目方法 1 和方法 3.☺   

# 方法目录

- 方法1:`boundingRectWithSize`1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle属性,例如字体行间距,首行缩进
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_1.png)
- 方法2:简单使用`NSDictionary`和`NSMutableDictionary`, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_2.png)
- 方法3:二维码制作,根据给定的字符串 (`two-dimension code,QR Code`)
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_3.png)
- 方法4:制作基本的一个月的日历,可以自行扩展和修改 (`calendar`)
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_4.png)
- 方法5:`NSDate`常用的方法集合,建议断点调试着看
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_5.png)  
- 方法6:`NSTimeZone`常用的方法集合,建议断点调试着看
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_6.png)  
- 方法7:`NSLocale`常用的方法集合,建议断点调试着看
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_7.png)  
- 方法8:`NSDateFormatter`常用的方法集合
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_8.png) 
- 方法9:`NSDateComponents`常用的方法集合
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_9.png)
- 方法10:`NSCalendar`常用的方法集合, 可以参考方法4:制作简单的一个月的日历
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_10.png)
- 方法11:最基本的 `UITableView`,展示最基本的原理,如 `UITableViewDataSource`, `UITableViewDelegate`
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_11.png)
- 方法12:`UITableView` 基本功能:增加,删除,排序,点击等
       [效果图](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/method_12.gif)
