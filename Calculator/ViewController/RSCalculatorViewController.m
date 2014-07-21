//
//  RSCalculatorViewController.m
//  Calculator
//
//  Created by Роман Щербаков on 19.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import "RSCalculatorViewController.h"
#import "RSBrainController.h"

@interface RSCalculatorViewController ()

- (IBAction)buttonTap:(id)sender;

@property (weak, nonatomic) UILabel *expressionLabel;

@property (strong, nonatomic) RSBrainController *brainController;

@end

@implementation RSCalculatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *expressionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 159.0f)];
    expressionLabel.text = @"0";
    expressionLabel.textAlignment = NSTextAlignmentRight;
    expressionLabel.textColor = [UIColor whiteColor];
    expressionLabel.numberOfLines = 3;
    expressionLabel.font = [UIFont systemFontOfSize:38.0f];
    self.expressionLabel = expressionLabel;
    [self.view addSubview:self.expressionLabel];
    self.brainController = [[RSBrainController alloc] init];
    [self.brainController addObserver:self forKeyPath:@"expressionFormatted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self.brainController removeObserver:self forKeyPath:@"expressionFormatted"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonTap:(id)sender
{
    [self.brainController addNextSymbol:[sender currentTitle]];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"expressionFormatted"]) {
        self.expressionLabel.text = [change objectForKey:@"new"];
        NSLog(@"%@", self.expressionLabel.text);
    }
}

@end
