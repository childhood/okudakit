//
//  PKGenericAssemblerTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "OKTestScaffold.h"
#import "OKMiniCSSAssembler.h"
#import "OKGenericAssembler.h"

@interface OKGenericAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    OKMiniCSSAssembler *cssAssember;
    PKParserFactory *factory;
    PKParser *cssParser;
    PKAssembly *a;
    OKGenericAssembler *genericAssember;
}

@end
