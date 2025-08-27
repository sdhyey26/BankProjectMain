#!/usr/bin/env python3
import os
import re
from typing import List, Tuple


COMMENT_EXTENSIONS_GENERIC = {".java", ".js", ".ts"}
HTML_LIKE_EXTENSIONS = {".jsp", ".html", ".htm", ".xhtml"}
CSS_EXTENSIONS = {".css"}
XML_EXTENSIONS = {".xml"}


def read_text(file_path: str) -> str:
    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


def write_text(file_path: str, content: str) -> None:
    with open(file_path, "w", encoding="utf-8", errors="ignore") as f:
        f.write(content)


def strip_c_style_and_line_comments(source: str) -> str:
    """
    Remove // line comments and /* */ block comments while preserving strings
    (single, double, template backtick). Works for Java/JS-like syntax.
    """
    i = 0
    n = len(source)
    out_chars: List[str] = []
    in_single = False
    in_double = False
    in_backtick = False
    in_block_comment = False
    in_line_comment = False

    while i < n:
        ch = source[i]
        nxt = source[i + 1] if i + 1 < n else ""

        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
                continue
            i += 1
            continue

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                out_chars.append(ch)
            i += 1
            continue

        if not (in_single or in_double or in_backtick):
            if ch == "/" and nxt == "/":
                in_line_comment = True
                i += 2
                continue
            if ch == "/" and nxt == "*":
                in_block_comment = True
                i += 2
                continue

        if not (in_double or in_backtick) and ch == "'":
            out_chars.append(ch)
            if i == 0 or source[i - 1] != "\\":
                in_single = not in_single
            i += 1
            continue

        if not (in_single or in_backtick) and ch == '"':
            out_chars.append(ch)
            if i == 0 or source[i - 1] != "\\":
                in_double = not in_double
            i += 1
            continue

        if not (in_single or in_double) and ch == "`":
            out_chars.append(ch)
            if i == 0 or source[i - 1] != "\\":
                in_backtick = not in_backtick
            i += 1
            continue

        out_chars.append(ch)
        i += 1

    return "".join(out_chars)


def strip_html_comments(source: str) -> str:
    # Remove HTML comments <!-- ... --> (including multiline)
    return re.sub(r"<!--([\s\S]*?)-->", "", source)


def strip_jsp_comments(source: str) -> str:
    # Remove JSP comments <%-- ... --%>
    return re.sub(r"<%--([\s\S]*?)--%>", "", source)


def strip_css_comments(source: str) -> str:
    # CSS supports only /* */ comments
    return re.sub(r"/\*([\s\S]*?)\*/", "", source)


def strip_js_comments_in_script_blocks(source: str) -> str:
    # Identify <script ...> ... </script> blocks and strip JS comments inside
    def repl(match: re.Match) -> str:
        open_tag = match.group(1)
        script_content = match.group(2)
        close_tag = match.group(3)
        cleaned = strip_c_style_and_line_comments(script_content)
        return f"{open_tag}{cleaned}{close_tag}"

    pattern = re.compile(r"(<script\b[^>]*>)([\s\S]*?)(</script>)", re.IGNORECASE)
    return pattern.sub(repl, source)


def strip_css_comments_in_style_blocks(source: str) -> str:
    def repl(match: re.Match) -> str:
        open_tag = match.group(1)
        style_content = match.group(2)
        close_tag = match.group(3)
        cleaned = strip_css_comments(style_content)
        return f"{open_tag}{cleaned}{close_tag}"

    pattern = re.compile(r"(<style\b[^>]*>)([\s\S]*?)(</style>)", re.IGNORECASE)
    return pattern.sub(repl, source)


def strip_comments_in_jsp_scriptlets(source: str) -> str:
    """Apply C-style comment stripping inside JSP scriptlet blocks (<% ... %>, <%= ... %>, <%@ ... %>)."""
    def repl(match: re.Match) -> str:
        open_tag = match.group(1)
        scriptlet_content = match.group(2)
        close_tag = match.group(3)
        cleaned = strip_c_style_and_line_comments(scriptlet_content)
        return f"{open_tag}{cleaned}{close_tag}"

    pattern = re.compile(r"(<%(?:@|=|!|\s)?)([\s\S]*?)(%>)", re.IGNORECASE)
    return pattern.sub(repl, source)


def process_file(file_path: str) -> Tuple[bool, str]:
    _, ext = os.path.splitext(file_path)
    try:
        original = read_text(file_path)
    except Exception:
        return False, "read_error"

    updated = original

    if ext in COMMENT_EXTENSIONS_GENERIC:
        updated = strip_c_style_and_line_comments(updated)
    elif ext in HTML_LIKE_EXTENSIONS:
        updated = strip_jsp_comments(updated)
        updated = strip_html_comments(updated)
        updated = strip_js_comments_in_script_blocks(updated)
        updated = strip_css_comments_in_style_blocks(updated)
        updated = strip_comments_in_jsp_scriptlets(updated)
    elif ext in CSS_EXTENSIONS:
        updated = strip_css_comments(updated)
    elif ext in XML_EXTENSIONS:
        updated = strip_html_comments(updated)
    else:
        return False, "skipped"

    if updated != original:
        write_text(file_path, updated)
        return True, "modified"
    return True, "unchanged"


def should_process_path(path: str) -> bool:
    # Limit to project source tree
    return "/BankProjectMain/" in path


def main() -> None:
    root = "/workspace"
    changed = 0
    touched = 0
    for dirpath, dirnames, filenames in os.walk(root):
        # Skip .git
        dirnames[:] = [d for d in dirnames if d != ".git" and d != "lib"]
        for fname in filenames:
            fpath = os.path.join(dirpath, fname)
            if not should_process_path(fpath):
                continue
            ok, status = process_file(fpath)
            if ok and status != "skipped":
                touched += 1
                if status == "modified":
                    changed += 1
    print(f"Processed {touched} files; modified {changed} files.")


if __name__ == "__main__":
    main()

