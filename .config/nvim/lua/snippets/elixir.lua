return {
    { prefix = "m", body = "%{${0}}" },
    { prefix = "map", body = "Enum.map(${0})" },
    { prefix = "filter", body = "Enum.filter(${0})" },
    { prefix = "defc", body = 'def ${1}(assigns) do\n\t~H"""\n${0}\n"""\nend' },
    { prefix = "test", body = 'test "${1}" do\n\t${0}\nend' },
}
