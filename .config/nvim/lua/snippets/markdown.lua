return {
    { prefix = "d", body = "# $CURRENT_YEAR.$CURRENT_MONTH.$CURRENT_DATE\n" },
    { prefix = ".", body = "- [ ] " },
    { prefix = "h", body = "# " },
    { prefix = "hh", body = "## " },
    { prefix = "hhh", body = "### " },
    { prefix = "h3", body = "### " },
    { prefix = "l", body = "[${1}](${0})" },
    { prefix = "c", body = "```\n${0}\n```" },
}
