//
//  ViewController.m
//  FFCombination
//
//  Created by 石燚 on 2017/12/9.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ViewController.h"
#import "FFCollectionViewCell.h"
#import "FFOptionViewController.h"

#define kSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<NSNumber *> *showArray;
@property (nonatomic, strong) NSMutableDictionary *showDict;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;


@property (nonatomic, strong) FFOptionViewController *optionViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterfaca];
    
}


- (void)initUserInterfaca {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择数字";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.rightBarButtonItem = self.rightButton;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_IDE" forIndexPath:indexPath];
    
    cell.title = [NSString stringWithFormat:@"%ld",self.showArray[indexPath.row].integerValue];;

    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 2;
    cell.selected = NO;
    
    NSNumber *select = self.showDict[[NSNumber numberWithInteger:indexPath.item]];
    if (select.boolValue) {
        cell.selected = select.boolValue;
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *select = self.showDict[[NSNumber numberWithInteger:indexPath.item]];
    
    if (select.boolValue) {
        select = [NSNumber numberWithBool:NO];
        [self.selectArray removeObject:self.showArray[indexPath.row]];
    } else {
        select = [NSNumber numberWithBool:YES];
        [self.selectArray addObject:self.showArray[indexPath.row]];
    }
    
    [self.showDict setObject:select forKey:[NSNumber numberWithInteger:indexPath.row]];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - responds
- (void)respondsToLeftButton {
    self.showDict = nil;
    self.selectArray = nil;
    [self.collectionView reloadData];
}

- (void)respondsToRightButton {
    NSLog(@"%@",self.selectArray);
    self.optionViewController.selectArray = self.selectArray;
    [self.navigationController pushViewController:self.optionViewController animated:YES];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kSCREEN_WIDTH / 5, kSCREEN_WIDTH / 5);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.navigationController.navigationBar.frame))) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[FFCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_IDE"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}


- (NSArray *)showArray {
    if (!_showArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:35];
        for (int i = 1; i < 36; i++) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
        _showArray = [array copy];
    }
    return _showArray;
}

- (NSMutableDictionary *)showDict {
    if (!_showDict) {
        _showDict = [NSMutableDictionary dictionaryWithCapacity:self.showArray.count];
        [self.showArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_showDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:idx]];
        }];
    }
    return _showDict;
}

- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"计算组合" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _rightButton;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (FFOptionViewController *)optionViewController {
    if (!_optionViewController) {
        _optionViewController = [[FFOptionViewController alloc] init];
    }
    return _optionViewController;
}


@end
