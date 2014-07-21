//
//  RSExpressionFormatter.m
//  Calculator
//
//  Created by Роман Щербаков on 20.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import "RSExpressionFormatter.h"
#import "RSExpression.h"

@interface RSExpressionFormatter()

@property (strong, nonatomic) NSMutableString *expressionStr;

@end

@implementation RSExpressionFormatter

- (id)init
{
    self = [super init];
    if (self) {
        _expressionStr = [NSMutableString string];
    }
    return self;
}

- (NSString *)expressionFormatter:(RSExpression *)expression andSymbol:(NSString *)symbol
{
    if (expression.currentModelState == RSModelEmpty) {
        [self.expressionStr setString:@""];
        return @"0";
    }
    if (expression.currentModelState == RSFirstOperandNotEmpty) {
        [self.expressionStr appendString:symbol];
    }
    if (expression.currentModelState == RSOperatorNotEmpty) {
        [self.expressionStr appendString:[NSString stringWithFormat:@" %@ ", symbol]];
    }
    if (expression.currentModelState == RSSecondOperatorNotEmpty) {
        [self.expressionStr appendString:symbol];
    }
    if (expression.currentModelState == RSResult) {
        [self.expressionStr appendString:[NSString stringWithFormat:@" %@ %@", symbol, expression.resultOfExpression]];
    }
    return self.expressionStr;
}

- (void)clearexpressionStr
{
    [self.expressionStr setString:@""];
}

- (NSString *)stringFromOperator:(RSOperator)operator
{
    switch (operator) {
        case RSPlusOperator:
            return @"+";
        case RSMinusOperator:
            return @"-";
        case RSDevisionOperator:
            return @"/";
        case RSMMultiplicationOperator:
            return @"*";
        default:
            return nil;
    }
}

- (RSOperator)operatorFromString:(NSString *)symbol
{
    if ([symbol isEqualToString:@"+"]) {
        return RSPlusOperator;
    }
    else if ([symbol isEqualToString:@"-"]) {
        return RSMinusOperator;
    }
    else if ([symbol isEqualToString:@"/"])  {
        return RSDevisionOperator;
    }
    else {
        return RSMMultiplicationOperator;
    }
}

@end
