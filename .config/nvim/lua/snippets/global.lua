return {
    { prefix = "(", body = "(${0})" },
    { prefix = "( ", body = "(\n\t${0}\n)" },
    { prefix = "{", body = "{${0}}" },
    { prefix = "{ ", body = "{\n\t${0}\n}" },
    { prefix = "[", body = "[${0}]" },
    { prefix = "[ ", body = "[\n\t${0}\n]" },
    { prefix = '"', body = '"${0}"' },
    { prefix = '"""', body = '"""${0}"""' },
}
