//
//  MYCitySearchViewController.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCitySearchViewController.h"
#import "MYCityEntyM.h"
#import "pinyin.h"

@interface MYCitySearchViewController ()

@property (nonatomic,strong) NSMutableArray *resultCitys;
@property (nonatomic,strong) NSString *searchText;
@end

@implementation MYCitySearchViewController
static NSString * const MYSearchCellID = @"MYSearchCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MYSearchCellID];
}

- (void)setSearchText:(NSString *)text sourceArray:(NSArray *)sourceData
{
     NSString *lowerSearchText = text.lowercaseString;
    self.searchText = text;
    
    NSString *regex = @"[\u4e00-\u9fa5]+";
    // 判断是否有汉字
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSMutableArray *temResultArray = [[NSMutableArray alloc]init];
    
    // 遍历每个字母对应的城市数组
    [sourceData enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 遍历对应字母数组下的城市
        [obj enumerateObjectsUsingBlock:^(MYCityEntyM *objz, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isHanZi = [predicat evaluateWithObject:text];
            if (isHanZi) { // 汉字的情况
                BOOL d1 = [objz.cityName rangeOfString:lowerSearchText].length != 0;
                if (d1) {
                    [temResultArray addObject:objz];
                }
            } else { // 非汉字的情况
                // 汉字转首字母
                NSMutableString *mutableStr = [@"" mutableCopy];
                for (int i = 0;i<objz.cityName.length ;i++) {
                    // 使用pinyin.h汉字转首字母
                    [mutableStr appendString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([objz.cityName characterAtIndex:i])]];
                }
                NSRange rangeShouZiMu = [mutableStr.lowercaseString rangeOfString:lowerSearchText];//拼音
                NSRange rangePinYin = [[objz.pinyin lowercaseString] rangeOfString:lowerSearchText];//首字母
                if (rangeShouZiMu.length || (rangePinYin.length && rangePinYin.location == 0)){
                    [temResultArray addObject:objz];
                }
            }
        }];
    }];
    
    NSMutableArray *outputArray = [[NSMutableArray alloc]init];
    [outputArray addObject:temResultArray];
    
    self.resultCitys = [[NSMutableArray alloc]initWithArray:outputArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.superview endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.resultCitys objectAtIndex:section] count]; // 取出对应字母的城市
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYSearchCellID];
    MYCityEntyM *cityM = self.resultCitys[indexPath.section][indexPath.row];
    
    // 如果输入的字符和模型相同 为橙色
    if([cityM.cityName rangeOfString:self.searchText].location != NSNotFound) {
        NSMutableAttributedString *attrbutString = [self changeAttributedWithSourceString:cityM.cityName replaceString:self.searchText];
        cell.textLabel.attributedText = attrbutString;
    }
    cell.textLabel.text = cityM.cityName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - NSMutableAttributedString
- (NSMutableAttributedString *)changeAttributedWithSourceString:(NSString *)sourceString replaceString:(NSString *)replaceString {
    NSRange range = [sourceString rangeOfString:replaceString];
    NSMutableAttributedString *rtnMutableAttributed = [[NSMutableAttributedString alloc] initWithString:[sourceString substringToIndex:range.location] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor blackColor] }];
    NSMutableAttributedString *replaceMutableAttributed = [[NSMutableAttributedString alloc] initWithString:replaceString attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor orangeColor] }];
    NSMutableAttributedString *footMutableAttributed = [[NSMutableAttributedString alloc] initWithString:[sourceString substringFromIndex:(range.location + range.length)] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor blackColor] }];
    
    [rtnMutableAttributed appendAttributedString:replaceMutableAttributed];
    [rtnMutableAttributed appendAttributedString:footMutableAttributed];
    
    return rtnMutableAttributed;
}

@end
