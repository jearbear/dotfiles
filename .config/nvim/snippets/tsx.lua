return {
    { prefix = "t", body = 't("${0}")' },
    { prefix = "l", body = "console.log(`$\\{${0}\\}`)" },
    { prefix = "ef", body = "export default function ${1}(${2}) {\n\t${0}\n}" },
    { prefix = "u", body = "undefined" },
}
