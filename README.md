# GuidePage
iOS自定义封装控件之引导页
---
###需求分析

滚动的图片 + 指示器 + 最后一页提示按钮(进入)
效果图：

![guide.gif](http://upload-images.jianshu.io/upload_images/1658521-0ced862b70731a67.gif?imageMogr2/auto-orient/strip)

###实现形式
####1.简单粗暴式 使用storyboard ：
<1>设置好`UIScrollView` + `UIImageView` + `UIPageControl` + `UIButton`相应的位置和内容即可。
<2>连线实现`UIScrollView`代理中`scrollViewDidScroll`方法，滚动过程中切换`pageContro`l的当前页。
使用纯代码:与使用`storyboard`的实现方式一样，采用采用代码方式进行处理
#####缺点:开发每一个App的引导页都需要进行类似的操作，根据需要的页数得重新进行相关代码的调整
####2.可复用性高
使用UICollectionView实现类似于‘图片轮播器’、‘图片浏览器’，系统已经帮我们处理好了cell的重用机制，所有使用起来也是很方便的事情。
#####优点: 一句代码即可调用，传入对应的图片数量，并在回调里面设置图片以及按钮的`title`、` titleColor`

###你需要哪些控件
 
 
![控件](http://upload-images.jianshu.io/upload_images/1658521-bb1d50418edd17bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###开始码代码
#####细心的孩子可能发现系统的头文件属性的声明都是保持一种风格，为此本人属性声明也是模仿系统的风格
1.首先新建`HHGuidePageViewController:UIViewController`,用`HHGuidePageViewController`来实现引导页。
2.然后添加三个属性`collectionView`、`pageControl`、`count`.
3.紧接着新建一个`HHGuidePageCell：UICollectionViewCell`，根据需求可知`cell`只需要设置2个属性即可（`imageView`和`finishBtn`）.
4.最后我们在`HHGuidePageViewController`自定义的初始化方法中添加控件，注册`cell`

HHGuidePageViewController中的初始化
```
/**
 初始化方法
 @param count 图片总数量
 @param setupCellHandler cell的回调 回调参数cell indexPath
 @param finishBtnHandler 最后一个按钮的回调
 @return self
 */
-(instancetype)initWithPagesCount:(NSInteger)count 
setupCellHandler:(setupCellHandler)setupCellHandler 
finishHandler:(finishButtonHandler)finishBtnHandler{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _count = count;
        _setupCellHandler =[setupCellHandler copy];
        _finishBtnHandller =[finishBtnHandler copy];
        //使用懒加载初始化
        [self.view addSubview: self.collectionView];
        [self.view addSubview:self.pageControl];
        //注册cell
        [self.collectionView registerClass:[HHGuidePageCell class] 
        forCellWithReuseIdentifier:GuidePageCellID];
    }
    return self;

}
```

---
  利用懒加载的方式初始化`collectionView`和`pageControl`设置一些基本属性以及`frame`,懒加载这里不展示具体代码，详情请下载查看具体代码。并且实现两个必须要实现的数据源方法，需要注意的是在`cellForItemAtIndexPath`中在显示`cell`的时候我们需要加个判断，是否显示按钮。

```
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView 
cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HHGuidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
GuidePageCellID  forIndexPath:indexPath];
    if (indexPath.row == self.count -1) {//如果是最后一页，则添加响应事件
        cell.finishBtn.hidden = NO;
        [cell.finishBtn addTarget:self action:@selector(finishBtnOnClick:) 
       forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.finishBtn.hidden = YES;
    }
    if (self.setupCellHandler) { 
        self.setupCellHandler(cell,indexPath);
    }
    return cell;

}
```

---
   接着实现`UIScrollView`代理中的`scrollViewDidScroll`方法，来更改`pageControl`的当前页码
```
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    if (self.pageControl.currentPage != currentPage) {
        self.pageControl.currentPage = currentPage;
    }
}
```
---
最后在AppDelegate代理方法中didFinishLaunchingWithOptions调用

```
 if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstStart"];
        
        HHGuidePageViewController *guidePageVc = [[HHGuidePageViewController alloc]
initWithPagesCount:3 setupCellHandler:^(HHGuidePageCell *cell, NSIndexPath *idnexPath) {
            NSString *imageNames =[NSString stringWithFormat:@"intro_%zd",idnexPath.row];
            cell.imageView.image =[UIImage imageNamed:imageNames];
            
         [cell.finishBtn setTitle:@"立即进入" forState:UIControlStateNormal];
       [cell.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } finishHandler:^(UIButton *finishBtn) {
            NSLog(@"%@",finishBtn.titleLabel.text);
       self.window.rootViewController = [[UINavigationController alloc]
                                              initWithRootViewController:
                                              [[ViewController alloc]init]];
        }];
        
        guidePageVc.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        guidePageVc.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
        self.window.rootViewController = guidePageVc;
    }else{
            self.window.rootViewController = [[UINavigationController alloc]
                                               initWithRootViewController:
                                             [[ViewController alloc]init]];
    
    }

```
