#import "FBBitmapFontView.h"
#import "FBFontSymbol.h"
#import "FBBitmapFont.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

@implementation FBBitmapFontView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.dotType        = FBFontDotTypeSquare;
    self.edgeLength     = 10.0;
    self.margin         = 2.0;
    self.glowSize       = 0.0;
    self.innerGlowSize  = 0.0;
    self.glowColor      = UIColorFromRGB(0xee3300);
    self.innerGlowColor = UIColorFromRGB(0xee3300);
    self.onColor        = UIColorFromRGB(0xffdd66);
    self.offColor       = UIColorFromRGB(0x222222);

    self.numberOfLeftPaddingDot   = 1;
    self.numberOfTopPaddingDot    = 0;
    self.numberOfRightPaddingDot  = 1;
    self.numberOfBottomPaddingDot = 0;
    self.numberOfPaddingDotsBetweenDigits = 1;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)resetSize
{
    CGRect f = self.frame;
    f.size = [self sizeOfContents];
    self.frame = f; 
}

- (CGSize)sizeOfContents
{
    NSInteger vd = [self numberOfVerticalDots];
    NSInteger hd = [self numberOfHorizontalDots];
    CGFloat w = hd * self.edgeLength + (hd - 1) * self.margin;
    CGFloat h = vd * self.edgeLength + (vd - 1) * self.margin;
    return CGSizeMake(w, h);
}

- (NSInteger)numberOfHorizontalDotsText
{
    NSInteger totalDotsFromSymbols = 0;
    for (int i = 0; i < [_text length]; i++) {
        unichar chr = [_text characterAtIndex:i];
        totalDotsFromSymbols += [FBBitmapFont numberOfDotsWideForSymbol:chr withSpacing:_spacing];
    }

    return totalDotsFromSymbols + (self.numberOfPaddingDotsBetweenDigits * ([_text length] - 1)) + self.numberOfLeftPaddingDot + self.numberOfRightPaddingDot;
}

// computed for width of frame, not width of text
- (NSInteger)numberOfHorizontalDots
{
    return self.frame.size.width / (self.edgeLength + self.margin);
}

- (NSInteger)numberOfVerticalDots
{
    return 7 + self.numberOfTopPaddingDot + self.numberOfBottomPaddingDot;
}

- (void)drawRect:(CGRect)rect
{
    NSInteger i = 0;

    CGFloat x = self.numberOfLeftPaddingDot * (self.edgeLength + self.margin);
    CGFloat y = self.numberOfTopPaddingDot * (self.edgeLength + self.margin);

    CGRect r = (CGRect){CGPointZero, [self sizeOfContents]};
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0.0);
    CGContextRef imgCtx = UIGraphicsGetCurrentContext();


    NSUInteger textDotWidth = [self numberOfHorizontalDotsText];
    NSUInteger backgroundDotWidth = [self numberOfHorizontalDots];
    NSUInteger dotDelta = backgroundDotWidth - textDotWidth;
    NSUInteger pixelSize = (self.edgeLength + self.margin);
    NSUInteger alignmentOffset = 0;

    if (_textAlignment == NSTextAlignmentRight) {
        alignmentOffset = dotDelta * pixelSize;
    } else if (_textAlignment == NSTextAlignmentCenter) {
        alignmentOffset = (NSUInteger)(dotDelta/2) * pixelSize;
    }

    for (i = 0; i < [_text length]; i++) {
        unichar ch = [_text characterAtIndex:i];
        CGFloat numberWide = [FBBitmapFont numberOfDotsWideForSymbol:ch withSpacing:_spacing];
        CGPoint startPoint = CGPointMake(x + alignmentOffset, y);
        //NSLog(@"ch=%c x=%0.1f nw=%0.1f", ch, x, numberWide);
        [FBBitmapFont drawSymbol:ch
                     withDotType:_dotType
                         spacing:_spacing
                           color:_onColor
                      edgeLength:_edgeLength
                          margin:_margin
                      startPoint:startPoint
                       inContext:imgCtx];

        x += pixelSize * (numberWide + _numberOfPaddingDotsBetweenDigits);
    }

    UIImage *digitImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(imgCtx, r);

    CGContextSaveGState(imgCtx);
    CGContextSetFillColorWithColor(imgCtx, [UIColor blackColor].CGColor);
    CGContextFillRect(imgCtx, r);
    CGContextTranslateCTM(imgCtx, 0.0, r.size.height);
    CGContextScaleCTM(imgCtx, 1.0, -1.0);
    CGContextClipToMask(imgCtx, r, digitImage.CGImage);
    CGContextClearRect(imgCtx, r);
    CGContextRestoreGState(imgCtx);

    UIImage *inverted = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(imgCtx, r);

    CGContextSaveGState(imgCtx);
    CGContextSetFillColorWithColor(imgCtx, self.innerGlowColor.CGColor);
    CGContextSetShadowWithColor(imgCtx, CGSizeZero, self.innerGlowSize, self.innerGlowColor.CGColor);
    [inverted drawAtPoint:CGPointZero];
    CGContextTranslateCTM(imgCtx, 0.0, r.size.height);
    CGContextScaleCTM(imgCtx, 1.0, -1.0);
    CGContextClipToMask(imgCtx, r, inverted.CGImage);
    CGContextClearRect(imgCtx, r);
    CGContextRestoreGState(imgCtx);

    UIImage *innerShadow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    /* draw base dots */
    CGContextClearRect(ctx, r);
    [FBBitmapFont drawBackgroundWithDotType:self.dotType
                                      color:self.offColor
                                 edgeLength:self.edgeLength
                                     margin:self.margin
                           horizontalAmount:backgroundDotWidth
                             verticalAmount:[self numberOfVerticalDots]
                                  inContext:ctx];

    CGContextSaveGState(ctx);

    CGContextSetShadowWithColor(ctx, CGSizeZero, self.glowSize, self.glowColor.CGColor);

    [digitImage drawAtPoint:CGPointMake(0.0, 0.0)];
    CGContextRestoreGState(ctx);
    [innerShadow drawAtPoint:CGPointMake(0.0, 0.0)];
}


@end
