local Sproto = require "sproto"

local M = {}

local sproto_schema = [[
.simple_message {
    a 0: integer
    b 1: integer
    c 2: *integer
}

.Person {
    name 0 : string
    id 1 : integer
    email 2 : string

    .PhoneNumber {
        number 0 : string
        type 1 : integer
    }

    phone 3 : *PhoneNumber
}

.normal_message {
    person 0 : *Person
}

]]

function M.create_sproto_codec()
    return Sproto.parse(sproto_schema)
end

M.serialize_messages = {
    simple_message = {a = 1, b = 2, c = {1, 2, 3}},
    normal_message = { -- see https://github.com/cloudwu/sproto
        person = {
            {
                name = "Alice",
                id = 10000,
                phone = {
                    { number = "123456789" , type = 1 },
                    { number = "87654321" , type = 2 },
                }
            },
            {
                name = "Bob",
                id = 20000,
                phone = {
                    { number = "01234567890" , type = 3 },
                }
            }
        }
    }
}

return M
