

#import "GQTextFieldCell.h"
#import "GQKit.h"
@interface GQTextFieldCell()<UITextFieldDelegate>
@property(nonatomic, strong) UIButton *msgBtn;
@property(nonatomic, strong) UIButton *watchBtn;


@property (nonatomic, copy) NSString *preText;
@end
@implementation GQTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textF.delegate = self;
    self.textF.returnKeyType = UIReturnKeyNext;
    self.textF.clipsToBounds = YES;
    self.contentVCons.constant = 0;
    self.gq_typeOfOtherMaxLength = MAXFLOAT;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.gq_textFieldType == GQTextFieldTypeOfPhone) {
        self.textF.keyboardType = UIKeyboardTypeNumberPad;
    } else if (self.gq_textFieldType == GQTextFieldTypeOfMsgCode) {
        self.textF.keyboardType = UIKeyboardTypeNumberPad;
    } else if (self.gq_textFieldType == GQTextFieldTypeOfYanzhenCode) {
        self.textF.keyboardType = UIKeyboardTypeASCIICapable;
    } else if (self.gq_textFieldType == GQTextFieldTypeOfPassword) {
        
    } else if(self.gq_textFieldType == GQTextFieldTypeOfBankCard) {
        self.textF.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.textF.keyboardType = UIKeyboardTypeDefault;
    }
    if (self.gq_textFBeginBlock) {
        self.gq_textFBeginBlock(textField.text);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    if (self.gq_textFEndBlock) {
        self.gq_textFEndBlock(textField.text);
    }
}
- (void)textFChange:(NSNotification *)noti {
    if (noti.object == self.textF) {
        if (self.gq_textFBlock) {
            self.gq_textFBlock(self.textF.text);
        }
    }
    if (self.gq_textFieldType == GQTextFieldTypeOfPhone) {
//        //限制长度
//        if (self.textF.text.length > 13) {
//            self.textF.text = _preText;
//            return;
//        }
//
//        //光标位置
//        NSUInteger position = [self.textF offsetFromPosition:self.textF.beginningOfDocument toPosition:self.textF.selectedTextRange.start];
//
//        //是否正在添加
//        BOOL isAdd = self.textF.text.length > _preText.length ? YES : NO;
//
//        //去“ ”后的文字
//        NSString *currentStr = [self.textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//        //转临时可变字符串
//        NSMutableString *tempStr = [currentStr mutableCopy];
//
//        //计算拥有“ ”的个数
//        int spaceCount = 0;
//        if (currentStr.length < 4 && currentStr.length > -1) {
//            spaceCount = 0;
//        }else if (currentStr.length < 8 && currentStr.length > 3) {
//            spaceCount = 1;
//        }else if (currentStr.length < 12 && currentStr.length > 7) {
//            spaceCount = 2;
//        }
//
//        //循环添加“ ”
//        for (int i = 0; i < spaceCount; i++) {
//            if (i == 0) {
//                [tempStr insertString:@" " atIndex:3];
//            }else if (i == 1) {
//                [tempStr insertString:@" " atIndex:8];
//            }
//        }
//
//        //赋值回textField
//        self.textF.text = tempStr;
//
//        //计算光标的偏移位置
//        if (isAdd) {
//            if (currentStr.length == 4 || currentStr.length == 8) position++;
//        }else {
//            if (position == 4 || position == 9) position--;
//        }
//
//        //设置光标的偏移位置
//        UITextPosition *targetPosition = [self.textF positionFromPosition:[self.textF beginningOfDocument] offset:position];
//        [self.textF setSelectedTextRange:[self.textF textRangeFromPosition:targetPosition toPosition:targetPosition]];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.gq_textFieldShouldReturnBlock) {
        self.gq_textFieldShouldReturnBlock(textField);
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.gq_textFieldType == GQTextFieldTypeOfPhone) _preText = textField.text;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (self.gq_textFieldType == GQTextFieldTypeOfPhone) {
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    } else if (self.gq_textFieldType == GQTextFieldTypeOfMsgCode){
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    } else if (self.gq_textFieldType == GQTextFieldTypeOfYanzhenCode){
        if (existedLength - selectedLength + replaceLength > 4) {
            return NO;
        }
    } else if (self.gq_textFieldType == GQTextFieldTypeOfPassword){
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    } else if(self.gq_textFieldType == GQTextFieldTypeOfBankCard){
        if (existedLength - selectedLength + replaceLength > 32) {
            return NO;
        }
    } else if(self.gq_textFieldType == GQTextFieldTypeOfOther){
        if (existedLength - selectedLength + replaceLength > self.gq_typeOfOtherMaxLength) {
            return NO;
        }
    }
    return YES;
}
- (void)setGq_textFieldType:(GQTextFieldType)gq_textFieldType
{
    _gq_textFieldType = gq_textFieldType;
    if (gq_textFieldType == GQTextFieldTypeOfMsgCode) {
        self.contentVCons.constant = 80;
        [self.contentV addSubview:self.msgBtn];
    } else if (gq_textFieldType == GQTextFieldTypeOfPassword) {
        self.contentVCons.constant = 48;
        self.textF.secureTextEntry = YES;
        [self.contentV addSubview:self.watchBtn];
    } else {
        self.contentVCons.constant = 0;
    }
}

- (void)msgBtnClicked:(UIButton *)msgBtn {
    if (self.gq_msgBtnBlock) {
        self.gq_msgBtnBlock(msgBtn);
    }
}
- (void)gq_msgBtnUIChangeWhenClick {
    [self.msgBtn gq_timeCountDownStartWithTime:60 title:@"获取验证码" countDownTitle:@"s" normalBgColor:[UIColor clearColor] selectBgColor:[UIColor clearColor] normalTitleColor:[UIColor redColor] selectTitleColor:[UIColor redColor]];
}
- (void)watchBtnClicked:(UIButton *)watchBtn {
    watchBtn.selected = !watchBtn.selected;
    self.textF.secureTextEntry = !watchBtn.selected;
}
- (void)gq_setPlaceColor:(UIColor *)placeColor placeStr:(NSString *)placeStr {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeStr attributes:@{NSForegroundColorAttributeName:placeColor}];
    self.textF.attributedPlaceholder = attrString;
}

#pragma mark - lazy
- (UIButton*)msgBtn {
    if (_msgBtn == nil) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _msgBtn.frame = CGRectMake(0, 0, 80, 30);
        _msgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_msgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_msgBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _msgBtn.backgroundColor = [UIColor clearColor];
        _msgBtn.layer.cornerRadius = 2;
        _msgBtn.layer.masksToBounds = YES;
        [_msgBtn addTarget:self action:@selector(msgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgBtn;
}
- (UIButton *)watchBtn {
    if (_watchBtn == nil) {
        _watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _watchBtn.frame = CGRectMake(0, 0, 48, 36);
        [_watchBtn setImage:[UIImage imageNamed:@"eye_on"] forState:0];
        [_watchBtn setImage:[UIImage imageNamed:@"eye_off"] forState:UIControlStateSelected];
        [_watchBtn addTarget:self action:@selector(watchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchBtn;
}
@end
