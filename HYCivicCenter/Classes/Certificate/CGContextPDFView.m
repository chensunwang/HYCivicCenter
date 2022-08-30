//
//  CGContextPDFView.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/31.
//

#import "CGContextPDFView.h"

@implementation CGContextPDFView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef)pdfDoc {
    
    if (self = [super initWithFrame:frame]) {
        pageNo = index;
        pdfDocument = pdfDoc;
    }
    return self;;
    
}

- (void)drawInContext:(CGContextRef)context atPageNo:(int)page_no {
    
    CGContextTranslateCTM(context, 0.0, self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (pageNo == 0) {
        pageNo = 1;
    }
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNo);
    CGAffineTransform pdfTransForm = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.frame, 0, true);
    CGContextConcatCTM(context, pdfTransForm);
    CGContextDrawPDFPage(context, page);
    
}

- (void)drawRect:(CGRect)rect {
    
    [self drawInContext:UIGraphicsGetCurrentContext() atPageNo:pageNo];
    
}

@end
