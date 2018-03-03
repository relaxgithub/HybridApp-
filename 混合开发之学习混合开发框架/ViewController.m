//
//  ViewController.m
//  混合开发之学习混合开发框架
//
//  Created by relax on 2018/3/3.
//  Copyright © 2018年 relax. All rights reserved.
//

#import "ViewController.h"
#import <ContactsUI/ContactsUI.h> // 有界面的联系人通讯录

@interface ViewController () <UIWebViewDelegate,CNContactPickerDelegate>
/** 浏览器 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil]];
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.webView loadHTMLString:html baseURL:nil];
    
    self.webView.delegate = self;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString containsString:@"gqs"]) {
        NSLog(@"%@",@"捕获到了自定义协议");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这是标题" message:@"浏览器到 OC 的通道打通了!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"知道了!" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        return NO;

    }
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *ocStr = @"这是 OC 的字符串";
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showInfoFromOC(\"%@\")",ocStr]];
}

// 显示用户手机号码
- (IBAction)showUserPhoneNum:(id)sender {
    // 1. 创建控制器
    CNContactPickerViewController *pvc = [[CNContactPickerViewController alloc] init];
    // 2. 设置代理
    pvc.delegate = self;
    //
    // 3. 弹出控制器
    [self presentViewController:pvc animated:YES completion:nil];
    // 电话号码，应该是从通讯录里选择
   //  NSString *phoneNum = @"18571656584";
    
}

#pragma mark - CNContactPickerDelegate
// 取消
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选择了某个联系人
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//    NSLog(@"%@",contact);
//}

// 选择了某个联系人的属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    // NSArray<CNLabeledValue<CNPhoneNumber*>*>
    /**
     ] (
     "<CNLabeledValue: 0x618000275a00: identifier=E297F1F7-CAFC-4A9D-ABF8-F79DB4496C87, label=_$!<Mobile>!$_, value=<CNPhoneNumber: 0x61800022be00: countryCode=us, digits=8885555512>>",
     "<CNLabeledValue: 0x618000275d00: identifier=5E423897-5B64-4129-AF55-10B1B3153697, label=_$!<Home>!$_, value=<CNPhoneNumber: 0x61800022c280: countryCode=us, digits=8885551212>>"
     )
     */
    NSString *phoneNumber = [contactProperty.value stringValue];
    NSLog(@"%@",phoneNumber); // 拿到用户的电话号码
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showUserPhoneNum(\"%@\")",phoneNumber]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
