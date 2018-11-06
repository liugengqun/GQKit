//
//  ViewController.m
//  GQKit
//
//  Created by Apple on 5/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "ViewController.h"
#import "GQPickerView.h"
#import "HXVideoModel.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];

    self.gq_isGetRequest = YES;
    self.gq_enableTableHeaderFooter = YES;
    self.gq_objClass = [HXVideoModel class];
    [self requestWithType:@"hot"];
}
- (void)requestWithType:(NSString *)type {
    __weak __typeof(self) weakSelf = self;
    
    self.gq_getRequestUrlBlock = ^NSString *(NSUInteger pageIndex){
        return [NSString stringWithFormat:@"http://api.xueyacar.com/car/queryCar?curPage=%zd&isPaging=1",pageIndex];
    };
//    self.gq_getRequestParametersBlock = ^NSDictionary *{
//        return @{@"page":[NSString stringWithFormat:@"%zd",weakSelf.gq_pageNextIndex],@"pagesize":@"3",@"type":type};
//    };
    [self gq_refresh];
}
- (NSArray *)gq_parseResponseDictionaryData:(NSDictionary *)data {
    return data[@"data"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gq_objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXVideoModel *model = self.gq_objects[indexPath.row];
    cell.textLabel.text = model.brandMessage;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
@end
