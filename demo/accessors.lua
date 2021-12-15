dofile '../classified.lua'

class 'GetterTest' {
    prop = property {
        get = function(self)
            print('getter accessed')
            return 'hi'
        end
    }
}

local m = GetterTest()
print(m.prop)
m.prop = 'oops' -- THIS WILL ERROR!
