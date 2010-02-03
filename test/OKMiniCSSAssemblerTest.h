//
//  PKMiniCSSAssemblerTest.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 12/25/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "OKTestScaffold.h"
#import "OKMiniCSSAssembler.h"

@interface OKMiniCSSAssemblerTest : SenTestCase {
    NSString *path;
    NSString *grammarString;
    NSString *s;
    OKMiniCSSAssembler *ass;
    PKParserFactory *factory;
    PKParser *lp;
    PKAssembly *a;
}

@end
