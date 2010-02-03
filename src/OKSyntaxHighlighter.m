//
//  PKSyntaxHighlighter.m
//  HTTPClient
//
//  Created by Todd Ditchendorf on 12/26/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "OKSyntaxHighlighter.h"
#import <ParseKit/ParseKit.h>
#import "OKMiniCSSAssembler.h"
#import "OKGenericAssembler.h"

@interface OKSyntaxHighlighter ()
- (NSMutableDictionary *)attributesForGrammarNamed:(NSString *)grammarName;
- (PKParser *)parserForGrammarNamed:(NSString *)grammarName;

// all of the ivars for these properties are lazy loaded in the getters.
// thats so that if an application has syntax highlighting turned off, this class will
// consume much less memory/fewer resources.
@property (nonatomic, retain) PKParserFactory *parserFactory;
@property (nonatomic, retain) PKParser *miniCSSParser;
@property (nonatomic, retain) OKMiniCSSAssembler *miniCSSAssembler;
@property (nonatomic, retain) OKGenericAssembler *genericAssembler;
@property (nonatomic, retain) NSMutableDictionary *parserCache;
@property (nonatomic, retain) NSMutableDictionary *tokenizerCache;
@end

@implementation OKSyntaxHighlighter

+ (id)syntaxHighlighter {
    return [[[OKSyntaxHighlighter alloc] init] autorelease];
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}


- (void)dealloc {
    PKReleaseSubparserTree(miniCSSParser);
    for (PKParser *p in parserCache) {
        PKReleaseSubparserTree(p);
    }
    
    self.parserFactory = nil;
    self.miniCSSParser = nil;
    self.miniCSSAssembler = nil;
    self.genericAssembler = nil;
    self.parserCache = nil;
    self.tokenizerCache = nil;
    [super dealloc];
}


- (PKParserFactory *)parserFactory {
    if (!parserFactory) {
        self.parserFactory = [PKParserFactory factory];
    }
    return parserFactory;
}


- (OKMiniCSSAssembler *)miniCSSAssembler {
    if (!miniCSSAssembler) {
        self.miniCSSAssembler = [[[OKMiniCSSAssembler alloc] init] autorelease];
    }
    return miniCSSAssembler;
}


- (PKParser *)miniCSSParser {
    if (!miniCSSParser) {
        // create mini-css parser
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"OKMini_css" ofType:@"grammar"];
        NSString *grammarString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

        self.miniCSSParser = [self.parserFactory parserFromGrammar:grammarString assembler:self.miniCSSAssembler];
    } 
    return miniCSSParser;
}


- (OKGenericAssembler *)genericAssembler {
    if (!genericAssembler) {
        self.genericAssembler = [[[OKGenericAssembler alloc] init] autorelease];
    }
    return genericAssembler;
}


- (NSMutableDictionary *)parserCache {
    if (!parserCache) {
        self.parserCache = [NSMutableDictionary dictionary];
    }
    return parserCache;
}


- (NSMutableDictionary *)attributesForGrammarNamed:(NSString *)grammarName {
    // parse CSS
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:grammarName ofType:@"css"];
    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    PKAssembly *a = [PKTokenAssembly assemblyWithString:s];
    [self.miniCSSParser bestMatchFor:a]; // produce dict of attributes from the CSS
    return self.miniCSSAssembler.attributes;
}


- (PKParser *)parserForGrammarNamed:(NSString *)grammarName {
    // create parser or the grammar requested or fetch parser from cache
    PKParser *parser = nil;
    if (cacheParsers) {
        parser = [self.parserCache objectForKey:grammarName];
    }
    
    if (!parser) {
        // get attributes from css && give to the generic assembler
        parserFactory.assemblerSettingBehavior = PKParserFactoryAssemblerSettingBehaviorOnAll;
        self.genericAssembler.attributes = [self attributesForGrammarNamed:grammarName];
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:grammarName ofType:@"grammar"];
        NSString *grammarString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

        // generate a parser for the requested grammar
        parserFactory.assemblerSettingBehavior = PKParserFactoryAssemblerSettingBehaviorOnTerminals;
        parser = [self.parserFactory parserFromGrammar:grammarString assembler:self.genericAssembler];
        
        if (cacheParsers) {
            [self.parserCache setObject:parser forKey:grammarName];
            [self.tokenizerCache setObject:parser.tokenizer forKey:grammarName];
        }
    }

    return parser;
}


- (NSAttributedString *)highlightedStringForString:(NSString *)s ofGrammar:(NSString *)grammarName {    
    // create or fetch the parser & tokenizer for this grammar
    PKParser *parser = [self parserForGrammarNamed:grammarName];
    
    // parse the string. take care to preseve the whitespace and comments in the string
    parser.tokenizer.string = s;
    parser.tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    parser.tokenizer.commentState.reportsCommentTokens = YES;

    PKTokenAssembly *a = [PKTokenAssembly assemblyWithTokenizer:parser.tokenizer];
    a.preservesWhitespaceTokens = YES;
    
    PKAssembly *resultAssembly = [parser completeMatchFor:a]; // finally, parse the input. stores attributed string in resultAssembly.target
    
    if (!cacheParsers) {
        PKReleaseSubparserTree(parser);
    }
    
    id result = [[resultAssembly.target copy] autorelease];
    return result;
}

@synthesize parserFactory;
@synthesize miniCSSParser;
@synthesize miniCSSAssembler;
@synthesize genericAssembler;
@synthesize cacheParsers;
@synthesize parserCache;
@synthesize tokenizerCache;
@end
