-- Rich text editors express structure in ways markdown readers cannot see:
-- emphasis as inline CSS, links behind redirectors, tables with no header.
-- Undo all of that so the markdown comes out clean.

local function weight_is_bold(style)
  local weight = style:match("font%-weight%s*:%s*(%w+)")
  if not weight then return false end
  if weight == "bold" or weight == "bolder" then return true end
  local n = tonumber(weight)
  return n ~= nil and n >= 600
end

-- Emphasis carried by a style attribute instead of a <strong>/<em> tag.
function Span(el)
  local style = (el.attributes["style"] or ""):lower()
  local content = el.content

  if style:match("text%-decoration[^;]*line%-through") then
    content = { pandoc.Strikeout(content) }
  end
  if style:match("font%-style%s*:%s*italic") then
    content = { pandoc.Emph(content) }
  end
  if weight_is_bold(style) then
    content = { pandoc.Strong(content) }
  end

  return content -- unwrap; the styling itself is noise
end

local function percent_decode(s)
  s = s:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  -- A decoded space would break the link target, so put it straight back.
  return (s:gsub(" ", "%%20"))
end

-- Google Docs rewrites every link to point at google.com/url?q=<real target>.
function Link(el)
  local query = el.target:match("^https?://[^/]*google%.[^/]*/url%?(.+)$")
  if not query then return nil end
  for key, value in query:gmatch("([^&=]+)=([^&]*)") do
    if key == "q" or key == "url" then
      el.target = percent_decode(value)
      return el
    end
  end
end

-- Editors wrap each list item's text in a <p>, which makes every list loose.
local function tighten(items)
  for i, blocks in ipairs(items) do
    if #blocks == 1 and blocks[1].t == "Para" then
      items[i] = { pandoc.Plain(blocks[1].content) }
    end
  end
  return items
end

local function tighten_list(el)
  el.content = tighten(el.content)
  return el
end

BulletList = tighten_list
OrderedList = tighten_list

local function row_is_blank(row)
  for _, cell in ipairs(row.cells) do
    if pandoc.utils.stringify(cell.contents):match("%S") then return false end
  end
  return true
end

-- Pasted tables carry no <thead>, so pandoc invents an empty header and
-- demotes the real one into the body. Promote it back.
function Table(el)
  for _, row in ipairs(el.head.rows) do
    if not row_is_blank(row) then return nil end -- a real header is already there
  end

  local body = el.bodies[1]
  if not body or #body.body == 0 then return nil end

  el.head = pandoc.TableHead({ table.remove(body.body, 1) })
  return el
end
