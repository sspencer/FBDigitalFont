#import <Foundation/Foundation.h>
#import "FBFontSymbol.h"

typedef enum {
    FBFontDotTypeSquare,
    FBFontDotTypeCircle
} FBFontDotType;


typedef enum {
    FBFontSpacingMonospaced,
    FBFontSpacingVariable,
    FBFontSpacingNumbers
} FBFontSpacing;


@interface FBBitmapFont : NSObject
+ (void)drawBackgroundWithDotType:(FBFontDotType)dotType
                            color:(UIColor *)color
                       edgeLength:(CGFloat)edgeLength
                           margin:(CGFloat)margin
                 horizontalAmount:(CGFloat)horizontalAmount
                   verticalAmount:(CGFloat)verticalAmount
                        inContext:(CGContextRef)ctx;

+ (void)drawSymbol:(unichar)symbol
       withDotType:(FBFontDotType)dotType
           spacing:(FBFontSpacing)spacing
             color:(UIColor *)color
        edgeLength:(CGFloat)edgeLength
            margin:(CGFloat)margin
        startPoint:(CGPoint)startPoint
         inContext:(CGContextRef)ctx;

+ (NSInteger)numberOfDotsWideForSymbol:(unichar)symbol
                           withSpacing:(FBFontSpacing)spacing;

// Replace default ASCII character with a different rendering
+ (void)setCustomSymbol:(unichar)symbol bitmask:(unichar[5])bitmask;

@end
