### **Welcome to the YLUtilityDemos wiki!**
# YLUtilityDemos
**这个repo主要是测试所需要用到的方法和一些demo.主要是方便找demo以及想知道一些方法是怎么使用的同学,一个方法或者一个Demo必须具有隔离性,尽量不用到第三方库,保证demo的纯洁性.方便学习也方便自己使用扩展.**

### 欢迎大家共同参与到Demo库的建设当中!方便更多的人,节省更多的时间,掌握更多的东西!

##原则:

- ### 尽量保证结构和使用简单!   
方法的demo体量较小的话就尽量不要创建新的文件了,直接写在YLViewController.h暴露一个方法,相当于一个开关,写完之后可     以在YLViewController.m的viewDidLoad方法中调用.结构保持非常清晰.  
**例如**:写一个关于boundingRectWithSize方法使用的Demo,体量比较小,不需要新建文件和类.   
**具体操作步骤:**  
 **1.在YLViewController.h加入一个方法,写上方法序号.如图:**
 ![建立一个方法](http://img.blog.csdn.net/20160422155914604)

 **2.在YLViewController.m 实现- (void)testBoundingRectWithSizeMethods 方法,如图:**  
   ![实现方法](http://img.blog.csdn.net/20160422162531050)  
 
 **3.最后可以在viewDidLoad方法中调用就是一个方法的Demo了!如图:** 
    ![调用](http://img.blog.csdn.net/20160422163050552)

- ### 如果Demo体量比较大,需要新建文件和类,遵守如下规则   

***

###方法1:boundingRectWithSize Demo 1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle属性,例如字体行间距,首行缩进

###方法2:简单使用NSDictionary和NSMutableDictionary, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看


##方法3:二维码制作,根据给定的字符串生成二维码和中心位置图片,颜色可调
