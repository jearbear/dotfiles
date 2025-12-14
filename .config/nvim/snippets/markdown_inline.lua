return {
    { prefix = "d", body = "# $CURRENT_YEAR.$CURRENT_MONTH.$CURRENT_DATE\n" },
    { prefix = ".", body = "- [ ] " },
    { prefix = "h1", body = "# " },
    { prefix = "h2", body = "## " },
    { prefix = "h3", body = "### " },
    { prefix = "h4", body = "#### " },
    { prefix = "h5", body = "##### " },
    { prefix = "h6", body = "###### " },
    { prefix = "l", body = "[${1}](${0})" },
    { prefix = "c", body = "```\n${0}\n```" },
}
