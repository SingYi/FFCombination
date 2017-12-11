//
//  FFOptionViewController.m
//  FFCombination
//
//  Created by 石燚 on 2017/12/9.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFOptionViewController.h"

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
}

#pragma mark - responds
- (void)respondsToCalculate {
    self.resultSet = nil;
    self.calculateSet = [NSMutableSet setWithArray:self.selectArray];
//    self.resultSet = [self calculateCombinationWithSet:self.calculateSet Number:_zuhe ResultSet:self.resultSet];
    
    NSMutableArray *array = [self calculateSetWithSet:self.calculateSet number:_zuhe resultArray:[NSMutableArray array] lastNumber:nil];
    
    NSLog(@"result array = %@",array);
}

- (NSMutableSet *)calculateCombinationWithSet:(NSMutableSet<NSNumber *> *)calculateSet Number:(NSInteger)number ResultSet:(NSMutableSet *)resultSet {
    
    if (calculateSet.count == number) {
        return calculateSet;
    }
    
    NSArray *array = [calculateSet allObjects];
    
    number--;
    for (NSNumber *calculateNumber in array) {
        NSMutableArray *reslutArray = [NSMutableArray arrayWithCapacity:number];
        [reslutArray addObject:calculateNumber];
    
        [calculateSet removeObject:calculateNumber];
//        [self calculateSetWithSet:calculateSet number:number resultArray:reslutArray];
        [resultSet addObject:reslutArray];
        if (calculateSet.count == number) {
            break;
        }
    }
    
    NSLog(@"relust === %@",resultSet);

    
    return nil;
}

- (NSMutableArray *)calculateSetWithSet:(NSMutableSet *)set number:(NSInteger)number resultArray:(NSMutableArray *)resultArray lastNumber:(NSNumber *)lastNumber {
    
    if (number == set.count) {
        NSMutableArray *array = [[set allObjects] mutableCopy];
        if (lastNumber) {
            [array addObject:lastNumber];
        }
        
        return array;
    }
    
    number--;
    if (number == 0) {
        
//        NSLog(@"========================================");
//        NSLog(@"calculate set == %ld",set.count);
//        NSLog(@"calculate number == %ld",number);
//        NSLog(@"calculate last number == %@",lastNumber);
//        NSLog(@"========================================");
        
//        NSMutableArray *array = [NSMutableArray array];
        
        [resultArray addObjectsFromArray:[self addArray:[[set allObjects] mutableCopy] Number:lastNumber]];
        return resultArray;
        
        
    } else {
        NSArray *array = [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
        for (NSNumber *resultNumber in array) {
            [set removeObject:resultNumber];
            NSMutableSet *set1 = [set mutableCopy];
            
            if (set1.count == number) {
                [resultArray addObject:[self calculateSetWithSet:set1 number:number resultArray:nil lastNumber:resultNumber]];
                break;
            }
//
//            NSLog(@"==============================");
//            NSLog(@"result number == %@",resultNumber);
////            NSLog(@"set1 = %@",set1);
//            NSLog(@"number = %ld",number);
//            NSLog(@"last number == %@",lastNumber);
//            NSLog(@"==============================");
            
            NSMutableArray *arr = [self calculateSetWithSet:set1 number:number resultArray:[NSMutableArray array] lastNumber:resultNumber];
            
            if (lastNumber) {
//                [resultArray addObject:[self addArray:arr Number:lastNumber]];
                NSLog(@"add array = %@",[self addArray:arr Number:lastNumber]);
                [resultArray addObjectsFromArray:array];
            }
            
            
            if (set.count == number) {
                break;
            }
        }
        NSLog(@"================ %@",resultArray);
//        return resultArray;
    }
    
    
//    NSLog(@"result array == %@",resultArray);
    return resultArray;
    
}

- (NSMutableArray *)addArray:(NSMutableArray *)array Number:(NSNumber *)number {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *arr = nil;
        if ([obj isKindOfClass:[NSNumber class]]) {
            arr = [NSMutableArray arrayWithObject:obj];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            arr = [obj mutableCopy];
        }
        
        if (number) {
            [arr addObject:number];
        }
        [array replaceObjectAtIndex:idx withObject:arr];
    }];
    return [array mutableCopy];
}

//- (NSArray *)selectNumberInSet:(NSMutableSet *)set {
//    if (set.count > 0) {
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:set.count];
//        for (NSNumber *number in set) {
//            [array addObject:@[number]];
//        }
//        return array;
//    } else {
//        return nil;
//    }
//}

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
    
    NSLog(@"selectarray === %@",_selectArray);
    _zuhe = 1;
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


@end






