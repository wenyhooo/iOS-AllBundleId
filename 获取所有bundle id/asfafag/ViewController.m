//
//  ViewController.m
//  asfafag
//
//  Created by liwenhao on 2017/2/17.
//  Copyright © 2017年 liwenhaopro. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
//    [info setValue:@"weixin" forKey:@"key"];
//    NSLog(@"%@",[NSBundle mainBundle].infoDictionary);
    
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray  *appList = [workspace performSelector:@selector(allApplications)];
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    for (LSApplicationProxy_class in appList){
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSLog(@"bundleID = %@",bundleID);
    }

    [self getWANIPAddress];
    [self deviceBaiduWANIPAddress];
}
- (IBAction)ssssssssss:(id)sender {
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        [info setValue:@"weixin" forKey:@"key"];
        NSLog(@"%@",[NSBundle mainBundle].infoDictionary);
    NSURL *appurl = [NSURL URLWithString:@"weixin://"];
    BOOL IsInstalled = [[UIApplication sharedApplication] canOpenURL:appurl];
    NSLog(@"IsInstalled=%d",IsInstalled);
    [[UIApplication sharedApplication]openURL:appurl options:nil completionHandler:^(BOOL success) {
        
    }];
}

-(NSString *)getWANIPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *name = dict[@"cname"];
        NSLog(@"%@",dict);
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}

-(NSString *)deviceBaiduWANIPAddress
{
    NSError *error;
    
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    NSData * data = [ip dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return (ipDic[@"data"][@"ip"] ? ipDic[@"data"][@"ip"] : @"");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
