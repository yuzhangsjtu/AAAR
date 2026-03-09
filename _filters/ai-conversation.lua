-- ai-conversation.lua
-- Quarto Lua filter for rendering AI conversation blocks
--
-- Syntax:
--
--   ::: {.conversation model="Claude Sonnet 4"}
--   :::: {.user}
--   Your prompt here
--   ::::
--   :::: {.assistant}
--   AI response here
--   ::::
--   :::
--
--   ::: {.prompt}
--   Standalone prompt block
--   :::

local function escape_html(s)
  return s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")
end

local copy_js = "var t=this.closest('.chat-message').querySelector('.chat-body').innerText;"
  .. "navigator.clipboard.writeText(t);"
  .. "this.textContent='\\u2713 \\u5df2\\u590d\\u5236';"
  .. "setTimeout(function(){this.textContent='\\u590d\\u5236'}.bind(this),1500)"

-- Build HTML for a single chat message
local function html_message(role, label, content, show_copy)
  local cls = "chat-message chat-" .. role
  local result = pandoc.List()

  local header_inner = '<span class="chat-role">' .. escape_html(label) .. '</span>'
  if show_copy then
    header_inner = header_inner
      .. '<button class="chat-copy-btn" onclick="' .. copy_js .. '">\u{590D}\u{5236}</button>'
  end

  result:insert(pandoc.RawBlock("html",
    '<div class="' .. cls .. '"><div class="chat-header">'
    .. header_inner .. '</div><div class="chat-body">'))
  result:extend(content)
  result:insert(pandoc.RawBlock("html", '</div></div>'))
  return result
end

-- Build LaTeX for a single chat message
local function latex_message(role, label, content)
  local result = pandoc.List()
  if role == "user" or role == "prompt" then
    result:insert(pandoc.RawBlock("latex", '\\begin{aichatuser}'))
  else
    result:insert(pandoc.RawBlock("latex",
      '\\begin{aichatassistant}{' .. label .. '}'))
  end
  result:extend(content)
  if role == "user" or role == "prompt" then
    result:insert(pandoc.RawBlock("latex", '\\end{aichatuser}'))
  else
    result:insert(pandoc.RawBlock("latex", '\\end{aichatassistant}'))
  end
  return result
end

function Div(el)
  -- ── .conversation container ──
  if el.classes:includes("conversation") then
    local model = el.attributes.model or "AI"
    local is_html = FORMAT:match("html")
    local is_latex = FORMAT:match("latex")

    local result = pandoc.List()
    if is_html then
      result:insert(pandoc.RawBlock("html", '<div class="conversation">'))
    end

    for _, block in ipairs(el.content) do
      if block.t == "Div" then
        if block.classes:includes("user") then
          if is_html then
            result:extend(html_message("user", "Prompt", block.content, true))
          elseif is_latex then
            result:extend(latex_message("user", "Prompt", block.content))
          end
        elseif block.classes:includes("assistant") then
          local msg_model = block.attributes.model or model
          if is_html then
            result:extend(html_message("assistant", msg_model, block.content, false))
          elseif is_latex then
            result:extend(latex_message("assistant", msg_model, block.content))
          end
        end
      end
    end

    if is_html then
      result:insert(pandoc.RawBlock("html", '</div>'))
    end
    return result

  -- ── .prompt standalone block ──
  elseif el.classes:includes("prompt") then
    local is_html = FORMAT:match("html")
    local is_latex = FORMAT:match("latex")

    if is_html then
      return html_message("prompt", "Prompt", el.content, true)
    elseif is_latex then
      return latex_message("prompt", "Prompt", el.content)
    end
  end
end
