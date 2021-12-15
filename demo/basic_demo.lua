dofile '../classified.lua'

class 'BasicClass' {
    __new = function(self, greeting)
        self.greeting = greeting
    end,
    greet = function(self)
        print(self.greeting)
    end
}

local inst = BasicClass('hello, world')
inst:greet()