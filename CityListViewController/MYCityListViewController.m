//
//  MYCityListViewController.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCityListViewController.h"
#import "MYCityEntyM.h"
#import <Mantle/Mantle.h>
#import "MYCitySearchViewController.h"
#import <Masonry/Masonry.h>

@interface MYCityListViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchCityTextField;

@property (weak, nonatomic) IBOutlet UITableView *bgTable;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic,strong) MYCitySearchViewController *searchVC;

@property (nonatomic, strong) NSMutableArray *appearkeysArray;     //呈现24个字母
@property (nonatomic, strong) NSMutableArray *keysArray;                  //24个字母

@property (nonatomic, strong) NSMutableArray *appearSectionTitle;   //区头
@property (nonatomic, strong) NSMutableArray *sectionTitle;               //区头

@property (nonatomic, strong) NSMutableArray *appearDataSource;   //呈现所有城市
@property (nonatomic, strong) NSMutableArray *dataSource;               //所有城市

@end

@implementation MYCityListViewController

#define CITY_LIST_SOURCE_PLIST @"cityListSourceArray.plist"
static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self configData];
    [self configCityList];
    [self configNotifig];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (MYCitySearchViewController *)searchVC
{
    if (_searchVC == nil) {
        _searchVC = [[MYCitySearchViewController alloc]init];
        [self addChildViewController:_searchVC];
    }
    return _searchVC;
}

- (void)configUI
{
    self.title = @"选择城市";
    [self.bgTable setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.bgTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    self.searchCityTextField.layer.cornerRadius = 4;
    [self.searchCityTextField.layer setMasksToBounds:YES];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    [self.searchCityTextField setLeftView:view];
    [self.searchCityTextField setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)configData
{
    // 初始化索引关键字
    self.keysArray = [[NSMutableArray alloc] initWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    self.appearkeysArray = [[NSMutableArray alloc] initWithArray:self.keysArray];
    
    // 初始化session title
    self.sectionTitle = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    self.appearSectionTitle = [[NSMutableArray alloc] initWithArray:self.sectionTitle];
}

- (void)configCityList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:CITY_LIST_SOURCE_PLIST ofType:nil];
    // 获得城市数据数组
    NSArray *cityArray = [NSArray arrayWithContentsOfFile:path];
    // 城市数组 -> 模型数组
    NSArray *resultCitylist  = [MTLJSONAdapter modelsOfClass:[MYCityEntyM class] fromJSONArray:cityArray error:nil];
    if (resultCitylist.count > 0) {
          [self overgainCitySourceData:[resultCitylist mutableCopy]];
    }
}

/**
 *  将城市数据进行排序
 *
 *  @param cityArray 返回按字母顺序排序的数组
 */
- (void)overgainCitySourceData:(NSMutableArray *)cityArray
{
    // 确定区(每个区加一个数组)
    self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    for (id sessionTitle in self.sectionTitle) {
        NSMutableArray *mut = [[NSMutableArray alloc]initWithCapacity:0];
        [self.dataSource addObject:mut];
    }
    // 按字母顺序进行遍历 (取出字母相同的添加到数组中)
    for (int i =0;i < self.sectionTitle.count;i ++) {
        NSString *temS = [self.sectionTitle objectAtIndex:i];
        [cityArray enumerateObjectsUsingBlock:^(MYCityEntyM *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.firstLetter isEqualToString:temS]) {
                [[self.dataSource objectAtIndex:i] addObject:obj];
                [cityArray removeObject:obj];
            }
        }];
    }
    self.appearDataSource = [self.dataSource mutableCopy];
    [self.bgTable reloadData];
}

- (void)configNotifig
{
    // TextField文字发生改变触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:self.searchCityTextField];
}

- (void)infoAction
{
    // 搜索框没有输入
    if ([_searchCityTextField.text isEqualToString:@""] || !_searchCityTextField.text) {
        // 移除搜索控制器
        [self.searchVC.view removeFromSuperview];
        [self.bgTable reloadData];
    } else {
        [self.view addSubview:self.searchVC.view];
        [self.searchVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchView.mas_bottom).with.offset(0);
            make.left.equalTo(self.searchView.superview.mas_left).with.offset(0);
            make.right.equalTo(self.searchView.superview.mas_right).with.offset(0);
            make.bottom.equalTo(self.searchView.superview.mas_bottom).with.offset(0);
        }];
    }
    [self.searchVC setSearchText:self.searchCityTextField.text sourceArray:self.appearDataSource];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchCityTextField.textAlignment = NSTextAlignmentLeft;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.searchCityTextField.textAlignment = NSTextAlignmentCenter;
    return YES;
}

#pragma mark - UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.appearDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.appearDataSource objectAtIndex:section]count] == NSNotFound) { // 城市列表
        return 0;
    }
    return [[self.appearDataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    MYCityEntyM *cityM = self.appearDataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = cityM.cityName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.appearSectionTitle objectAtIndex:section];
}

/**
 *  右侧索引条
 */
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.appearkeysArray;
}


@end
