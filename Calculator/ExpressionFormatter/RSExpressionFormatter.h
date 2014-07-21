//
//  RSExpressionFormatter.h
//  Calculator
//
//  Created by Роман Щербаков on 20.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSExpression.h"

@class RSExpression;

@interface RSExpressionFormatter : NSObject

- (NSString *)expressionFormatter:(RSExpression *)expression andSymbol:(NSString *)symbol;

- (RSOperator)operatorFromString:(NSString *)symbol;

- (void)clearexpressionStr;

@end
