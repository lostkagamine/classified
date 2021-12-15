dofile '../classified.lua'

class 'StaticTest' {
    static {
        AField = 'foobar'
    }
}

print(StaticTest.AField)