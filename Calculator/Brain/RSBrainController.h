//
//  RSBrainController.h
//  Calculator
//
//  Created by Роман Щербаков on 19.07.14.
//  Copyright (c) 2014 Роман Щербаков. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSExpression;

@interface RSBrainController : NSObject

@property (nonatomic, strong) NSString *expressionFormatted;

- (void)addNextSymbol:(NSString *)symbol;

@end
