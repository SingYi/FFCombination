//
//  FFTResultListController.m
//  FFCombination
//
//  Created by 燚 on 2017/12/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFTResultListController.h"

@interface FFTResultListController ()

@end

@implementation FFTResultListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setResultList:(NSArray *)resultList {
    _resultList = resultList;
    self.navigationItem.title = [NSString stringWithFormat:@"总共有 %ld 个组合",_resultList.count];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ide"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell_ide"];
    }

    NSArray *resultArray = [self.resultList[indexPath.row] sortedArrayUsingSelector:@selector(compare:)];
    NSString *resultString = [resultArray componentsJoinedByString:@"-"];

    cell.textLabel.text = [NSString stringWithFormat:@"%3.00ld>>> %@",indexPath.row + 1,resultString];

    
    return cell;
}


@end
