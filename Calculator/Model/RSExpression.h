//
//  RSExpression.h
//  RSCalculator
//
//  Created by Роман Щербаков on 19.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, RSOperator) {
    RSPlusOperator = 1,
    RSMinusOperator = 2,
    RSMMultiplicationOperator = 3,
    RSDevisionOperator = 4,
};

typedef NS_ENUM (NSUInteger, RSModelState) {
    RSModelEmpty = 1,
    RSFirstOperandNotEmpty = 2,
    RSOperatorNotEmpty = 3,
    RSSecondOperatorNotEmpty = 4,
    RSResult = 5
};

@class RSExpression;

@protocol RSObserver <NSObject>

@optional

- (void)objectDidChanged:(RSExpression *)expression;
- (void)divisionByZeroError;

@end

@protocol RSSubject <NSObject>

- (void)registerObserver:(id <RSObserver>)observer;
- (void)removeObserver:(id <RSObserver>)observer;
- (void)notifyObservers:(RSExpression *)expression;
- (void)notifyDivisionByZero;

@end

@interface RSExpression : NSObject <RSSubject>

@property (nonatomic, strong) NSString *firstOperand;
@property (nonatomic, strong) NSString *secondOperand;

@property (nonatomic, assign) RSOperator arithmeticOperator;

@property (nonatomic, assign) NSString *resultOfExpression;

@property (nonatomic, assign) RSModelState currentModelState;

- (void)clearModel;

- (void)calculate;

@end
