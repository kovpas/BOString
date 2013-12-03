NSAttributedString
========

It's not a secret that NSAttributedString API is far from perfect. Based on NSDictionary, it looks ugly, counter-OOP and hard to maintain...

````
NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Test attributed string" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor], NSFontAttributeName: [fnt fontWithSize:20]}];
[attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]
                                  , NSFontAttributeName: [fnt2 fontWithSize:10]
                                  , NSLigatureAttributeName: @2
                                  , NSBaselineOffsetAttributeName: @1}
                          range:NSMakeRange(3, 5)];
[attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]
                                  , NSFontAttributeName: [fnt2 fontWithSize:30]}
                          range:NSMakeRange(6, 9)];
[attributedString addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                                  , NSStrikethroughColorAttributeName: [UIColor redColor]
                                  , NSBackgroundColorAttributeName: [UIColor yellowColor]}
                          range:NSMakeRange(7, 4)];
_attributedTextView2.attributedText = attributedString;
````

Some developers get really desperate and write tools like [this](https://itunes.apple.com/us/app/attributed-string-creator/id730928349?mt=12)... Which again proves that NSAttributedString API is far from perfect.

Masonry
========

I love [masonry](https://github.com/cloudkite/Masonry). I love its clarity, its syntax. If you are using autolayout in your project and still write constraints using NSLayoutConstraint API, you should definitely take a look at masonry. Clear and very brief syntax makes code much more human readable, easy to maintain and modify.

BOString
========

So, based on masonry syntax, I decided to create a similar framework, which will take away some pain of creating NSAttributedString:

````
NSMutableAttributedString *attributedString = [@"Test attributed string" makeString:^(BOStringMaker *make) {
    make.foregroundColor([UIColor greenColor]);
    make.font([fnt fontWithSize:20]);

    make.with.range(NSMakeRange(3, 5), ^{
        make.foregroundColor([UIColor redColor]);
        make.font([fnt2 fontWithSize:10]);
        make.ligature(@2);
        make.baselineOffset(@1);
    });

    make.with.range(NSMakeRange(6, 9), ^{
        make.foregroundColor([UIColor blueColor]);
        make.font([fnt2 fontWithSize:30]);
    });

    make.with.range(NSMakeRange(7, 4), ^{
        make.strikethroughStyle(@(NSUnderlineStyleSingle));
        make.strikethroughColor([UIColor redColor]);
        make.backgroundColor([UIColor yellowColor]);
    });
}];
````

What attributes BOString supports? In fact, it supports all of them:

````
font;
paragraphStyle;
foregroundColor;
backgroundColor;
ligature;
kern;
strikethroughStyle;
underlineStyle;
strokeColor;
strokeWidth;
shadow;
textEffect;
attachment;
link;
baselineOffset;
underlineColor;
strikethroughColor;
obliqueness;
expansion;
writingDirection;
verticalGlyphForm;
````

While making a string you can specify ranges for attributes either with a block-based syntax as in the example above:
````
make.with.range(NSMakeRange(6, 9), ^{
    make.foregroundColor([UIColor blueColor]);
    make.font([fnt2 fontWithSize:30]);
});
````

or set range for a specific attribute (with is an optional semantic filler):

````
    make.foregroundColor([UIColor blueColor]).with.range(NSRange(6, 9));
    make.font([fnt2 fontWithSize:30]).range(NSRange(6, 9));
````

If you don't specify range, full range of string will be used.

Even more than just an NSAttributedString maker!
=======

A couple of substring attribute setters. Set attributes for a first substring found:

````
NSAttributedString *result = [@"This is a string" makeString:^(BOStringMaker *make) {
    make.first.substring(@"is", ^{
        make.foregroundColor([UIColor greenColor]);
    });
}];
````

or highlight every substring:

````
NSAttributedString *result = [@"This is a string" makeString:^(BOStringMaker *make) {
    make.each.substring(@"is", ^{
        make.foregroundColor([UIColor greenColor]);
    });
}];
````

Installation
=======

The easiest way is to use CocoaPods:

In your Podfile

`pod 'BOString'`

and import it in a file you want to make strings like a boss:

`#import "Bostring.h"`

Contribution
=======

Feel free to submit pull requests into a **separate** branch. Please don't submit pull requests to `master`.

License
=======

BOString is released under the MIT License.
