//
//  Resolver.m
//  NodeResolver-Demo
//
//  Created by ios on 2024/5/21.
//

#import "Resolver.h"
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>

@implementation Resolver

- (void)readWithQuery:(NSString *)quert encoding:(NSString *)encoding {
    NSData *document = [_body dataUsingEncoding:NSUTF8StringEncoding];
    const char *encoded = encoding ? [encoding cStringUsingEncoding:NSUTF8StringEncoding] : NULL;
    xmlDoc *doc = htmlReadMemory([document bytes], (int)[document length], "", encoded, HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);

    xmlXPathContext *xpathCtx = xmlXPathNewContext(doc);
    
    xmlXPathObject *xpathObj = xmlXPathEvalExpression((xmlChar *)[quert cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx);
    if (xpathObj == NULL) {
        xmlXPathFreeContext(xpathCtx);
        return;
    }
    xmlNodeSet *nodes = xpathObj->nodesetval;
    if (!nodes) {
        xmlXPathFreeObject(xpathObj);
        xmlXPathFreeContext(xpathCtx);
        return;
    }
    
    for (int i = 0; i < nodes->nodeNr; i++) {
        xmlNode *tagNode = nodes->nodeTab[i];
        [self readWithTagNode:tagNode depth:0];
    }
    
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    xmlFreeDoc(doc);
}

- (void)readWithTagNode:(xmlNode *)tagNode depth:(int)depth {
    NSString *tagName;
    if (tagNode->name) {
        tagName = [NSString stringWithCString:(const char *)tagNode->name encoding:NSUTF8StringEncoding];
    }
    
    xmlChar *content = xmlNodeGetContent(tagNode);
    NSString *tagContent;
    if (content) {
        tagContent = [NSString stringWithCString:(const char *)content encoding:NSUTF8StringEncoding];
        xmlFree(content);
    }
    
    xmlAttr *attribute = tagNode->properties;
    NSString *tagAttribute;
    if (tagAttribute) {
        tagAttribute = [NSString stringWithCString:(const char *)attribute->name encoding:NSUTF8StringEncoding];
    }
    
    NSString *retractFormat = [[NSString alloc] initWithFormat:@"%% %dd", depth];
    NSLog(@"% d tagName: %@, tagContent: %@, tagAttribute: %@", depth, tagName, tagContent, tagAttribute);
    
    xmlNode *childNode = tagNode->children;
    while (childNode) {
        [self readWithTagNode:childNode depth:depth + 1];
        childNode = childNode->next;
    }
}

@end
