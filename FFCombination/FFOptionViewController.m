//
//  FFOptionViewController.m
//  FFCombination
//
//  Created by 石燚 on 2017/12/9.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFOptionViewController.h"
#import "FFTResultListController.h"

#define kSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)


@interface FFOptionViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *contentTitle;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *zuheTitle;

@property (nonatomic, assign) NSInteger zuhe;


@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) NSMutableSet<NSNumber *> *calculateSet;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *resultSet;

@property (nonatomic, strong) FFTResultListController *resultController;



@end

@implementation FFOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择计算";
    [self.view addSubview:self.contentTitle];
    [self.view addSubview:self.pickerView];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    _zuhe = 1;
}

#pragma mark - responds
- (void)respondsToCalculate {
    self.resultSet = nil;
    self.calculateSet = [NSMutableSet setWithArray:self.selectArray];

    NSMutableArray *resultArray = [NSMutableArray array];
    [self calculateCombinationWithSet:self.calculateSet needNumber:_zuhe frontArray:[NSMutableArray array] resultArray:resultArray];
    self.resultController.resultList = resultArray;

    [self.navigationController pushViewController:self.resultController animated:YES];
}

- (void)calculateCombinationWithSet:(NSMutableSet *)set needNumber:(NSInteger)needNumber frontArray:(NSMutableArray *)frontArray resultArray:(NSMutableArray *)resultArray {

    if (needNumber == set.count) {
        [self addResultNumber:set WithFrontNumber:frontArray withResultArray:resultArray];
        return;
    }

    needNumber--;
    if (needNumber == 0) {
        [self addresultNumberWithSet:set toResultArray:resultArray withFrontNumber:frontArray];
    } else {
        NSArray *array = [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
        for (NSNumber *resultNumber in array) {
            [set removeObject:resultNumber];
            NSMutableArray *frnotArr = [frontArray mutableCopy];
            [frnotArr addObject:resultNumber];
                [self calculateCombinationWithSet:[set mutableCopy] needNumber:needNumber frontArray:frnotArr resultArray:resultArray];
            if (set.count == needNumber) {
                break;
            }
        }
    }
}


- (void)addResultNumber:(NSMutableSet *)set WithFrontNumber:(NSMutableArray *)frontArray withResultArray:(NSMutableArray *)resultArray {
    [frontArray addObjectsFromArray:[set allObjects]];
    [resultArray addObject:[frontArray sortedArrayUsingSelector:@selector(compare:)]];
}

- (void)addresultNumberWithSet:(NSMutableSet *)set toResultArray:(NSMutableArray *)resultArray withFrontNumber:(NSMutableArray *)frontArray {
    for (NSNumber *number in set) {
        NSMutableArray *addArray = [frontArray mutableCopy];
        [addArray addObject:number];
        [resultArray addObject:[addArray sortedArrayUsingSelector:@selector(compare:)]];
    }
}


#pragma mark - data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 1;
    } else {
        return self.selectArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.zuheTitle;
    } else {
        return [NSString stringWithFormat:@"%ld",row + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        _zuhe = row + 1;
        self.zuheTitle = [NSString stringWithFormat:@"组合 %ld 个数", _zuhe];
        [pickerView reloadComponent:0];
    }
}

#pragma mark - setter
- (void)setSelectArray:(NSArray *)selectArray {
    _selectArray = [selectArray sortedArrayUsingSelector:@selector(compare:)];
    self.resultController.resultList = nil;
//    _zuhe = 1;
    self.resultSet = nil;
    self.calculateSet = nil;
    NSString *contentTitle = [_selectArray componentsJoinedByString:@" - "];
    self.contentTitle.text = [NSString stringWithFormat:@"选中的数字为 : %@",contentTitle];
    [self.pickerView reloadAllComponents];
}



#pragma mark - getter
- (UILabel *)contentTitle {
    if (!_contentTitle) {
        _contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, kSCREEN_WIDTH, 150)];
        _contentTitle.textAlignment = NSTextAlignmentCenter;
        _contentTitle.numberOfLines = 0;
    }
    return _contentTitle;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentTitle.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6)];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSString *)zuheTitle {
    if (!_zuheTitle) {
        _zuheTitle = [NSString stringWithFormat:@"组合 %ld 个数",_zuhe];
    }
    return _zuheTitle;
}


- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"计算" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCalculate)];
    }
    return _rightButton;
}

- (NSMutableSet *)resultSet {
    if (!_resultSet) {
        _resultSet = [NSMutableSet set];
    }
    return _resultSet;
}

- (FFTResultListController *)resultController {
    if (!_resultController) {
        _resultController = [FFTResultListController new];
    }
    return _resultController;
}


@end






