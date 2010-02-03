//
//  OKTestScaffold.m
//  OkudaKit
//
//  Created by Todd Ditchendorf on 7/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "OKTestScaffold.h"

#define RUN_ALL_TEST_CASES 1
#define SOLO_TEST_CASE @"OKMiniCSSAssemblerTest"

@interface SenTestSuite (OKAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames;
@end

SenTestSuite *TDSoloTestSuite() {
    SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Solo Test Suite"];
    
    NSArray *classNames = [NSArray arrayWithObject:SOLO_TEST_CASE];
    
    [suite addSuitesForClassNames:classNames];
    return suite;
}


SenTestSuite *OKAllTestSuite() {
    SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"All Test Suite"];
    
    NSArray *classNames = [NSArray arrayWithObjects:
                           @"OKMiniCSSAssemblerTest",
                           @"OKGenericAssemblerTest",
                           nil];
    
    [suite addSuitesForClassNames:classNames];
    return suite;
}

@implementation SenTestSuite (OKAdditions)

+ (id)testSuiteForBundlePath:(NSString *)path {
    SenTestSuite *suite = nil;
    
#if RUN_ALL_TEST_CASES
    suite = [self defaultTestSuite];
#else
    suite = [self testSuiteWithName:@"My Tests"]; 
    //    [suite addTest:TDCharsTestSuite()];
    //    [suite addTest:TDTokensTestSuite()];
    //    [suite addTest:TDParseTestSuite()];
    //    [suite addTest:TDParserFactoryTestSuite()];
    [suite addTest:TDSoloTestSuite()];
#endif
    
    return suite;
}


- (void)addSuitesForClassNames:(NSArray *)classNames {
    for (NSString *className in classNames) {
        SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseWithName:className];
        [self addTest:suite];
    }
}

@end