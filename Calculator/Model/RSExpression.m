//
//  RSExpression.m
//  RSCalculator
//
//  Created by Роман Щербаков on 19.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import "RSExpression.h"

@interface RSExpression()

@property (nonatomic, strong) NSHashTable *observers;

@end

@implementation RSExpression

- (id)init
{
    self = [super init];
    if (self) {
        _observers = [NSHashTable weakObjectsHashTable];
        _currentModelState = RSModelEmpty;
    }
    return self;
}

- (void)clearModel
{
    self.currentModelState = RSModelEmpty;
    self.firstOperand = @"";
    self.secondOperand = @"";
    self.resultOfExpression = @"";
}

- (void)calculate
{
    double firstOperand = [self.firstOperand doubleValue];
    double secondOperand = [self.secondOperand doubleValue];
    switch (self.arithmeticOperator) {
        case RSPlusOperator:
            self.resultOfExpression = [NSString stringWithFormat:@"%0.f", firstOperand + secondOperand];
            break;
            
        case RSMinusOperator:
            self.resultOfExpression = [NSString stringWithFormat:@"%.0f", firstOperand - secondOperand];
            break;
            
        case RSMMultiplicationOperator:
            self.resultOfExpression = [NSString stringWithFormat:@"%.0f", firstOperand * secondOperand];
            break;
            
        case RSDevisionOperator:
            if (!secondOperand) {
                [self clearModel];
                [self notifyDivisionByZero];
                return;
            }
            else {
                self.resultOfExpression = [NSString stringWithFormat:@"%.2f", firstOperand / secondOperand];
            }
            break;
            
        default:
            break;
    }
}

- (void)setFirstOperand:(NSString *)firstOperand
{
    [self willChangeValueForKey:@"firstOperand"];
    _firstOperand = firstOperand;
    [self didChangeValueForKey:@"firstOperand"];
}

- (void)setSecondOperand:(NSString *)secondOperand
{
    [self willChangeValueForKey:@"secondOperand"];
    _secondOperand = secondOperand;
    [self didChangeValueForKey:@"secondOperand"];
}

- (void)setArithmeticOperator:(RSOperator)arithmeticOperator
{
    [self willChangeValueForKey:@"arithmeticOperator"];
    _arithmeticOperator = arithmeticOperator;
    [self didChangeValueForKey:@"arithmeticOperator"];
}

- (void)setResultOfExpression:(NSString *)resultOfExpression
{
    [self willChangeValueForKey:@"resultOfExpression"];
    _resultOfExpression = resultOfExpression;
    [self didChangeValueForKey:@"resultOfExpression"];
}

#pragma mark - Key-Value Observing

- (void)didChangeValueForKey:(NSString *)key
{
    [super didChangeValueForKey:key];
    [self notifyObservers:self];
}

#pragma mark - RSSubject

- (void)registerObserver:(id<RSObserver>)observer
{
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<RSObserver>)observer
{
    [self.observers removeObject:observer];
}

- (void)notifyObservers:(RSExpression *)expression
{
    for (id<RSObserver> observer in [self.observers copy]) {
        if ([observer respondsToSelector:@selector(objectDidChanged:)]) {
            [observer objectDidChanged:expression];
        }
    }
}

- (void)notifyDivisionByZero
{
    for (id<RSObserver> observer in [self.observers copy]) {
        if ([observer respondsToSelector:@selector(divisionByZeroError)]) {
            [observer divisionByZeroError];
        }
    }
}

@end
