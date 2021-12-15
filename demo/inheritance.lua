dofile '../classified.lua'

class 'Base' {
    method = function(self)
        print('this is the base class')
    end
}

class 'Sub' : extends 'Base' {
    method2 = function(self)
        print('this is the subclass')
    end
}

local sub = Sub()
sub:method()
sub:method2()