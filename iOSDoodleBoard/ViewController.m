//
//  ViewController.m
//  iOSDoodleBoard
//
//  Created by BoBo on 2017/1/6.
//  Copyright © 2017年 JR_Dun. All rights reserved.
//

#import "ViewController.h"
#import "JRDrawView.h"

@interface ViewController ()

@property (nonatomic, strong) JRDrawView *drawView;

@property (nonatomic, strong) UIView            *toolView;
@property (nonatomic, strong) NSArray           *toolArray;
@property (nonatomic, strong) NSMutableArray    *buttonArray;
@property (nonatomic, strong) UIButton          *selectedButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.toolArray = @[@"涂鸦",@"橡皮擦",@"矩形",@"圆",@"直线",@"箭头",@"清除"];
    
    [self initUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)buttonArray
{
    if(!_buttonArray)
    {
        _buttonArray = [NSMutableArray new];
    }
    
    return _buttonArray;
}

- (UIView *)toolView
{
    if(!_toolView)
    {
        _toolView = [UIView new];
        _toolView.backgroundColor = [UIColor grayColor];
        
        UIButton *lastButton = nil;
        for(int i = 1; i <= self.toolArray.count; i++)
        {
            UIButton *button = [UIButton new];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitle:self.toolArray[i-1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:button];
            
            button.translatesAutoresizingMaskIntoConstraints = NO;
            
            if(lastButton)
            {
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
            }
            else
            {
                self.selectedButton = button;
                
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_toolView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_toolView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                [_toolView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_toolView attribute:NSLayoutAttributeWidth multiplier:1.0/self.toolArray.count constant:0]];
            }
            [self.buttonArray addObject:button];
            lastButton = button;
        }
    }
    
    return _toolView;
}

- (void)setSelectedButton:(UIButton *)selectedButton
{
    _selectedButton.selected = NO;
    _selectedButton = selectedButton;
    _selectedButton.selected = YES;
}

- (void)initUI
{
    self.drawView = [JRDrawView new];
    [self.view addSubview:self.drawView];
    
    [self.view addSubview:self.toolView];
    
    
    self.drawView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.toolView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
}

- (void)action:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            self.drawView.currentType = kDrawShapeDoodle;
            self.selectedButton = sender;
            break;
        case 2:
            self.drawView.currentType = kDrawShapeEraser;
            self.selectedButton = sender;
            break;
        case 3:
            self.drawView.currentType = kDrawShapeRect;
            self.selectedButton = sender;
            break;
        case 4:
            self.drawView.currentType = kDrawShapeRound;
            self.selectedButton = sender;
            break;
        case 5:
            self.drawView.currentType = kDrawShapeLine;
            self.selectedButton = sender;
            break;
        case 6:
            self.drawView.currentType = kDrawShapeArrow;
            self.selectedButton = sender;
            break;
        case 7:
            [self.drawView clear];
            break;
        default:
            break;
    }
}

@end
