return {
    { prefix = "d", body = "dbg(${0})" },
    { prefix = "m", body = "%{${0}}" },
    { prefix = "map", body = "Enum.map(${0})" },
    { prefix = "filter", body = "Enum.filter(${0})" },
    { prefix = "t", body = "${1}_([${2}], [${3}])" },
    { prefix = "t0", body = "${1}_([${0}])" },
    { prefix = "defc", body = "defcomponent :${1}, [${2}], ${3|true,false|} do\n\t${0}\nend" },
    { prefix = "test", body = 'test "${1}" do\n\t${0}\nend' },
}
