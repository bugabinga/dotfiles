-- TODO: map syntax elements to pretty symbols
-- function = ƒn⟮
-- return   = ⏎
-- end      = ⟯
-- (        = ｟
-- )        = ｠
-- for
-- do       = ⟮
-- while    = Ꝏ
-- if
-- then     = ⟮
-- else
-- elseif
-- {        = ⎨
-- }        = ⎬
-- ...      = …
-- ..       = ‥
-- --       = ―
-- [[       = ⟪
-- ]]       = ⟫

-- FIXME: conceal feature is too simple
-- it affects all characters in comments and strings
-- that could maybe be circumvented with complex matches and regions, but integ with TS would be more elegant
-- it changes the highlighting of concealed stuff
-- furthermore, i struggled to get the quoting of special character right when calling syntax command from lua

vim.opt_local.conceallevel = 2
