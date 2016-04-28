 
# YLUtilityDemos  for  ios

**这个repo是做ios开发中经常需要用到的demo,可以是方法,第三方库,或者任何您觉得有益他人开发的.主要是方便我们开发过程中节省找Demo的时间,能够更高效的开发以及更好的理解所需要的东西**

### 欢迎大家共同参与到Demo库的建设当中!方便更多的人,节省更多的时间,掌握更多的东西.
-----------

#使用方式
**使用方式非常简单**

1. 在`YLViewController.h`中搜索你需要的找的Demo的关键字,找到这个方法的序号就行了.
2. 在`YLViewController.m`的'viewDidLoad'中调用这个方法便可以了.

##共同开发原则:  

- **Demo必须具有隔离性,保证结构和使用简单.尽量不用到第三方库,保证demo的纯洁性,方便他人学习和扩展使用.**    
  方法的demo涉及内容较少的话就不要创建新的文件了,直接在`YLViewController.h`声明一个方法,在`YLViewController.m`完成后,  
  可以在`YLViewController.m`的`viewDidLoad`方法中调用.结构保持非常清晰.    
  **例如**:写一个关于`testBoundingRectWithSizeMethods_2016_3_27`方法使用的Demo,设计内容较小,不需要新建文件和类.   
  **具体操作步骤:**  
>  **NOTE:**为方便使用者知道方法的修改或更新时间,同时也避免共同开发产生命名冲突, 采取特殊的在每一个方法最后**添加日期**,  
>  这个日期代表您`修改`,或者`添加`Demo的时间,您在项目中将会看到  

 **1.在YLViewController.h加入一个方法,写上方法序号.如图:** [地址](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/Introduction_01.png)
 ![建立一个方法](http://img.blog.csdn.net/20160422155914604)

 **2.在YLViewController.m 实现- (void)testBoundingRectWithSizeMethods 方法,如图:**  [地址](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/Introduction_02.png)
   ![实现方法](http://img.blog.csdn.net/20160422162531050)  
 
 **3.最后可以在viewDidLoad方法中调用就是一个方法的Demo了!如图:** [地址](https://raw.githubusercontent.com/jxjgssylsg/YLResources/master/Introduction_03.png)
    ![调用](http://img.blog.csdn.net/20160422163050552)

* 如果Demo涉及内容较多,需要新建文件和类,遵守如下规则    
    * 根据Demo需要的文件和类放在相对应的文件夹中.保持目录清晰
    * 同样也是在`YLViewController.h`中声明一个方法,在`YLViewController.m`实现调用其他文件,参照项目中的`方法3`
 
>**NOTE:**参照项目方法1和方法3,您将很容知道如何共同开发啦.☺   

# 方法目录

- 方法1:`boundingRectWithSize`Demo 1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle属性,例如字体行间距,首行缩进
- 方法2:简单使用`NSDictionary`和`NSMutableDictionary`, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看
