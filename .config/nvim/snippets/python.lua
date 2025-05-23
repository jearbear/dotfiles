return {
    { prefix = "dm", body = "def ${1}(self${2})\n\t${0}" },
    { prefix = "test", body = "def test_${1}(self, s):\n\tpass${0}" },
    { prefix = "pmp", body = '@pytest.mark.parametrize("${1}", [${0}])' },
    { prefix = "get", body = '${1}.objects.get(id="${0}")' },
    { prefix = "fil", body = "${1}.objects.filter(${0})" },
    { prefix = "db", body = 'print(f"\\nDEBUG: {${0}=}\\n")' },
}
