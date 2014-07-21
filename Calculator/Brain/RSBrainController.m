//
//  RSBrainController.m
//  Calculator
//
//  Created by Роман Щербаков on 19.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import "RSBrainController.h"
#import "RSExpression.h"
#import "RSExpressionFormatter.h"

static NSString * const kEqualSymbol = @"=";
static NSString * const kResetSymbol = @"C";
static NSString * const kZeroSymbol = @"0";
static NSInteger kMaxOperandSymbols = 6;

@interface RSBrainController () <RSObserver>

@property (nonatomic, strong) RSExpression *expression;
@property (nonatomic, strong) RSExpressionFormatter *expressionFormatter;

@property (nonatomic, strong) NSString *symbol;

@end

@implementation RSBrainController

- (id)init
{
    self = [super init];
    if (self) {
        _expression = [[RSExpression alloc] init];
        [_expression registerObserver:self];
        _expressionFormatter = [[RSExpressionFormatter alloc] init];
        _symbol = [NSString string];
    }
    return self;
}

- (void)dealloc
{
    [_expression removeObserver:self];
}

#pragma mark - Public Methods

- (void)addNextSymbol:(NSString *)symbol
{
    self.symbol = symbol;
    if ([symbol isEqualToString:kResetSymbol]) {
        [self.expression clearModel];
        return;
    }
    if (self.expression.currentModelState == RSResult) {
        self.expression.currentModelState = RSModelEmpty;
        [self.expression clearModel];
    }
    if (self.expression.currentModelState == RSModelEmpty) {
        if ([self isSymbolNumber:symbol]) {
            self.expression.currentModelState = RSFirstOperandNotEmpty;
            [self addSymbolToFirstOperand];
        }
        return;
    }
    if (self.expression.currentModelState == RSFirstOperandNotEmpty) {
        if ([self isSymbolNumber:symbol]) {
            if ([self.expression.firstOperand isEqualToString:kZeroSymbol]) {
                if ([symbol isEqualToString:kZeroSymbol]) {
                    return;
                }
            }
            [self addSymbolToFirstOperand];
        }
        else {
            if (![symbol isEqualToString:kEqualSymbol]) {
                self.expression.currentModelState = RSOperatorNotEmpty;
                [self addOperator];
            }
        }
        return;
    }
    if (self.expression.currentModelState == RSOperatorNotEmpty) {
        if ([self isSymbolNumber:symbol]) {
            self.expression.currentModelState = RSSecondOperatorNotEmpty;
            [self addSymbolToSecondOperand];
        }
        return;
    }
    if (self.expression.currentModelState == RSSecondOperatorNotEmpty) {
        if ([symbol isEqualToString:kEqualSymbol]) {
            self.expression.currentModelState = RSResult;
            [self.expression calculate];
        }
        if ([self isSymbolNumber:symbol]) {
            if ([self.expression.secondOperand isEqualToString:kZeroSymbol]) {
                return;
            }
            [self addSymbolToSecondOperand];
        }
    }
}

#pragma mark - Private Methods

- (void)addSymbolToFirstOperand
{
    if (![self.expression.firstOperand length] || [self.expression.firstOperand isEqualToString:kZeroSymbol]) {
        [self.expressionFormatter clearexpressionStr];
        self.expression.firstOperand = self.symbol;
    }
    else {
        if ([self.expression.firstOperand length] <= kMaxOperandSymbols) {
            self.expression.firstOperand = [NSString stringWithFormat:@"%@%@", self.expression.firstOperand, self.symbol];
        }
    }
}

- (void)addSymbolToSecondOperand
{
    if (![self.expression.secondOperand length]) {
        self.expression.secondOperand = self.symbol;
    }
    else {
        if ([self.expression.secondOperand length] <= kMaxOperandSymbols) {
        self.expression.secondOperand = [NSString stringWithFormat:@"%@%@", self.expression.secondOperand, self.symbol];
        }
    }
}

- (void)addOperator
{
    self.expression.arithmeticOperator = [self.expressionFormatter operatorFromString:self.symbol];
}

#pragma mark - Helpers Methods

- (BOOL)isSymbolNumber:(NSString *)symbol
{
    if (symbol) {
        return ([symbol length] && isnumber([symbol characterAtIndex:0]));
    }
    else {
        return NO;
    }
}

#pragma mark - Key-Value Observing

+ (BOOL)automaticallyNotifiesObserversOfExpressionFormatted
{
    return NO;
}

#pragma mark - RSObserver

- (void)objectDidChanged:(RSExpression *)expression
{
    [self willChangeValueForKey:@"expressionFormatted"];
    _expressionFormatted = [self.expressionFormatter expressionFormatter:expression andSymbol:self.symbol];
    [self didChangeValueForKey:@"expressionFormatted"];
}

- (void)divisionByZeroError
{
    [self willChangeValueForKey:@"expressionFormatted"];
    _expressionFormatted = @"Делить на нуль нельзя!!!";
    [self didChangeValueForKey:@"expressionFormatted"];
}

@end
